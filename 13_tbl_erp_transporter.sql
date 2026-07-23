-- Catálogo: Transporter (road-mode selects en quotes)
-- Usado en: crearquotes/editarquotes
-- Sin unique en nombre; insert idempotente vía WHERE NOT EXISTS

CREATE TABLE IF NOT EXISTS public.tbl_erp_transporter (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT now(),
    nombre         VARCHAR(160),
    estado         CHAR(1)      DEFAULT '1'
);

INSERT INTO public.tbl_erp_transporter (nombre)
SELECT 'ABC Transporter'
WHERE NOT EXISTS (
    SELECT 1 FROM public.tbl_erp_transporter WHERE nombre = 'ABC Transporter'
);
