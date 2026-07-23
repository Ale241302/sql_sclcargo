-- Catálogo: Aircraft Type (PAX / CAO)
-- Usado en: crearhouse/editarhouse (val_aircraft_type), crearmaster/editarmaster (val_aircraft_type),
--           crearquotes/editarquotes (ul_aircraft_type, modal vessel - transporte aéreo)
-- data-value = codigo (se conserva el código original para no romper save/load ni el XML del manifiesto)

CREATE TABLE IF NOT EXISTS public.tbl_erp_aircraft_type (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_aircraft_type_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_aircraft_type (codigo, nombre) VALUES
    ('PAX', 'Passenger'),
    ('CAO', 'Cargo')
ON CONFLICT (codigo) DO NOTHING;
