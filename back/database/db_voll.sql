
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

 $function$
;

-- Permissions

ALTER FUNCTION public.gen_random_uuid() OWNER TO postgres;
GRANT ALL ON FUNCTION public.gen_random_uuid() TO postgres;




-- CREATE SCHEMA AND GRANT PREVILEGES TO USE DB

CREATE ROLE rol_Voll;
GRANT CONNECT ON DATABASE db_voll_hnsp TO rol_Voll;
GRANT INSERT, SELECT ON ALL TABLES IN SCHEMA public TO rol_Voll;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT, SELECT ON TABLE TO rol_Voll; -- no lo es obligatorio
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

CREATE TABLE voll (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_nascimiento DATE NOT NULL,
    fecha_emision_pas DATE NOT NULL,
    fecha_caducidad_pas	DATE NOT NULL,
    nacionalidad TEXT NOT NULL, 
    nombre	TEXT NOT NULL, 
    lugar_nascimiento TEXT NOT NULL, 
    residencia_actual TEXT NOT NULL, 
    num_pasaporte TEXT NOT NULL, 
    lugar_emision_pas TEXT NOT NULL, 
    profesion TEXT NOT NULL, 
    tido_voluntariado TEXT NOT NULL, 
    telefono TEXT NOT NULL, 
    email TEXT NOT NULL, 
    inst_referencia	 TEXT NOT NULL
);

CREATE TABLE voll_all (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_nascimiento DATE NOT NULL,
    fecha_emision_pas DATE NOT NULL,
    fecha_caducidad_pas	DATE NOT NULL,
    fecha_ini_estancia DATE NOT NULL,
    fecha_fin_estancia DATE NOT NULL,
    num_edif CHAR(6) NOT NULL,
    puerta CHAR(4) NOT NULL,
    nacionalidad TEXT NOT NULL, 
    nombre	TEXT NOT NULL, 
    lugar_nascimiento TEXT NOT NULL, 
    residencia_actual TEXT NOT NULL, 
    num_pasaporte TEXT NOT NULL, 
    lugar_emision_pas TEXT NOT NULL, 
    profesion TEXT NOT NULL, 
    tido_voluntariado TEXT NOT NULL, 
    telefono TEXT NOT NULL, 
    email TEXT NOT NULL, 
    inst_referencia	 TEXT NOT NULL, 
    -- RESEIDENCIA 
    calle TEXT NOT NULL, 
    municipio TEXT NOT NULL,
    provincia TEXT NOT NULL,
    -- ESPECIALIDAD 
    especialidad TEXT NOT NULL, 
    -- PERIODO DE ESTANCIA 
    seccion_voll TEXT NOT NULL,
    nombre_responsable TEXT NOT NULL
);

-- crear Indices de busquedas

CREATE TABLE residencia(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    calle TEXT NOT NULL, 
    municipio TEXT NOT NULL,
    provincia TEXT NOT NULL, 
    num_edif CHAR(6) NOT NULL,
    puerta CHAR(4) NOT NULL,

);

CREATE TABLE especialidad_voll (
    id PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    id_voll UUID
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT NOT NULL,
    FOREIGN KEY (id_voll) REFERENCES voll (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- crear indoces de busqueda y filtros 

CREATE TABLE periodo_estancia_voll(
    id PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    id_voll UUID
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_inicio_voll DATE NOT NULL,
    fecha_fin_voll	DATE NOT NULL,
    FOREIGN KEY (id_voll) REFERENCES voll (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE hnsp_secion_voll(
    id PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    id_voll UUID
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ini DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    nombre TEXT NOT NULL,
    responsable TEXT NOT NULL,

    FOREIGN KEY (id_voll) REFERENCES voll (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- CREATE ALL TABLE TECNICAL 
CREATE TABLE session_up(
    id UUID,
    voll_id UUID NOT NULL,
   token TEXT NOT NULL,
    PRIMARY KEY (id, user_id),
    FOREIGN KEY(voll_id) REFERENCES voll (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE password(
    id UUID PRIMARY KEY UNIQUE DEFAULT gen_random_uuid(),
    id_voll UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    url TEXT NOT NULL,
    FOREIGN KEY(id_voll) REFERENCES voll_all(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE admin_sys(
  id UUID NOT NULL,
  id_voll UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

);

CREATE TABLE role(
    id PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    name TEXT  UNIQUE NOT NULL

);

CREATE TABLE permission(
    id PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    name TEXT  UNIQUE NOT NULL;
);

CREATE TABLE permission_role(  -- Relacion N a N / muchos a muchos
    -- se ve los permisos que tiene un role y un role puede terner 
    -- mas a de un permiso. Y un permiso solo puede estar una vez 
    -- en cada role.
    id PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(), -- el id aasignado al usisario para controlar los persmisos de aceso.
    id_role UUID NOT NULL,  -- admin
    id_permission UUID NOT NULL, -- create, read, update, delete, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
 
    FOREIGN KEY (id_role) REFERENCES role (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES permission (id) ON DELETE CASCADE ON UPDATE CASCADE,

);

CREATE TABLE voll_permission(
    id_voll NOT NULL,
    id_permision_role UUID NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_voll) REFERENCES voll_all (id) ON DELETE CASCADE ON UPDATE CASCADE

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

