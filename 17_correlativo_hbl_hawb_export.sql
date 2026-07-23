-- ============================================================================
-- 17_correlativo_hbl_hawb_export.sql
-- Dos correlativos GENERALES nuevos para el HBL/HAWB de EXPORTACIÓN del House:
--   'hbl_export'  -> usado cuando el Transport mode es SEA/ROAD  (campo "HBL"  de la sección 9)
--   'hawb_export' -> usado cuando el Transport mode es AIR        (campo "HAWB" de la sección 9)
-- Solo aplican cuando el Shipment type del House es Export.
-- El valor es TEXTO LIBRE y conserva su prefijo (ej. '(A)001'); el sufijo de
-- dígitos es el contador y actúa como PISO: siguiente = max(base, MAX_prefijo+1)
-- contra los house.hbl existentes con el mismo prefijo. Se configuran desde la
-- página Administration -> Sequences (sección 1).
--
-- Idempotente: solo inserta si la fila general aún no existe (no pisa la que ya
-- hayas creado). Se siembran VACÍOS (la función queda inactiva hasta que el
-- admin escriba un valor en Sequences). Correr manualmente contra scl_cargo.
-- ============================================================================

INSERT INTO public.tbl_erp_correlativo (tipo, id_customer, next_value)
SELECT v.tipo, NULL::INTEGER, v.next_value
FROM (VALUES
    ('hbl_export',  ''),
    ('hawb_export', '')
) AS v(tipo, next_value)
WHERE NOT EXISTS (
    SELECT 1 FROM public.tbl_erp_correlativo c
    WHERE c.tipo = v.tipo AND c.id_customer IS NULL
);
