-- Nombre: SQL DW Structure Definition
-- Autor: Julian Fernandez
-- Fecha: 6 Abril - 2023
-- Objetivo: Creación de 2 tablas en el datawarehouse de Redshift.
--           La tabla 'proyecto_weather': contiene toda la información relacionada al clima en el momento de la consulta.
--           La tabla 'proyecto_airports': contiene el estado e información geografica de los aeropuertos consultados.

-- El objetivo es crear un DW con información de los aeropuertos localizados en la Florida estados unidos.
-- Se puede expandir el rango y escalar a todos los aeropuertos de los estados unidos.

CREATE TABLE proyecto_weather(

	station_id  VARCHAR(6),
	temp        DECIMAL(3,1),
	dewpoint    DECIMAL(3,1),
	wind        INT,
	wind_vel    INT,
	visibility  DECIMAL(2,1),
	alt_hg      DECIMAL(2,2),
	alt_mb      DECIMAL(4,1),
	wx          VARCHAR(20),
	auto_report VARCHAR(1),
	category    VARCHAR(3),
	report_type VARCHAR(10),
	time_of_obs TIMESTAMP,
	sky_conditions_coverage VARCHAR(3),
	sky_conditions_base_agl INT

);

CREATE TABLE proyecto_airports(

	  site_number              VARCHAR(10),
	  type                     VARCHAR(10), 
	  facility_name            VARCHAR(128), 
	  faa_ident                VARCHAR(3), 
	  icao_ident               VARCHAR(4), 
    region                   VARCHAR(3), 
    district_office          VARCHAR(3), 
    state                    VARCHAR(3), 
    state_full               VARCHAR(20), 
    county                   VARCHAR(64), 
    city                     VARCHAR(128), 
    ownership                VARCHAR(2), 
    use                      VARCHAR(2), 
    manager                  VARCHAR(64),
    manager_phone            VARCHAR(12),
    latitude                 VARCHAR(20),
    latitude_sec             VARCHAR(20),
    longitude                VARCHAR(20),
    longitude_sec            VARCHAR(20),
    elevation                DECIMAL(31),
    magnetic_variation       VARCHAR(3),
    tpa                      VARCHAR(10),
    vfr_sectional            VARCHAR(128),
    boundary_artcc           VARCHAR(3),
    boundary_artcc_name      VARCHAR(128),
    responsible_artcc        VARCHAR(3),
    responsible_artcc_name   VARCHAR(128),
    fss_phone_number         VARCHAR(12),
    fss_phone_numer_tollfree VARCHAR(20),
    notam_facility_ident     VARCHAR(3),
    status                   VARCHAR(1),
    certification_typedate   VARCHAR(10),
    customs_airport_of_entry VARCHAR(1),
    military_joint_use       VARCHAR(1),
    military_landing         VARCHAR(1),
    lighting_schedule        VARCHAR(5),
    beacon_schedule          VARCHAR(5),
    control_tower            VARCHAR(1),
    unicom                   DECIMAL(32),
    ctaf                     DECIMAL(32),
    effective_date           DATE
)
