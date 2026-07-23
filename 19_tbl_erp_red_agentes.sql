-- ============================================================================
-- 19_tbl_erp_red_agentes.sql
-- Catálogo "Red de Agentes" (Agent Network) + columna id_red en organizations_list.
-- Ejecutar manualmente en la base de datos PostgreSQL.
-- ============================================================================

-- 1) Tabla del catálogo
CREATE TABLE IF NOT EXISTS public.tbl_erp_red_agentes (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nombre_red     VARCHAR(255) NOT NULL,
    estado         VARCHAR(1)   NOT NULL DEFAULT '1'
);

-- 2) Datos iniciales
INSERT INTO public.tbl_erp_red_agentes (nombre_red) VALUES
    ('WCA'),
    ('JCTRANS'),
    ('DF ALLIANCE');

-- 3) Referencia desde la organización al catálogo (id de la red de agentes).
--    Se deja NULL (una organización puede no pertenecer a ninguna red).
ALTER TABLE public.tbl_erp_organizations_list
    ADD COLUMN IF NOT EXISTS id_red INTEGER NULL;

COMMENT ON COLUMN public.tbl_erp_organizations_list.id_red
    IS 'FK lógica a tbl_erp_red_agentes.id (Red de Agentes / Agent Network).';
