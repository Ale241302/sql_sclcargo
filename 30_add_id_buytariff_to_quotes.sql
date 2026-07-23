-- Agregar columna id_buytariff a la tabla de cotizaciones
ALTER TABLE public.tbl_erp_quotes 
    ADD COLUMN IF NOT EXISTS id_buytariff integer;