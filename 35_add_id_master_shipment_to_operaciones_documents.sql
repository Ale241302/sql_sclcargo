-- Documento del Master Shipment (Bill of Lading / Air Waybill generado desde listmaster.volt).
-- Al imprimir un master se sube el PDF a GCS y se registra en tbl_erp_operaciones_documents,
-- igual que House/Quote. La tabla no tenía FK a master; se agrega id_master_shipment
-- (mismo patrón que id_quote / id_house_shipment / id_service_job).
ALTER TABLE public.tbl_erp_operaciones_documents
    ADD COLUMN IF NOT EXISTS id_master_shipment varchar(50);
