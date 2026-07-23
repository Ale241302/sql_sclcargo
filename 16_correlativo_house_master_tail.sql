-- ============================================================================
-- 16_correlativo_house_master_tail.sql
-- House y Master ahora son correlativos COMPUESTOS: el prefijo
--   {TRANSPORT}-{SHIPMENT}-{CARGO}-H-N-{AÑO}-   (o -M- para master)
-- se arma automatico desde el envio, y el AÑO es automatico (año actual).
-- En la pagina Sequences solo se configura la COLA numerica (ancho de ceros
-- + numero inicial), por eso normalizamos su next_value a '00001'.
-- El contador real es POR COMBINACION (MAX del prefijo compuesto), no se
-- consume el next_value de la config.
-- Correr manualmente contra la base scl_cargo.
-- ============================================================================

-- Normaliza la semilla general de house/master a la cola numerica.
UPDATE public.tbl_erp_correlativo
   SET next_value = '00001'
 WHERE id_customer IS NULL
   AND tipo IN ('house', 'master');

-- Limpieza: House/Master ya NO tienen override por cliente (solo general).
-- Si en pruebas quedaron filas de cliente para house/master, se eliminan.
DELETE FROM public.tbl_erp_correlativo
 WHERE id_customer IS NOT NULL
   AND tipo IN ('house', 'master');
