
-- user Postgres default 
-- user postgres
--BD: postgres 
-- password: postgres 


-- CREATE USER 
CREATE USER user_voll WITH PASSWORD 'voll290722'

-- CREATE DATABASE 

DROP DATABASE IF EXISTS db_voll_hnsp;
CREATE DATABASE db_voll_hnsp;


--- TEST 

CREATE TABLE "public".pureba(
     id UUID PRIMARY KEY UNIQUE DEFAULT gen_random_uuid(),
     nombre TEXT NOT NULL,
     edad NUMERIC NOT NULL
);

CREATE TABLE "sch_voll".prueba(
     id UUID PRIMARY KEY UNIQUE DEFAULT gen_random_uuid(),
     nombre TEXT NOT NULL,
     edad NUMERIC NOT NULL
);



INSERT INTO "public".pureba ( nombre, edad) VALUES (
'José',22
);

INSERT INTO "public".pureba ( nombre, edad) VALUES (
'Marquz', 33
);
INSERT INTO "public".pureba ( nombre, edad) VALUES (
'Artur', 31
);
INSERT INTO "public".pureba ( nombre, edad) VALUES (
'Mendez', 32
);





INSERT INTO "sch_voll".prueba ( nombre, edad) VALUES (
    ('José',22); ('Marquz', 33); ('Artur', 'Melendez', 31)
);

INSERT INTO "public".prueba ( nombre, edad) VALUES (
    ('José',22); ('Marquz', 33); ('Artur', 'Melendez', 31)
);


-- CREATE A FUNCTIONS UUID 

CREATE OR REPLACE FUNCTION public.gen_random_uuid()
 RETURNS uuid
 LANGUAGE plpgsql
    AS $function$
    begin

    return (lpad(to_hex((extract(epoch from now()) / 60)::int % 65536), 4, '0') || substr(md5(random()::text ||random()::text), 5))::uuid;

end;
$function$;

-- Permissions

ALTER FUNCTION public.gen_random_uuid() OWNER TO postgres;
GRANT ALL ON FUNCTION public.gen_random_uuid() TO postgres;




-- CREATE SCHEMA AND GRANT PREVILEGES TO USE DB

CREATE ROLE rol_Voll;
GRANT CONNECT ON DATABASE db_voll_hnsp TO rol_Voll;
GRANT INSERT, SELECT ON ALL TABLES IN SCHEMA public TO rol_Voll;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT, SELECT ON TABLES TO rol_Voll; -- no lo es obligatorio
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO rol_Voll;
-- ALTER DEFAULT PRIVILEGES IN public GRANT INSERT ON TABLE TO rol_Voll; -- no hace falta

--CREATE A SCHEMA
CREATE SCHEMA sch_voll;

-- ASIGN PRIVILEGES USE ROLE TO SCHEMA 
GRANT USAGE ON SCHEMA sch_voll TO rol_Voll;

-- GRANT PRIVILEGES ACTION CRUD IN SCHEMA TO ROLE 
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sch_voll TO rol_Voll;

-- GRANT PREVILEGES USE TO SCHEMA 
-- ALTER DEFAULT PREVILEGES IN SCHEMA sch_voll GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO rol_Voll;


-- GRANT PREVILEGES ON USER USE A ROLE 
GRANT rol_Voll TO user_voll;


-- CREATE TABLES 

CREATE TABLE "sch_voll".admin(
  id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
  fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  super_admin BOOLEAN DEFAULT NULL,
  nanombre TEXT NOT NULL,
  apellidos TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL
);

