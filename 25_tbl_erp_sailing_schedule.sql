-- Catálogo: Sailing Schedules (submódulo 33) — gestiona tbl_erp_sailing_schedule
-- Alimenta los selects "Sailing schedule" (SEA) y "Air schedule" (AIR) de
-- crear/editar House y Master. El label mostrado es:
--   "<puerto_origen.codigo> - <puerto_destino.codigo> (<voyage_number>)"
--
-- id_carrier            = id de public.tbl_erp_shipping_line (Carriers)
-- id_port_origin/destino = id de public.tbl_puertos_erp
-- id_buque             = id de public.tbl_erp_buque
--
-- estado     = '1' activo / '0' eliminado (soft-delete), igual que el resto de catálogos.
-- habilitado = '1' habilitado / '0' deshabilitado (toggle de la lista).
--
-- Ejecutar en PostgreSQL (base scl_cargo). Idempotente.

CREATE TABLE IF NOT EXISTS public.tbl_erp_sailing_schedule (
    id                  SERIAL PRIMARY KEY,
    fecha_creacion      TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    id_carrier          INTEGER,
    voyage_number       TEXT,
    scac_number         TEXT,
    service_name        TEXT,
    id_port_origin      INTEGER,
    id_port_destination INTEGER,
    tt                  INTEGER,
    si_cut_off          DATE,
    etd                 DATE,
    atd                 DATE,
    eta                 DATE,
    ata                 DATE,
    id_buque            INTEGER,
    buque_cut_off       DATE,
    vgm_cut_off         DATE,
    estado              TEXT DEFAULT '1',
    habilitado          TEXT DEFAULT '1'
);

-- Índices para los filtros/joins más usados (lista paginada + helper de operaciones)
CREATE INDEX IF NOT EXISTS idx_sailing_schedule_estado      ON public.tbl_erp_sailing_schedule (estado);
CREATE INDEX IF NOT EXISTS idx_sailing_schedule_carrier     ON public.tbl_erp_sailing_schedule (id_carrier);
CREATE INDEX IF NOT EXISTS idx_sailing_schedule_port_origin ON public.tbl_erp_sailing_schedule (id_port_origin);
CREATE INDEX IF NOT EXISTS idx_sailing_schedule_port_dest   ON public.tbl_erp_sailing_schedule (id_port_destination);
