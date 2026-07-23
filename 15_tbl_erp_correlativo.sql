-- ============================================================================
-- 15_tbl_erp_correlativo.sql
-- Correlativos configurables para Quote / House / Master / Service Job.
-- Una sola tabla: id_customer NULL = correlativo GENERAL (default).
-- Una fila con id_customer = <id org> sobreescribe al general para ese cliente.
-- next_value = el texto que tomara el PROXIMO registro de ese tipo.
--   El sufijo de digitos al final es el contador (ej. 'QT-001' -> 'QT-002').
-- Correr manualmente contra la base scl_cargo.
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.tbl_erp_correlativo (
    id              SERIAL PRIMARY KEY,
    fecha_creacion  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo            VARCHAR(20)  NOT NULL,   -- 'quote' | 'house' | 'master' | 'servicejob'
    id_customer     INTEGER,                 -- NULL = correlativo GENERAL / default
    next_value      VARCHAR(60)  NOT NULL,   -- p.ej. 'QT-001'
    estado          CHAR(1) DEFAULT '1'
);

-- Indice para resolver rapido (tipo, id_customer). Los generales tienen id_customer NULL.
CREATE INDEX IF NOT EXISTS idx_correlativo_tipo_customer
    ON public.tbl_erp_correlativo (tipo, id_customer);

-- Semilla de los 4 correlativos GENERALES (ajustables desde la pagina Correlativos).
-- Solo se insertan si aun no existen, para que re-correr el script no duplique.
INSERT INTO public.tbl_erp_correlativo (tipo, id_customer, next_value)
SELECT v.tipo, NULL::INTEGER, v.next_value
FROM (VALUES
    ('quote',      'QT-00001'),
    ('house',      'HBL-00001'),
    ('master',     'MBL-00001'),
    ('servicejob', 'SJ-00001')
) AS v(tipo, next_value)
WHERE NOT EXISTS (
    SELECT 1 FROM public.tbl_erp_correlativo c
    WHERE c.tipo = v.tipo AND c.id_customer IS NULL
);
