-- CREATE SCHEMA AND GRANT PREVILEGES TO USE DB

CREATE ROLE rol_Voll;
GRANT CONNECT ON DATABASE db_voll_hnsp TO rol_Voll;
GRANT INSERT, SELECT ON ALL TABLES IN SCHEMA public TO rol_Voll;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT, SELECT ON TABLES TO rol_Voll; -- no lo es obligatorio
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO rol_Voll;
-- ALTER DEFAULT PRIVILEGES IN public GRANT INSERT ON TABLE TO rol_Voll; -- no hace falta

--CREATE A SCHEMA
CREATE SCHEMA app_voll;

-- ASIGN PRIVILEGES USE ROLE TO SCHEMA 
GRANT USAGE ON SCHEMA app_voll TO rol_Voll;

-- GRANT PRIVILEGES ACTION CRUD IN SCHEMA TO ROLE 
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA app_voll TO rol_Voll;

-- GRANT PREVILEGES USE TO SCHEMA 
-- ALTER DEFAULT PREVILEGES IN SCHEMA app_voll GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO rol_Voll;


-- GRANT PREVILEGES ON USER USE A ROLE 
GRANT rol_Voll TO user_voll;


-- CREATE TABLES 

CREATE TABLE "app_voll".admin(
  id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
  fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  super_admin BOOLEAN DEFAULT NULL,
  nanombre TEXT NOT NULL,
  apellidos TEXT NOT NULL,
  correo TEXT UNIQUE NOT NULL,
  contrasenia TEXT NOT NULL
);

CREATE TABLE "app_voll".voluntario (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_nascimiento DATE NOT NULL, 
    fecha_emision_pas DATE NOT NULL,
    fecha_ini_estancia DATE NOT NULL,
    fecha_caducidad_pasa DATE NOT NULL,
    fecha_fin_estancia DATE NOT NULL,
    nacionalidad TEXT NOT NULL, 
    nombre	TEXT NOT NULL, 
    apellidos TEXT NOT NULL, 
    lugar_nascimiento TEXT NOT NULL, 
    residencia_actual TEXT NOT NULL, 
    num_pasaporte TEXT NOT NULL, 
    lugar_emision_pas TEXT NOT NULL, 
    profesion TEXT NOT NULL, 
    tipo_voluntariado TEXT NOT NULL, 
    telefono TEXT NOT NULL, 
    correo TEXT UNIQUE NOT NULL, 
    inst_referencia	 TEXT NOT NULL,
    last_seen TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "app_voll".admin_voll(
    id_admin UUID,
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id_admin, id_voll),
    FOREIGN KEY (id_admin) REFERENCES "app_voll".admin (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE "app_voll".data_login (
    id_voll UUID  NOT NULL, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    correo TEXT UNIQUE NOT NULL,
    contrasenia TEXT NOT NULL,

    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);

INSERT INTO "app_voll".data_login VALUES ('dffe09a5-e7d8-6fe7-fcf3-e2cf4fc50426',default, default, 'afarres19@gmail.com','73290f2fec53e6e025e492ab587d727455ecffa58d831f79dc32cf06d56be157')

CREATE TABLE "app_voll".residencia_voll (
    id_voll UUID  NOT NULL, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    provincia TEXT NOT NULL, 
    codigo_postal CHAR(5),
    municipio TEXT NOT NULL, 
    calle TEXT NOT NULL,
    numero CHAR (5), 
    puerta CHAR(2), 

    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);


CREATE TABLE "app_voll".doc_voll(
    id_voll UUID, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    doc_name TEXT NOT NULL, 
    doc BYTEA NOT NULL,
    extencion CHAR(4),
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "app_voll".pago_voll (
    id_voll UUID, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    valor_pagado DECIMAL(10,2) NOT NULL, 
    modo_pago TEXT NOT null,
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "app_voll".estado_voll (
    id_voll UUID, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    estado TEXT NOT null,
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "app_voll".especialidad_voll (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT NOT NULL,
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- crear indoces de busqueda y filtros 

CREATE TABLE "app_voll".periodo_estancia_voll(
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_inicio_voll DATE NOT NULL,
    fecha_fin_voll	DATE NOT NULL,
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "app_voll".secion_hnsp (
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT NOT NULL
);

CREATE TABLE "app_voll".hnsp_secion_voll(
    id_secion UUID,
    id_voll UUID,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ini DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    nombre TEXT NOT NULL,
    responsable TEXT NOT NULL,

    PRIMARY KEY (id_secion, id_voll),
    FOREIGN KEY (id_secion) REFERENCES "app_voll".secion_hnsp (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- CREATE ALL TABLE TECNICAL 
CREATE TABLE "app_voll".session_up(
    id UUID,
    voll_id UUID UNIQUE,
    correo TEXT UNIQUE NOT NULL, 
    token TEXT NOT NULL,
    PRIMARY KEY (id, voll_id),
    FOREIGN KEY(voll_id) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "app_voll".contrasenia(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_voll UUID UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    url TEXT NOT NULL,
    FOREIGN KEY(id_voll) REFERENCES "app_voll".voluntario(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE "app_voll".admin_sys(
  id UUID NOT NULL,
  id_voll UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE "app_voll".role(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT  UNIQUE NOT NULL
);

CREATE TABLE "app_voll".permission(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    nombre TEXT  UNIQUE NOT NULL
);

CREATE TABLE "app_voll".permission_role(  -- Relacion N a N / muchos a muchos
    -- se ve los permisos que tiene un role y un role puede terner 
    -- mas a de un permiso. Y un permiso solo puede estar una vez 
    -- en cada role.
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(), -- el id aasignado al usisario para controlar los persmisos de aceso.
    id_role UUID NOT NULL,  -- admin
    id_permission UUID NOT NULL, -- create, read, update, delete, 
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
 
    FOREIGN KEY (id_role) REFERENCES "app_voll".role (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES "app_voll".permission (id) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE "app_voll".voll_permission(
    id_voll UUID NOT NULL,
    id_permision_role UUID NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    fecha_ult_atualizacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    FOREIGN KEY (id_voll) REFERENCES "app_voll".voluntario (id) ON DELETE CASCADE ON UPDATE CASCADE

);

