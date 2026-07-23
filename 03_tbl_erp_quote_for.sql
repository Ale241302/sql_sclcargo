-- Catálogo: Quote For (Shipment / Service Job)
-- Usado en: crearquotes/editarquotes (val_quote_for)
-- data-value = codigo (shipment / service_job)

CREATE TABLE IF NOT EXISTS public.tbl_erp_quote_for (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_quote_for_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_quote_for (codigo, nombre) VALUES
    ('shipment',    'Shipment'),
    ('service_job', 'Service Job')
ON CONFLICT (codigo) DO NOTHING;
