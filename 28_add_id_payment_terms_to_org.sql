-- Agregar columna id_payment_terms a la tabla de organizaciones
ALTER TABLE public.tbl_erp_organizations_list 
    ADD COLUMN IF NOT EXISTS id_payment_terms integer;
