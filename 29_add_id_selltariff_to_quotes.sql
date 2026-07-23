-- Agregar columna id_selltariff a la tabla de cotizaciones
ALTER TABLE public.tbl_erp_quotes 
    ADD COLUMN IF NOT EXISTS id_selltariff integer;
