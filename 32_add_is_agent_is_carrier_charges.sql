-- 32_add_is_agent_is_carrier_charges.sql
-- Agrega los flags "Due By" (Agent / Carrier) a los cargos de House Shipment
-- (cost + revenue). Son excluyentes: el front manda due_by = 'agent' | 'carrier'
-- y el backend setea is_agent / is_carrier en consecuencia.

ALTER TABLE public.tbl_erp_house_shipment_cost_charge
    ADD COLUMN IF NOT EXISTS is_agent   boolean DEFAULT false,
    ADD COLUMN IF NOT EXISTS is_carrier boolean DEFAULT false;

ALTER TABLE public.tbl_erp_house_shipment_revenue_charge
    ADD COLUMN IF NOT EXISTS is_agent   boolean DEFAULT false,
    ADD COLUMN IF NOT EXISTS is_carrier boolean DEFAULT false;
