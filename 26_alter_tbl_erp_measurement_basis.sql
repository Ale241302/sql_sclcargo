-- Catálogo: Measurement Basis (submódulo 34) — modifica tbl_erp_measurement_basis
--
-- La tabla YA EXISTE con (id, des, activo) y es referenciada como FK
-- id_measurement_basis en todas las tablas de cargos (quotes/house/master/
-- servicejob/sell/buy charges). Es el catálogo que define CÓMO se mide/calcula
-- un cargo. Este script SOLO agrega columnas (no destruye datos existentes).
--
-- des            = nombre del basis (ej. "Container Count", "Volumetric Weight").
-- funcionamiento = código EXCLUYENTE de cómo calcula. Valores soportados:
--                    CONTAINER_COUNT      → Marítimo FCL: por tipo de contenedor y cantidad
--                    VOLUMETRIC_WEIGHT    → LCL/Aéreo: el mayor entre ton vs m³ (aéreo = LxHxW/6000)
--                    WEIGHT               → por peso
--                    VOLUME               → por volumen
--                    MINIMUM              → mínimo manual (la naviera/aerolínea fija el cobro mínimo)
--                    SHIPMENT             → por embarque (cantidad 1)
--                    PACKAGE_COUNT        → por cantidad de paquetes/bultos/unidades
--                    FREE_DAYS            → días libres (Portcast)
--                    FREE_DAYS_CONTAINER  → días libres + tipo de contenedor (Portcast)
-- is_air/is_maritimo/is_road = a qué modo(s) de transporte aplica (booleanos, NO excluyentes).
-- estado     = '1' activo / '0' eliminado (soft-delete), igual que el resto de catálogos.
-- activo     = (BOOLEAN, ya existía) se reutiliza como el toggle habilitar/deshabilitar de la lista.
--
-- Ejecutar en PostgreSQL (base scl_cargo). Idempotente.

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS funcionamiento  TEXT;

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS is_air          BOOLEAN DEFAULT false;

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS is_maritimo     BOOLEAN DEFAULT false;

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS is_road         BOOLEAN DEFAULT false;

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS fecha_creacion  TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW();

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS estado          TEXT DEFAULT '1';

-- 'activo' ya existe como BOOLEAN; aseguramos que los registros previos queden habilitados.
ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS activo          BOOLEAN DEFAULT true;

-- Backfill de filas previas (antes de añadir las columnas estaban en NULL).
UPDATE public.tbl_erp_measurement_basis SET estado = '1'     WHERE estado IS NULL;
UPDATE public.tbl_erp_measurement_basis SET activo = true     WHERE activo IS NULL;
UPDATE public.tbl_erp_measurement_basis SET is_air = false    WHERE is_air IS NULL;
UPDATE public.tbl_erp_measurement_basis SET is_maritimo = false WHERE is_maritimo IS NULL;
UPDATE public.tbl_erp_measurement_basis SET is_road = false   WHERE is_road IS NULL;

CREATE INDEX IF NOT EXISTS idx_measurement_basis_estado ON public.tbl_erp_measurement_basis (estado);
