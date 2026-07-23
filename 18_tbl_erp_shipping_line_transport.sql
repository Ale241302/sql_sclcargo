-- Catálogo: Carriers (submódulo 32) — gestiona tbl_erp_shipping_line
-- Un carrier puede tener MÚLTIPLES transportes (SEA/AIR/ROAD) → tabla relación,
-- igual que puertos↔tipo_transporte pero con su propia tabla puente.
--
-- transport_mode = id de public.tbl_erp_tipo_transporte (1=Marítimo/SEA, 2=Aéreo/AIR, 3=Terrestre/ROAD),
-- el mismo código que ya usa tbl_erp_shipping_line.transport_mode y el filtro shipping_lines_sea/air.
--
-- Ejecutar en PostgreSQL (base scl_cargo). Idempotente.

BEGIN;

-- 1) Soporte de catálogo en tbl_erp_shipping_line: estado (soft-delete) + habilitado (toggle)
ALTER TABLE public.tbl_erp_shipping_line
    ADD COLUMN IF NOT EXISTS estado     TEXT DEFAULT '1',
    ADD COLUMN IF NOT EXISTS habilitado TEXT DEFAULT '1';

UPDATE public.tbl_erp_shipping_line SET estado     = '1' WHERE estado     IS NULL;
UPDATE public.tbl_erp_shipping_line SET habilitado = '1' WHERE habilitado IS NULL;

-- id_organization (carrier agent) ya existe en la tabla; se asegura por si acaso.
ALTER TABLE public.tbl_erp_shipping_line
    ADD COLUMN IF NOT EXISTS id_organization TEXT;

-- 2) Tabla relación: una fila por (shipping line, transporte)
CREATE TABLE IF NOT EXISTS public.tbl_erp_shipping_line_transport (
    id               SERIAL PRIMARY KEY,
    fecha_creacion   TIMESTAMP DEFAULT now(),
    id_shipping_line BIGINT NOT NULL,
    transport_mode   TEXT   NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_sl_transport_line ON public.tbl_erp_shipping_line_transport (id_shipping_line);
CREATE INDEX IF NOT EXISTS idx_sl_transport_mode ON public.tbl_erp_shipping_line_transport (transport_mode);

-- 3) Backfill: migrar el transport_mode único actual a la tabla relación,
--    para que los carriers existentes sigan apareciendo en sea/air.
INSERT INTO public.tbl_erp_shipping_line_transport (id_shipping_line, transport_mode)
SELECT sl.id, sl.transport_mode
FROM public.tbl_erp_shipping_line sl
WHERE sl.transport_mode IS NOT NULL
  AND sl.transport_mode <> ''
  AND NOT EXISTS (
      SELECT 1 FROM public.tbl_erp_shipping_line_transport t
      WHERE t.id_shipping_line = sl.id
        AND t.transport_mode   = sl.transport_mode
  );

COMMIT;
