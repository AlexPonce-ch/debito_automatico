from pyspark.sql import SparkSession

spark = SparkSession.builder\
    .appName("pruebas")\
    .getOrCreate()
    
jdbc_url = "jdbc:mysql://localhost:3306/ods_maestro_saldo"
connection_properties ={
    "user":"root",
    "password":"admin",
    "driver":"com.mysql.cj.jdbc.Driver"
}


sp_name = "pa_mdp_c_debito_pendiente"

# Suponiendo que tu SP acepta parámetros
param1_value = '2025-03-24'
param2_value = 100

query = f"CALL {sp_name}({param1_value})"

result_df = spark.read \
    .format("jdbc") \
    .option("url", jdbc_url) \
    .option("query", query) \
    .option("user", connection_properties) \
    .option("password", connection_properties) \
    .load()
    
result_df.show()
