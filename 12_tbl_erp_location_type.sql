-- Catálogo: Location Type (road-mode selects en quotes)
-- Usado en: crearquotes/editarquotes
-- codigo = nombre (case preservada para que valores guardados sigan haciendo match)

CREATE TABLE IF NOT EXISTS public.tbl_erp_location_type (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT now(),
    codigo         VARCHAR(40)  UNIQUE,
    nombre         VARCHAR(120),
    estado         CHAR(1)      DEFAULT '1'
);

INSERT INTO public.tbl_erp_location_type (codigo, nombre) VALUES
    ('CFS',       'CFS'),
    ('Port',      'Port'),
    ('Depot',     'Depot'),
    ('Warehouse', 'Warehouse'),
    ('Factory',   'Factory'),
    ('Terminal',  'Terminal')
ON CONFLICT (codigo) DO NOTHING;
