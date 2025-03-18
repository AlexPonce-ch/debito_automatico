import json
import mysql.connector
from datetime import datetime
import pytz

# Configuración de conexión
conexion = mysql.connector.connect(
    host="localhost",
    user="root",
    password="admin",
    database="ods_maestro_saldo",
    autocommit=False  # Desactivamos el autocommit para control manual
)
cursor = conexion.cursor()

try:
    
    # TRUNCATE la tabla pa_mdp_i_debitos_pendientes para limpiarla antes de procesar
    print("Limpiando la tabla emi_t_debito_pendientes...")
    cursor.execute("TRUNCATE TABLE emi_t_debito_pendientes;")
    print("Tabla emi_t_debito_pendientes truncada.")
    
    
    # Obtener el parámetro de configuración (pa_valor) llamando al procedimiento almacenado
    pa_id = 141
    args = [pa_id, ""]  # Placeholder para el parámetro OUT
    result_args = cursor.callproc("sp_ObtenerParametro", args)

    # El valor de salida estará en el segundo elemento de result_args
    pa_valor = result_args[1]

    # Obtener la fecha y hora actual en la zona horaria de Guayaquil
    tz = pytz.timezone("America/Guayaquil")
    dfechaproceso = datetime.now(tz)

    if pa_valor:
        # Convertir el JSON a un diccionario de Python
        data = json.loads(pa_valor)

        # Extraer horarios de ejecución
        horarios = data["proceso"]["horarios"]

        # Obtener la hora actual en formato HH:MM y otros datos
        hora_actual = dfechaproceso.strftime("%H:%M")
        dia_actual = dfechaproceso.strftime("%A").lower()  # Día en minúsculas
        dia_mes_actual = dfechaproceso.day

        ejecutar = False

        for horario in horarios:
            hora_ejecucion = horario["hora"]
            frecuencia = horario["frecuencia"]
            dia_semana = horario["parametros"]["dia_semana"]
            dia_mes = horario["parametros"]["dia_mes"]

            if frecuencia == "diaria" and hora_ejecucion == "07:00":
                ejecutar = True
            elif frecuencia == "semanal" and dia_semana and dia_semana.lower() == dia_actual and hora_actual == hora_ejecucion:
                ejecutar = True
            elif frecuencia == "mensual" and dia_mes and int(dia_mes) == dia_mes_actual and hora_actual == hora_ejecucion:
                ejecutar = True

            if ejecutar:
                print(f"Ejecutando proceso de débitos a las {hora_actual} ({frecuencia})")
                break

        if ejecutar:
            # Llamar al procedimiento para insertar batch_proceso y obtener batch_id
            print("Llamando al procedimiento almacenado sp_insertar_batch_proceso...")
            cursor.execute("SET @batch_id = NULL;")
            cursor.execute("CALL sp_i_batch_proceso(@batch_id);")
            cursor.execute("SELECT @batch_id;")
            batch_id = cursor.fetchone()[0]

            if batch_id:
                print(f"Batch ID obtenido: {batch_id}")

                # Verificar si realmente se insertó el batch_id en la tabla
                cursor.execute("SELECT * FROM batch_procesos WHERE batch_id = %s;", (batch_id,))
                if cursor.fetchone():
                    print(f"Registro {batch_id} confirmado en batch_procesos.")
                else:
                    print(f"Error: Batch ID {batch_id} no encontrado en batch_procesos.")
                    conexion.rollback()
                    raise Exception("El procedimiento no insertó el registro en batch_procesos.")

                # Confirmar la transacción
                conexion.commit()

                # Llamar al procedimiento para procesar débitos
                codigo = 0
                mensaje = ' '
                args_debito = [batch_id, codigo, mensaje]  # Asegúrate de pasar 3 argumentos
                cursor.callproc("pa_mdp_i_debito_pendiente", args_debito)

                # Obtener los valores de salida del procedimiento
                for result in cursor.stored_results():
                    codigo, mensaje = result.fetchone()
                print(f"Código: {codigo}, Mensaje: {mensaje}")

                if codigo == 0:
                    print("Proceso completado correctamente.")
                    conexion.commit()
                else:
                    print("Error en el procedimiento almacenado.")
                    conexion.rollback()
            else:
                print("Error: No se pudo generar el batch_id.")
                conexion.rollback()

        else:
            print(f"La hora actual {hora_actual} no coincide con ningún horario de ejecución válido.")
    else:
        print("No se encontró el parámetro con pa_id = 141.")

except mysql.connector.Error as err:
    print(f"Error en la base de datos: {err}")
    conexion.rollback()
except Exception as e:
    print(f"Error inesperado: {e}")
    conexion.rollback()
finally:
    # Cerrar la conexión a la base de datos
    if conexion.is_connected():
        cursor.close()
        conexion.close()
        print("Conexión a la base de datos cerrada.")
