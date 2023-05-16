-- Nombre: SQL DW Structure Definition
-- Autor : Julian Fernandez
-- Fecha : 6 Abril - 2023
-- Ver   : 1.0.1
-- Objetivo: Creación de 2 tablas en el datawarehouse de Redshift.
--           La tabla 'proyecto_weather': contiene toda la información relacionada al clima en el momento de la consulta.
--           La tabla 'proyecto_airports': contiene el estado e información geografica de los aeropuertos consultados.

-- El objetivo es crear un DW con información de los aeropuertos localizados en la Florida estados unidos.
-- Se puede expandir el rango y escalar a todos los aeropuertos de los estados unidos.

CREATE TABLE proyecto_weather(

   station_id             VARCHAR(4)   NOT NULL
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
)


DISTSTYLE KEY
DISTKEY(station_id)
SORTKEY(time_of_obs);


CREATE TABLE proyecto_airports(

   site_number              VARCHAR(9)  NOT NULL PRIMARY KEY
  ,type                     VARCHAR(7)  NOT NULL
  ,facility_name            VARCHAR(32) NOT NULL
  ,faa_ident                VARCHAR(3)  NOT NULL
  ,icao_ident               VARCHAR(4)  NOT NULL
  ,region                   VARCHAR(3)  NOT NULL
  ,district_office          VARCHAR(3)  NOT NULL
  ,state                    VARCHAR(2)  NOT NULL
  ,state_full               VARCHAR(7)  NOT NULL
  ,county                   VARCHAR(12) NOT NULL
  ,city                     VARCHAR(33) NOT NULL
  ,ownership                VARCHAR(2)  NOT NULL
  ,use                      VARCHAR(2)  NOT NULL
  ,manager                  VARCHAR(34) NOT NULL
  ,manager_phone            VARCHAR(14) NOT NULL
  ,latitude                 VARCHAR(14) NOT NULL
  ,latitude_sec             VARCHAR(12) NOT NULL
  ,longitude                VARCHAR(15) NOT NULL
  ,longitude_sec            VARCHAR(12) NOT NULL
  ,elevation                INTEGER     NOT NULL
  ,magnetic_variation       VARCHAR(3)  NOT NULL
  ,tpa                      INTEGER 
  ,vfr_sectional            VARCHAR(12) NOT NULL
  ,boundary_artcc           VARCHAR(3)  NOT NULL
  ,boundary_artcc_name      VARCHAR(12) NOT NULL
  ,responsible_artcc        VARCHAR(3)  NOT NULL
  ,responsible_artcc_name   VARCHAR(12) NOT NULL
  ,fss_phone_number         VARCHAR(30)
  ,fss_phone_numer_tollfree VARCHAR(14) NOT NULL
  ,notam_facility_ident     VARCHAR(3)  NOT NULL
  ,status                   VARCHAR(1)  NOT NULL
  ,certification_typedate   VARCHAR(13) NOT NULL
  ,customs_airport_of_entry VARCHAR(1)
  ,military_joint_use       BOOLEAN
  ,military_landing         BOOLEAN
  ,lighting_schedule        VARCHAR(7)
  ,beacon_schedule          VARCHAR(5) NOT NULL
  ,control_tower            BOOLEAN NOT NULL
  ,unicom                   NUMERIC(7,3)
  ,ctaf                     NUMERIC(7,3)
  ,effective_date           DATE       NOT NULL

)

DISTSTYLE KEY
DISTKEY(faa_ident)
SORTKEY(facility_name);


