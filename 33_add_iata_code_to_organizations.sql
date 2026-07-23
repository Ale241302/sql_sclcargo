-- IATA Code para organizaciones (mostrado en crear/editar organization, sección 1 debajo de Tax ID).
-- Se persiste en tbl_erp_organizations_list.iata_code (modelo TblErpOrganizationsList).
ALTER TABLE public.tbl_erp_organizations_list
    ADD COLUMN IF NOT EXISTS iata_code varchar(50);