CREATE TABLE "sch_voll".admin_voll(
    id_admin UUID,
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id_admin, id_voll),
    FOREIGN KEY (id_admin) REFERENCES "sch_voll".admin (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE "sch_voll".voluntario (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_nascimiento DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'), 
    fecha_emision_pas DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM01/01/1975','DD/MM/YYYY'),
    fecha_ini_estancia DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM01/01/1975','DD/MM/YYYY'),
    fecha_caducidad_pasa DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM01/01/1975','DD/MM/YYYY'),
    fecha_fin_estancia DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'),
    nacionalidad TEXT NOT NULL, 
    nombre	TEXT NOT NULL, 
    apellidos TEXT NOT NULL, 
    lugar_nascimiento TEXT NOT NULL, 
    residencia_actual TEXT NOT NULL, 
    num_pasaporte TEXT NOT NULL, 
    lugar_emision_pas TEXT NOT NULL, 
    profesion TEXT NOT NULL, 
    tido_voluntariado TEXT NOT NULL, 
    telefono TEXT NOT NULL, 
    email TEXT UNIQUE NOT NULL, 
    inst_referencia	 TEXT NOT NULL,
    lastSeen TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "sch_voll".data_login (
    id_voll UUID  NOT NULL, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,

    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);

INSERT INTO "sch_voll".data_login VALUES ('dffe09a5-e7d8-6fe7-fcf3-e2cf4fc50426',default, default, 'afarres19@gmail.com','73290f2fec53e6e025e492ab587d727455ecffa58d831f79dc32cf06d56be157')

CREATE TABLE "sch_voll".residencia_voll (
    id_voll UUID  NOT NULL, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    provincia TEXT NOT NULL, 
    codigo_postal CHAR(5),
    municipio TEXT NOT NULL, 
    calle TEXT NOT NULL,
    numero CHAR (5), 
    puerta CHAR(2), 

    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);


CREATE TABLE voll_all (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_nascimiento DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'), 
    fecha_emision_pas DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'),
    fecha_caducidad_pas	DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'),
    fecha_ini_estancia DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'),
    fecha_fin_estancia DATE NOT NULL DEFAULT TO_TIMESTAMP('01/01/1975','DD/MM/YYYY'),
    num_edif CHAR(6) NOT NULL,
    puerta CHAR(4) NOT NULL,
    nacionalidad TEXT NOT NULL, 
    nombre	TEXT NOT NULL, 
    apellidos TEXT NOT NULL, 
    lugar_nascimiento TEXT NOT NULL, 
    residencia_actual TEXT NOT NULL, 
    num_pasaporte TEXT NOT NULL, 
    lugar_emision_pas TEXT NOT NULL, 
    profesion TEXT NOT NULL, 
    tido_voluntariado TEXT NOT NULL, 
    telefono TEXT NOT NULL, 
    email TEXT NOT NULL, 
    inst_referencia	 TEXT NOT NULL 
    /*
    -- RESEIDENCIA 
    calle TEXT NOT NULL, 
    municipio TEXT NOT NULL,
    provincia TEXT NOT NULL,
    -- ESPECIALIDAD 
    especialidad TEXT NOT NULL, 
    -- PERIODO DE ESTANCIA 
    seccion_voll TEXT NOT NULL,
    nombre_responsable TEXT NOT NULL,

    -- pago estancia 
    pago_semanal DECIMAL(10,2) NOT NULL,
    pago_diario DECIMAL(10,2) NOT NULL,
    valor_pagado DECIMAL(10,2) NOT NULL, 
    enero TEXT NOT NULL DEFAULT 'my_genero' 
    */

);

CREATE TABLE "sch_voll".doc_voll(
    id_voll UUID, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    doc_name TEXT NOT NULL, 
    doc BYTEA NOT NULL,
    extencion CHAR(4),
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "sch_voll".pago_voll (
    id_voll UUID, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    valor_pagado DECIMAL(10,2) NOT NULL, 
    modo_pago TEXT NOT null,
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "sch_voll".estado_voll (
    id_voll UUID, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    estado TEXT NOT null,
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "sch_voll".especialidad_voll (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT NOT NULL,
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- crear indoces de busqueda y filtros 

CREATE TABLE "sch_voll".periodo_estancia_voll(
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_inicio_voll DATE NOT NULL,
    fecha_fin_voll	DATE NOT NULL,
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "sch_voll".secion_hnsp (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT NOT NULL
);

CREATE TABLE "sch_voll".hnsp_secion_voll(
    id_secion UUID,
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ini DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    nombre TEXT NOT NULL,
    responsable TEXT NOT NULL,

    PRIMARY KEY (id_secion, id_voll),
    FOREIGN KEY (id_secion) REFERENCES "sch_voll".secion_hnsp (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- CREATE ALL TABLE TECNICAL 
CREATE TABLE "sch_voll".session_up(
    id UUID,
    voll_id UUID UNIQUE PRIMARY KEY NOT NULL,
    email TEXT UNIQUE NOT NULL, 
    token TEXT NOT NULL,
    PRIMARY KEY (id, voll_id),
    FOREIGN KEY(voll_id) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "sch_voll".password(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_voll UUID UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    url TEXT NOT NULL,
    FOREIGN KEY(id_voll) REFERENCES "sch_voll".voluntario(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE "sch_voll".admin_sys(
  id UUID NOT NULL,
  id_voll UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE "sch_voll".role(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT  UNIQUE NOT NULL
);

CREATE TABLE "sch_voll".permission(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT  UNIQUE NOT NULL
);

CREATE TABLE "sch_voll".permission_role(  -- Relacion N a N / muchos a muchos
    -- se ve los permisos que tiene un role y un role puede terner 
    -- mas a de un permiso. Y un permiso solo puede estar una vez 
    -- en cada role.
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(), -- el id aasignado al usisario para controlar los persmisos de aceso.
    id_role UUID NOT NULL,  -- admin
    id_permission UUID NOT NULL, -- create, read, update, delete, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
 
    FOREIGN KEY (id_role) REFERENCES "sch_voll".role (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES "sch_voll".permission (id) ON DELETE CASCADE ON UPDATE CASCADE,

);

CREATE TABLE "sch_voll".voll_permission(
    id_voll UUID NOT NULL,
    id_permision_role UUID NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_voll) REFERENCES "sch_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);


-- CREATE ALL INDEX 
--create index idx_device_ack_received_at on device_ack(received_at);

-- CREATE PROCEDURE 
-- CREATE TRIGGER 


/*


CREATE TABLE "app_chirpstack_user".role(
  id UUID PRIMARY KEY UNIQUE DEFAULT gen_random_uuid(),
  type_role TEXT NOT NULL,
  description TEXT,
  create_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  update_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);

CREATE TABLE "app_chirpstack_user".permission(
  id UUID PRIMARY KEY UNIQUE DEFAULT gen_random_uuid(),
  type_permission TEXT NOT NULL,
  description TEXT,
  create_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  update_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);

CREATE TABLE "app_chirpstack_user".role_permission(
role_id UUID NOT NULL,
permission_id UUID NOT NULL,
create_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
update_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
PRIMARY KEY (role_id, permission_id),

FOREIGN KEY (role_id) REFERENCES "app_chirpstack_user".role (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY (permission_id) REFERENCES "app_chirpstack_user".permission(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


*/


-- BOrrado de tablas 

drop table sch_voll.especialidad_voll, 
sch_voll.estado_voll, sch_voll.pago_voll,
sch_voll.periodo_estancia_voll, sch_voll.secion_hnsp, 
sch_voll.voll 