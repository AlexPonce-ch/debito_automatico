from pyspark.sql import SparkSession
from awsglue.context import GlueContext
from pyspark.context import SparkContext
import mysql.connector
from datetime import datetime, date
import pytz
import json

# Crear Spark y Glue context
spark = SparkSession.builder \
    .appName("job_debito_automatico_v2") \
    .getOrCreate()

glueContext = GlueContext(spark.sparkContext)

# Fecha como parámetro para el SP
fecha = date.today().strftime("%Y-%m-%d")

# Conectar con MySQL
conexion = mysql.connector.connect(
    host="host.docker.internal",
    user="root",
    password="admin",
    database="ods_maestro_saldo",
    autocommit=False
)
cursor = conexion.cursor()

try:
    # Paso 1: Obtener parámetro de configuración con horarios
    pa_id = 141

    # Llamar al SP que tiene parámetro OUT
    cursor.execute("CALL pa_obtener_parametro(%s, @valor);", (pa_id,))
    cursor.execute("SELECT @valor;")
    resultado = cursor.fetchone()

    # Validar si se obtuvo el valor
    if not resultado or not resultado[0]:
        raise Exception(f"No se encontró el parámetro con pa_id = {pa_id}.")

    # Parsear el JSON del OUT param
    pa_valor = resultado[0]
    
    # Parsear el JSON
    data = json.loads(pa_valor)
    horarios = data["proceso"]["horarios"]

    # Obtener hora actual en Guayaquil
    tz = pytz.timezone("America/Guayaquil")
    dfechaproceso = datetime.now(tz)
    hora_actual = dfechaproceso.strftime("%H:%M")
    dia_actual = dfechaproceso.strftime("%A").lower()
    dia_mes_actual = dfechaproceso.day

    ejecutar = False

    # Verificar si hay coincidencia con la hora actual
    for horario in horarios:
        hora_ejecucion = horario["hora"]
        frecuencia = horario["frecuencia"]
        dia_semana = horario["parametros"]["dia_semana"]
        dia_mes = horario["parametros"]["dia_mes"]

        if frecuencia == "diaria" and '07:00' == hora_ejecucion: #hora actual
            ejecutar = True
        elif frecuencia == "semanal" and dia_semana and dia_actual == dia_semana.lower() and hora_actual == hora_ejecucion:
            ejecutar = True
        elif frecuencia == "mensual" and dia_mes and int(dia_mes) == dia_mes_actual and hora_actual == hora_ejecucion:
            ejecutar = True

        if ejecutar:
            print(f"Ejecutando proceso de débitos a las {hora_actual} ({frecuencia})")
            break

    if ejecutar:
        # Paso 2: Ejecutar SP para obtener datos
        print(f" Ejecutando SP pa_mdp_c_debito_pendiente('{fecha}')...")
        cursor.execute("CALL pa_mdp_c_debito_pendiente(%s)", (fecha,))
        rows = cursor.fetchall()
        columns = [desc[0] for desc in cursor.description]
        print(f" {len(rows)} registros obtenidos del SP.")

        # Crear DataFrame de Spark
        df = spark.createDataFrame(rows, columns)
        df.show(truncate=False)

        # Crear DynamicFrame para Glue
        dyf = glueContext.create_dynamic_frame.from_df(df, glueContext, "dyf_resultado")
        print(" DynamicFrame listo.")
        dyf.show()

    else:
        print(f"La hora actual {hora_actual} no coincide con ningún horario de ejecución válido.")

except mysql.connector.Error as err:
    print(f"Error en la base de datos: {err}")
    conexion.rollback()
except Exception as e:
    print(f"Error inesperado: {e}")
    conexion.rollback()
finally:
    if conexion.is_connected():
        cursor.close()
        conexion.close()
        print("Conexión a la base de datos cerrada.")
    spark.stop()
    print("Sesión de Spark cerrada.")
