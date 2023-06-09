# coderhouse_dataengineer_48145
Repositorio de entregables para la cursada 48145 de Data Engineer - Coderhouse

#### Proposito

Creación de una ETL, para extracción de informaciíon climatica (ultimos 8 dias) de todos los aeropuertos 
comerciales del estado de la Floria en los Estados unidos. La informaciíon geografica se encuentra 
complementada con la información geografica del aeropuerto.

## API

La API utlizada para las entregas del curso es https://docs.aviationapi.com/

Las preguntas mas importantes a resolver con estas consultas y ETL son las siguientes:

1. ¿Cual es la información geografica y administrativa de los aeropuertos localizados en el estado de la florida en USA?
2. ¿Cual es la información climatica de todos los aeropuertos listados en la pregunta anterior?

##### Control de Cambio - Segunda Entrega

Para la segunda entrega se realiizaron estas transformaciones usando Pandas.
Lista de transformaciones en la data:

1. En el campo site_number eliminar los simbolos de asteriscos
2. En el campo facility_name realizar el proceso de convertir todas las letras a minisculas y la primera en mayuscula de los nombres de los aeropuertos para mejorar la lectura visual.
3. En los campos state_full y county tambien realizar el proceso de convertir todas las letras a minisculas y la primera en mayuscula.
4. Convertir los campos N/Y en tipo boolean

Se utilizo sqlalchemy para crear el engine de carga en Amazon Redshift

##### Control de Cambio - Tercera Entrega

Para la tercera entrega se realiza la integración y vinculación con Airflow, por medio de Docker.
El objetivo es utilizar airflow en conjunto con la conexión a Amazon Redshift donde se convierta el
codigo del Python Notebook a un DAG con las mismas funciona de ETL que las entregas pasadas.

1. Configurar la conexión en airflow a Amazon Redshift. Con el nombre de "DataWareHouse AWS"
   Descripción de la conexión: "Repositorio final donde va a quedar alojada la data procesada de la información climática de los aeropuertos de la Florida, cada minuto."
2. Implementación de dos PythonOperator para ejecutar las tareas de ETL.