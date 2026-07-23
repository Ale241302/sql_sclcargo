-- Catálogo: Shipment Count (Single / Multiple)
-- Usado en: crearquotes/editarquotes (val_shipment_count)
-- data-value = codigo (single / multiple)

CREATE TABLE IF NOT EXISTS public.tbl_erp_shipment_count (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_shipment_count_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_shipment_count (codigo, nombre) VALUES
    ('single',   'Single'),
    ('multiple', 'Multiple')
ON CONFLICT (codigo) DO NOTHING;
