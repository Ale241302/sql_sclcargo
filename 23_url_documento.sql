-- ============================================================================
--  23_url_documento.sql
--
--  Guarda la URL pública (GCP) del ÚLTIMO documento generado:
--    - tbl_erp_quotes          -> documento de cotización (PDF)
--    - tbl_erp_house_shipment  -> documento House (BL marítimo / AWB aéreo, según transporte)
--
--  Política: overwrite — una sola URL por registro (la última generación).
--  Idempotente: ADD COLUMN IF NOT EXISTS. Ejecutar manualmente. PostgreSQL.
-- ============================================================================

ALTER TABLE public.tbl_erp_quotes
    ADD COLUMN IF NOT EXISTS url_documento text;

ALTER TABLE public.tbl_erp_house_shipment
    ADD COLUMN IF NOT EXISTS url_documento text;
