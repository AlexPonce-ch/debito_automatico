from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lit, udf
import json
import pytz
from datetime import datetime, date
import jaydebeapi 

# 1. Sesión de Spark 
spark = SparkSession.builder \
    .appName("job_debito_automatico_pyspark") \
    .config("spark.jars", "glue/conector/mysql-connector-j-9.2.0.jar")\
    .getOrCreate()
    
def get_mysql_connection():
    jdbc_driver = "com.mysql.cj.jdbc.Driver"
    jdbc_url = "jdbc:mysql://localhost:3306/ods_maestro_saldo"
    connection_properties = {
        "user": "root",
        "password": "admin",
        "driver": jdbc_driver
    }
    
    conn = jaydebeapi.connect(
        jdbc_driver,
        jdbc_url,
        connection_properties
    )
    return conn

print("SparkSession creada correctamente")


# --- obtener el parametro Json en la posicion 141 

def verificar_json_obtenido(pa_id=141):
    conn = cursor = None
    try:
        conn = get_mysql_connection()
        cursor = conn.cursor()

        print(f"\n Ejecutando SP pa_obtener_parametro_jdbc({pa_id})...")
        cursor.execute(f"CALL pa_obtener_parametro_jdbc({pa_id})")

        row = cursor.fetchone()
        if row and row[0]:
            pa_valor = row[0]

            try:
                # Retorna el JSON como string directamente
                json.loads(pa_valor)  # Solo para validar que esté bien formado
                return pa_valor
            except json.JSONDecodeError as e:
                print(f" Error de formato JSON: {str(e)}")
                return None
        else:
            print(" No se encontró el parámetro o está vacío.")
            return None

    except Exception as e:
        print(f" Error al ejecutar el SP: {str(e)}")
        return None
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


def debe_ejecutarse(pa_valor_json: str) -> bool:
    tz = pytz.timezone("America/Guayaquil")
    dfechaproceso = datetime.now(tz)

    hora_actual = dfechaproceso.strftime("%H:%M")
    dia_actual = dfechaproceso.strftime("%A").lower()
    dia_mes_actual = dfechaproceso.day

    ejecutar = False

    try:
        data = json.loads(pa_valor_json)
        horarios = data["proceso"]["horarios"]

        for horario in horarios:
            if not horario.get("activo"):
                continue

            hora_ejecucion = horario.get("hora")
            frecuencia = horario.get("frecuencia")
            parametros = horario.get("parametros", {})

            dia_semana = parametros.get("dia_semana")
            dia_mes = parametros.get("dia_mes")

            if frecuencia == "diaria" and "07:00" == hora_ejecucion: #hora_actual 
                ejecutar = True
            elif frecuencia == "semanal" and dia_semana and dia_semana.lower() == dia_actual and hora_actual == hora_ejecucion:
                ejecutar = True
            elif frecuencia == "mensual" and dia_mes and int(dia_mes) == dia_mes_actual and hora_actual == hora_ejecucion:
                ejecutar = True

            if ejecutar:
                print(f" Ejecutando proceso de débitos a las {hora_actual} ({frecuencia})")
                break

    except Exception as e:
        print(f" Error al procesar el JSON: {str(e)}")

    return ejecutar


if __name__ == "__main__":
    print("=== Verificación de ejecución de proceso de débitos ===")
    pa_valor_json = verificar_json_obtenido()

    if pa_valor_json and debe_ejecutarse(pa_valor_json):
        print(" Proceso AUTORIZADO para ejecutarse.")
        # Acá podés agregar la siguiente lógica, como llamar al SP que inserta el batch
    else:
        print("Proceso NO se ejecuta en este momento.")
        