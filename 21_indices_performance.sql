-- ============================================================================
--  21_indices_performance.sql
--  Índices para acelerar la carga de los SELECT pesados (crear/editar).
--
--  Contexto: los endpoints de helpers (selltariff/buytariff, organizations y
--  operaciones) consultan catálogos grandes (ciudades ~21k, puertos ~35k,
--  organizations_list ~1.8k, organizations_groups ~3k). En el servidor de
--  producción (menos potente) los filtros y JOINs sin índice hacen secuencial
--  scans que disparan los tiempos de respuesta.
--
--  Estos índices NO cambian datos: sólo aceleran lectura. Son idempotentes
--  (IF NOT EXISTS, PostgreSQL >= 9.5). Ejecutar manualmente en la BD de prod.
-- ============================================================================

-- Ciudades: filtro por país (cascada origen/destino) y por estado.
CREATE INDEX IF NOT EXISTS idx_ciudad_id_pais
    ON public.tbl_pais_estado_ciudad_erp (id_pais);
CREATE INDEX IF NOT EXISTS idx_ciudad_id_estado
    ON public.tbl_pais_estado_ciudad_erp (id_estado);

-- Estados: filtro por país.
CREATE INDEX IF NOT EXISTS idx_estado_id_pais
    ON public.tbl_pais_estado_erp (id_pais);

-- Puertos: el helper filtra por estado = '1'; el front filtra por país y modo.
CREATE INDEX IF NOT EXISTS idx_puerto_estado
    ON public.tbl_puertos_erp (estado);
CREATE INDEX IF NOT EXISTS idx_puerto_pais
    ON public.tbl_puertos_erp (pais);

-- Organizations list: split por tipo (customer/vendor) y red de agentes.
CREATE INDEX IF NOT EXISTS idx_org_list_type_customer
    ON public.tbl_erp_organizations_list (type_customer);
CREATE INDEX IF NOT EXISTS idx_org_list_estado
    ON public.tbl_erp_organizations_list (estado);

-- Organizations groups: JOIN/IN por grupo y por organización (fan-out de parties).
CREATE INDEX IF NOT EXISTS idx_org_groups_id_groups
    ON public.tbl_erp_organizations_groups (id_groups);
CREATE INDEX IF NOT EXISTS idx_org_groups_id_organizations
    ON public.tbl_erp_organizations_groups (id_organizations);

-- Recalcular estadísticas del planificador tras crear los índices.
ANALYZE public.tbl_pais_estado_ciudad_erp;
ANALYZE public.tbl_pais_estado_erp;
ANALYZE public.tbl_puertos_erp;
ANALYZE public.tbl_erp_organizations_list;
ANALYZE public.tbl_erp_organizations_groups;
