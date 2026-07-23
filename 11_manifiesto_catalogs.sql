-- Catálogos del manifiesto (BL) antes quemados en editarmanifiesto.volt → ahora desde BD.
-- Cada tabla: id serial, fecha_creacion, codigo (= data-value del <li>), nombre (= texto visible), estado.
-- Render: <li data-value="{{ o.codigo }}">{{ o.nombre }}</li>. codigo se conserva idéntico (alimenta XML/registro).
-- Idempotente: CREATE IF NOT EXISTS + ON CONFLICT (codigo) DO NOTHING.

-- 1) Operation way
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_sentido_operacion (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_sentido_operacion UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_sentido_operacion (codigo, nombre) VALUES
    ('I','Import'),('E','Export'),('TR','Transit'),('TRB','Transshipment')
ON CONFLICT (codigo) DO NOTHING;

-- 2) Transport condition
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_condicion_carga (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_condicion_carga UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_condicion_carga (codigo, nombre) VALUES
    ('HH','Door to door delivery'),('HP','Door to port delivery'),
    ('PP','Port to port delivery'),('PH','Port to door delivery')
ON CONFLICT (codigo) DO NOTHING;

-- 3) Service type (también usado por el status de contenedor)
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_tipo_servicio (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(30) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_tipo_servicio UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_tipo_servicio (codigo, nombre) VALUES
    ('EMPTY','EMPTY'),('FCL/FCL','FCL/FCL'),('LCL/LCL','LCL/LCL'),('BB','BB'),
    ('FCL/LCL','FCL/LCL'),('FCL/BB','FCL/BB'),('LCL/BB','LCL/BB'),('FCL/LCL/BB','FCL/LCL/BB'),
    ('CY/CY','CY/CY'),('CFS/CFS','CFS/CFS'),('CFS/CY','CFS/CY'),('CY/CFS','CY/CFS'),
    ('CY/DOOR','CY/DOOR'),('DOOR/CY','DOOR/CY'),('LCL/FCL','LCL/FCL'),('DOOR/DOOR','DOOR/DOOR'),
    ('RoRo','RoRo'),('LICTVACIOS','LICTVACIOS')
ON CONFLICT (codigo) DO NOTHING;

-- 4) Service
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_servicio (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_servicio UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_servicio (codigo, nombre) VALUES
    ('LINER','Liner service'),('TRAMP','Servicio Irregular')
ON CONFLICT (codigo) DO NOTHING;

-- 5) Freight payment method
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_pago_flete (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_pago_flete UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_pago_flete (codigo, nombre) VALUES
    ('PREPAID','Prepagado'),('COLLECT','Por cobrar')
ON CONFLICT (codigo) DO NOTHING;

-- 6) ID type (RUT/PAS/ADU) — embarcador, consignatario, notify, notify2, emisor ref
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_tipo_id (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_tipo_id UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_tipo_id (codigo, nombre) VALUES
    ('RUT','RUT'),('PAS','PAS'),('ADU','ADU')
ON CONFLICT (codigo) DO NOTHING;

-- 7) Unidad de medida (peso)
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_unidad_peso (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_unidad_peso UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_unidad_peso (codigo, nombre) VALUES
    ('KGM','KGM'),('D41','D41'),('FOT','FOT'),('GLD','GLD'),('GLI','GLI'),('GLL','GLL'),
    ('GRM','GRM'),('HGM','HGM'),('HLT','HLT'),('HMT','HMT'),('INH','INH'),('KTM','KTM'),
    ('KTN','KTN'),('LBR','LBR'),('ONZ','ONZ'),('STN','STN'),('TNE','TNE'),('UNI','UNI')
ON CONFLICT (codigo) DO NOTHING;

-- 8) Unidad de medida (volumen)
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_unidad_volumen (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_unidad_volumen UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_unidad_volumen (codigo, nombre) VALUES
    ('CMQ','CMQ'),('FTQ','FTQ'),('INQ','INQ'),('LTR','LTR'),('MTQ','MTQ')
ON CONFLICT (codigo) DO NOTHING;

-- 9) Remark type
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_tipo_observacion (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(200) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_tipo_observacion UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_tipo_observacion (codigo, nombre) VALUES
    ('GRAL','General Remarks.'),('MOT','Reason for Modification.'),
    ('01','Out of deadline due to force majeure.'),('02','Change of berth/warehouse site.'),
    ('03','Carga parcial B/L distinto puerto'),('04','B/L clarification with Customs approval'),
    ('05','Cubrefaltas.'),('06','Change of port'),('07','CONTENEDORES PUERTOS NACIONALES'),
    ('08','Site 7 Arica - ENAPU (Peru)'),('10','TRANSITO A BOLIVIA'),('11','TRANSITO A PERU'),
    ('12','TRANSITO A OTRO PAIS')
ON CONFLICT (codigo) DO NOTHING;

-- 10) Seal code (autoridad del sello)
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_sello_codigo (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_sello_codigo UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_sello_codigo (codigo, nombre) VALUES
    ('AD','ADUANA'),('AG','DESPACHADOR'),('CA','COMPAQIA'),('CU','OTROS CLIENTES'),
    ('OTR','OTRA ENTIDAD'),('SAG','SERVICIO AGRICOLA Y GANADERO'),
    ('SERNAP','SERVICIO NACIONAL DE PESCA'),('SH','CLIENTE-EMBARCADOR'),
    ('SUR','SURVEYOR (CERTIFICADOR)'),('TO','TERMINAL OPERADOR')
ON CONFLICT (codigo) DO NOTHING;

-- 11) Reference type
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_tipo_referencia (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_tipo_referencia UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_tipo_referencia (codigo, nombre) VALUES
    ('REF','REF'),('REFMANANT','REFMANANT'),('MADRE','MADRE'),('REFBLANT','REFBLANT'),('REFDUS','REFDUS')
ON CONFLICT (codigo) DO NOTHING;

-- 12) Document type
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_tipo_documento (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(150) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_tipo_documento UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_tipo_documento (codigo, nombre) VALUES
    ('MFTO','MFTO'),('BL','BL'),('DUS','DUS')
ON CONFLICT (codigo) DO NOTHING;

-- 13) Location type
CREATE TABLE IF NOT EXISTS public.tbl_erp_man_tipo_locacion (
    id SERIAL PRIMARY KEY, fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    codigo VARCHAR(20) NOT NULL, nombre VARCHAR(200) NOT NULL, estado CHAR(1) DEFAULT '1',
    CONSTRAINT uq_man_tipo_locacion UNIQUE (codigo));
INSERT INTO public.tbl_erp_man_tipo_locacion (codigo, nombre) VALUES
    ('LE','BL Issue Place'),('PE','Port of Loading of the goods'),
    ('PD','Port of Discharge of the goods'),('LD','Final Destination place of the goods'),
    ('LEM','Place of Delivery of the goods'),('LRM','Place of Receipt of the goods by the Carrier'),
    ('TRB','Transshipment Port of the goods (last)')
ON CONFLICT (codigo) DO NOTHING;
