-- Catálogo: Additional Service (Quotes - sección Additional)
-- Usado en: crearquotes/editarquotes (val_additional_srv)
-- data-value = codigo (handling / asesoria / paletizado)

CREATE TABLE IF NOT EXISTS public.tbl_erp_additional_service (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_additional_service_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_additional_service (codigo, nombre) VALUES
    ('handling',   'HANDLING OC'),
    ('asesoria',   'ASESORIA EN COMERCIO EXTERIOR'),
    ('paletizado', 'PALETIZADO')
ON CONFLICT (codigo) DO NOTHING;
