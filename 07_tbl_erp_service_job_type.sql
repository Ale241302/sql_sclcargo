-- Catálogo: Service Job Type
-- Usado en: crearservicejob/editarservicejob (val_service_job_type)
--           y crearquotes/editarquotes (lista .db-sl-service del modal vessel, transporte service-job)
-- data-value = codigo (almacenaje, counseling, ...)

CREATE TABLE IF NOT EXISTS public.tbl_erp_service_job_type (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_service_job_type_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_service_job_type (codigo, nombre) VALUES
    ('almacenaje',      'ALMACENAJE'),
    ('counseling',      'COUNSELING IN FOREIGN TRADE'),
    ('inspeccion',      'INSPECCION Y BODEGAJE'),
    ('paquete_express', 'PAQUETE EXPRESS DOMICILIO'),
    ('poliza_seguro',   'POLIZA DE SEGURO'),
    ('recepcion_carga', 'RECEPCION DE CARGA')
ON CONFLICT (codigo) DO NOTHING;
