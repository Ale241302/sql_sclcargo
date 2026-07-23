-- Shipper del Master Shipment (crear/editarmaster, sección 2 General details debajo de Responsible).
-- Se persiste en tbl_erp_master_shipment.id_shipper (modelo TblErpMasterShipment), igual que en House.
ALTER TABLE public.tbl_erp_master_shipment
    ADD COLUMN IF NOT EXISTS id_shipper varchar(50);
