from datetime import datetime, timedelta
from pathlib import Path
from email.policy import default
from airflow import DAG
from airflow.providers.amazon.aws.operators.redshift import RedshiftSQLOperator
from airflow.operators.python_operator import PythonOperator

# Importar las librerias necesarias para la ETL
from sqlalchemy import create_engine
import pandas as pd
import numpy as np
import requests
import csv
import os

# Obtener el dag del directorio
dag_path = os.getcwd()

default_args={
    'owner': 'JulianFernandez',
    'retries':5,
    'retry_delay': timedelta(minutes=5)
}

def climate_extract_transform(exec_date):

    print(f"Adquiriendo data Climatica para la fecha: {exec_date}")
    date = datetime.strptime(exec_date, '%Y-%m-%d %H')
    file_date_path = f"{date.strftime('%Y-%m-%d')}/{date.hour}"
    # inicializar lista de lista con los nombres de los aeropuertos de la florida y los codigos FAA y ICAO
    data = [ 
                ['Daytona Beach', 'DAB','KDAB'],
                #['Fort Lauderdale',	'FLL',	'KFLL'],
                ['Fort Myers', 'RSW', 'KRSW'],
                ['Fort Walton Beach', 'VPS', 'KVPS'],
                ['Gainesville', 'GNV', 'KGNV'],
                ['Jacksonville', 'JAX', 'KJAX'],
                ['Key West', 'EYW', 'KEYW'],
                ['Melbourne', 'MLB', 'KMLB'],
                ['Miami', 'MIA', 'KMIA'],
                ['Orlando', 'MCO', 'KMCO'],
                ['Panama City', 'ECP', 'KECP'],
                ['Pensacola', 'PNS', 'KPNS'],
                ['Punta Gorda', 'PGD', 'KPGD'],
                ['Sanford', 'SFB', 'KSFB'],
                ['Sarasota', 'SRQ', 'KSRQ'],
                ['St. Petersburg', 'PIE', 'KPIE'],
                ['Tallahassee', 'TLH', 'KTLH'],
                ['Tampa', 'TPA', 'KTPA'], 
                ['West Palm Beach', 'PBI', 'KPBI']
    ]

    # Creacion del dataframe 
    df_airports = pd.DataFrame(data, columns=['Name', 'FAA', 'ICAO'])

    # Extraccion de datos climaticos: API
    get_params = '?apt=' + ",".join(df_airports.FAA.values.tolist())
    url_endpoint_weather = 'https://api.aviationapi.com/v1/weather/metar' + get_params

    # Consulta de información geografica por medio de un Request HTTP
    headers = {'Accept': 'application/json'}
    r_weather = requests.get(url_endpoint_weather, headers=headers)

    # Conversión de json a objeto en python 
    airport_weather_dict = r_weather.json()

    print(f"Transformando la data para la fecha: {exec_date}")

    # y luego transformar los diccionarios en DataFrames
    temp = []

    # ajuste del objeto json con el objetivo de transformar todos los niveles del objeto en una tabla columnar.
    for k, vals in airport_weather_dict.items():

        try:
            sky_conditions = vals['sky_conditions'][0]
            sky_conditions["sky_conditionscoverage"] = sky_conditions.pop("coverage")
            sky_conditions["sky_conditionsbase_agl"] = sky_conditions.pop("base_agl")
        except:
            sky_conditions = 0
        
        vals.update(sky_conditions)
        temp.append(vals)

    df_airport_weather = pd.DataFrame(temp)
    
    # limpieza de información raw (datos crudos) la cual es redundante para el dataset.
    del df_airport_weather['raw']
    del df_airport_weather['sky_conditions']
    
    # Cambio de tipos de datos de object (strings) a su respectivo formato
    convert_dict = {
                        'temp'       : 'float', 
                        'dewpoint'   : 'float', 
                        'wind'       : 'int', 
                        'wind_vel'   : 'int',
                        'visibility' : 'float', 
                        'alt_hg'     : 'float', 
                        'alt_mb'     : 'float', 
                        'sky_conditionsbase_agl': 'float'
                    }
    
    #df_airport_weather = df_airport_weather.astype(convert_dict)

    print(f"Cargando la data para la fecha: {exec_date}")
    
    return df_airport_weather.to_json()
 
def climate_load(dt):
    print(f"Seguimiento:", dt)
    # Transformacion de json a dataframe
    df_airport_weather = pd.read_json(dt, orient='columns')
    print(f"Seguimiento:", df_airport_weather)
    
    # Datos de la conexion
    url       = "*.redshift.amazonaws.com" 
    port      = "5439"
    data_base = "data-engineer-database" 
    user      = "*******"
    pwd       = "*******"
    myschema  = "*******" 

    # Se crear la conexión
    conn = create_engine(f'postgresql://{user}:{pwd}@{url}:{port}/{data_base}')
    df_airport_weather.to_sql('proyecto_weather', conn, index=False, if_exists='append', schema=myschema)
    return "End Load"

dag_con_aws_refshift =  DAG(
    default_args=default_args,
    dag_id='dag_con_aws_refshift',
    description= 'Importador al DW con informacion climatica',
    start_date=datetime(2023,5,16),
    schedule_interval='0 * * * *',
    catchup=False
)
          
task_0_setup = RedshiftSQLOperator(
    task_id='setup__create_table',
    redshift_conn_id= 'DataWareHouse_AWS',
    sql="""   
        CREATE TABLE IF NOT EXISTS proyecto_weather(
        station_id              VARCHAR(4)   NOT NULL
        ,temp                   NUMERIC(4,1) NOT NULL
        ,dewpoint               NUMERIC(4,1) NOT NULL
        ,wind                   INTEGER      NOT NULL
        ,wind_vel               INTEGER      NOT NULL
        ,visibility             NUMERIC(4,1) NOT NULL
        ,alt_hg                 NUMERIC(5,2) NOT NULL
        ,alt_mb                 NUMERIC(6,1) NOT NULL
        ,wx                     VARCHAR(30)
        ,auto_report            VARCHAR(4)   NOT NULL
        ,category               VARCHAR(3)   NOT NULL
        ,report_type            VARCHAR(5)   NOT NULL
        ,time_of_obs            VARCHAR(20)  NOT NULL
        ,sky_conditionscoverage VARCHAR(3)   NOT NULL
        ,sky_conditionsbase_agl INTEGER 
        );
    """,
    dag=dag_con_aws_refshift,
)

task_1 = PythonOperator(
    task_id='process_extract_tranform',
    python_callable=climate_extract_transform,
    op_args=["{{ ds }} {{ execution_date.hour }}"],
    dag=dag_con_aws_refshift,
) 

task_2 = PythonOperator(
    task_id='process_load',
    python_callable=climate_load,
    op_args=["{{ti.xcom_pull(task_ids='process_extract_tranform')}}"],
    dag=dag_con_aws_refshift,
) 

#task_3 = RedshiftSQLOperator(
#    task_id='process_load',
#    sql="{{ti.xcom_pull(task_ids='process_extract_tranform')}}",
#    redshift_conn_id= 'DataWareHouse_AWS',
#    params = {},
#    dag=dag_con_aws_refshift,
#)

task_0_setup >> task_1 >> task_2