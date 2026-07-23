-- Catálogo: Truck Type (Quotes - modal vessel, transporte terrestre)
-- Usado en: crearquotes/editarquotes (ul_truck_type)
-- data-value = codigo (4t_flatbed, 6t_flatbed, ...)

CREATE TABLE IF NOT EXISTS public.tbl_erp_truck_type (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_truck_type_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_truck_type (codigo, nombre) VALUES
    ('4t_flatbed',   '4T Flatbed'),
    ('6t_flatbed',   '6T Flatbed'),
    ('10t_flatbed',  '10T Flatbed'),
    ('12t_flatbed',  '12T Flatbed'),
    ('20t_flatbed',  '20T Flatbed'),
    ('40ft_trailer', '40FT Trailer'),
    ('45ft_trailer', '45FT Trailer'),
    ('lowbed',       'Lowbed Trailer'),
    ('reefer',       'Reefer Truck'),
    ('pickup',       'Pick-up'),
    ('closed_box',   'Closed Box'),
    ('curtain_side', 'Curtain Side'),
    ('heavy_duty',   'Heavy Duty Truck'),
    ('tanker',       'Tanker Truck')
ON CONFLICT (codigo) DO NOTHING;
