-- ============================================================================
--  22_migrar_geo_a_locaciones.sql
--
--  Completa las LOCACIONES: agrega REGIONES y CIUDADES (que faltaban) copiándolas
--  desde las tablas geo LEGACY, y arregla el nombre del país (se veía "CL - 38"
--  porque la columna `pais` guardaba el id legacy en vez del nombre).
--
--  REQUISITO: primero debe estar corrido "Data SearatesERP_sql_locacion_insert.sql"
--  (200 locaciones, donde locacion.pais = id del país legacy y codigo_pais = ISO).
--
--  Enlaces (match) — el match locación↔país va por el ISO (codigo_pais), que NUNCA cambia,
--  para que el script sea RE-EJECUTABLE incluso después de renombrar locacion.pais (paso 3):
--    tbl_pais_estado_erp        -> tbl_region_locacion_erp
--        region.id          = estado.id           (preservado)
--        region.id_locacion = locacion.id  (match: locacion.codigo_pais = pais_legacy.codigo_pais)
--    tbl_pais_estado_ciudad_erp -> tbl_ciudad_locacion_erp
--        ciudad.id          = ciudad_legacy.id     (preservado)
--        ciudad.id_locacion = locacion.id  (match: locacion.codigo_pais = pais_legacy.codigo_pais)
--        ciudad.id_region   = ciudad_legacy.id_estado (== region.id, preservado)
--
--  Idempotente: usa ON CONFLICT (id) DO NOTHING (no duplica) y el UPDATE del nombre
--  sólo toca filas cuyo `pais` siga siendo numérico. NO borra nada.
--
--  Ejecutar manualmente en la BD de producción. PostgreSQL.
-- ============================================================================

BEGIN;

-- ── 1. REGIONES (estados) desde LEGACY, enlazadas a la locación por país ──
--     IMPORTANTE: el match va por el ISO del país (codigo_pais), NO por locacion.pais.
--     locacion.pais arranca con el id legacy pero el paso 3 lo renombra al nombre del país;
--     codigo_pais (ISO) NUNCA cambia, así que este JOIN funciona tanto en BD fresca como
--     en una BD donde el país ya fue renombrado (re-ejecutable sin romperse).
INSERT INTO public.tbl_region_locacion_erp
    (id, fecha_creacion, id_locacion, nombre_region, codigo_region, estado, id_pais_select)
SELECT
    e.id,                                   -- region.id = estado.id (preservado)
    COALESCE(e.fecha_creacion, NOW()),
    l.id,                                   -- id_locacion REAL de la locación del país
    e.nombre_estado,
    NULL,                                   -- codigo_region (no existe en legacy)
    '1',
    l.id
FROM public.tbl_pais_estado_erp e
JOIN public.tbl_pais_erp p     ON p.id::text = e.id_pais
JOIN public.tbl_locacion_erp l ON UPPER(TRIM(l.codigo_pais)) = UPPER(TRIM(p.codigo_pais))
WHERE COALESCE(p.codigo_pais, '') <> ''
ON CONFLICT (id) DO NOTHING;

-- ── 2. CIUDADES desde LEGACY, enlazadas a locación (país por ISO) y región (estado) ──
INSERT INTO public.tbl_ciudad_locacion_erp
    (id, fecha_creacion, id_locacion, id_region, nombre_ciudad, codigo_ciudad, estado,
     acceso_terrestre, acceso_maritimo, acceso_aereo, tipo_ubicacion,
     nombre_aereopuerto, nombre_puerto, id_pais_select, id_estado_select)
SELECT
    c.id,                                   -- ciudad.id = ciudad_legacy.id (preservado)
    COALESCE(c.fecha_creacion, NOW()),
    l.id,                                   -- id_locacion REAL
    c.id_estado,                            -- id_region == region.id (preservado)
    c.nombre_ciudad,
    NULL,                                   -- codigo_ciudad (se rellena en el paso 3b)
    '1',
    c.acceso_terrestre,
    c.acceso_maritimo,
    c.acceso_aereo,
    c.tipo_ubicacion,
    c.nombre_aereopuerto,
    c.nombre_puerto,
    l.id,                                   -- id_pais_select
    c.id_estado                             -- id_estado_select
FROM public.tbl_pais_estado_ciudad_erp c
JOIN public.tbl_pais_erp p     ON p.id::text = c.id_pais
JOIN public.tbl_locacion_erp l ON UPPER(TRIM(l.codigo_pais)) = UPPER(TRIM(p.codigo_pais))
WHERE COALESCE(p.codigo_pais, '') <> ''
ON CONFLICT (id) DO NOTHING;

-- ── 3. Nombre del país por ISO: la semilla dejó `pais` con un número SECUENCIAL (1..200),
--       NO el id legacy. Por eso renombrar por número fallaba salvo cuando el contador coincidía
--       con el id legacy (Chile=38 cuadró de casualidad). El identificador real es el ISO
--       (codigo_pais), así que tomamos el nombre del catálogo legacy emparejando por ISO.
--       Sobrescribe TODAS las filas con ISO conocido -> corrige los vacíos Y los nombres
--       mal puestos por una corrida anterior. Idempotente (re-setea al mismo nombre).
UPDATE public.tbl_locacion_erp l
SET pais = p.nombre_pais
FROM public.tbl_pais_erp p
WHERE UPPER(TRIM(p.codigo_pais)) = UPPER(TRIM(l.codigo_pais))
  AND COALESCE(p.nombre_pais, '') <> '';

-- ── 3b. Location Code de CIUDAD estilo UN/LOCODE: ISO del país + 3 primeras LETRAS del
--        nombre de la ciudad (Ancud -> CLANC, Arica -> CLARI). Las ciudades legacy no traían
--        código propio, así que lo generamos. Es un código POR CIUDAD (no todo "CL") y editable
--        luego en la modal. Puede haber colisiones (p.ej. dos ciudades "Antofagasta…" -> CLANT);
--        ajústalas a mano si hace falta.
--        El WHERE incluye `= l.codigo_pais` para REEMPLAZAR las que una corrida anterior dejó
--        en "CL" pelado; idempotente: una 2ª corrida ya no cambia nada porque el código generado
--        no es igual al ISO del país.
UPDATE public.tbl_ciudad_locacion_erp c
SET codigo_ciudad = UPPER(l.codigo_pais)
    || UPPER(SUBSTRING(regexp_replace(COALESCE(c.nombre_ciudad, ''), '[^A-Za-z]', '', 'g') FROM 1 FOR 3))
FROM public.tbl_locacion_erp l
WHERE c.id_locacion = l.id::text
  AND (c.codigo_ciudad IS NULL OR c.codigo_ciudad = '' OR c.codigo_ciudad = l.codigo_pais)
  AND l.codigo_pais IS NOT NULL
  AND l.codigo_pais <> '';

-- ── 3c. (OPCIONAL) Location Code de REGIÓN/ESTADO con el mismo criterio (ISO del país).
--        Descomenta este bloque si también quieres "CL - Biobío" en el select de Estado.
-- UPDATE public.tbl_region_locacion_erp r
-- SET codigo_region = l.codigo_pais
-- FROM public.tbl_locacion_erp l
-- WHERE r.id_locacion = l.id::text
--   AND (r.codigo_region IS NULL OR r.codigo_region = '')
--   AND l.codigo_pais IS NOT NULL
--   AND l.codigo_pais <> '';

-- ── 4. Reajustar secuencias para que las próximas altas no choquen con los ids copiados.
SELECT setval(pg_get_serial_sequence('public.tbl_region_locacion_erp', 'id'),
              GREATEST((SELECT COALESCE(MAX(id), 1) FROM public.tbl_region_locacion_erp), 1), true)
WHERE pg_get_serial_sequence('public.tbl_region_locacion_erp', 'id') IS NOT NULL;

SELECT setval(pg_get_serial_sequence('public.tbl_ciudad_locacion_erp', 'id'),
              GREATEST((SELECT COALESCE(MAX(id), 1) FROM public.tbl_ciudad_locacion_erp), 1), true)
WHERE pg_get_serial_sequence('public.tbl_ciudad_locacion_erp', 'id') IS NOT NULL;

COMMIT;

-- ── Verificación rápida (opcional) ──
-- SELECT (SELECT COUNT(*) FROM public.tbl_locacion_erp)        AS locaciones,
--        (SELECT COUNT(*) FROM public.tbl_region_locacion_erp) AS regiones,
--        (SELECT COUNT(*) FROM public.tbl_ciudad_locacion_erp) AS ciudades;
-- SELECT id, pais, codigo_pais FROM public.tbl_locacion_erp WHERE codigo_pais = 'CL';  -- debe decir 'Chile'

-- NOTA 1 (Location Code de ciudad): las ciudades legacy no traían código propio. El paso 3b
--   genera un código estilo UN/LOCODE = ISO + 3 letras del nombre (Ancud -> CLANC) y la ciudad
--   se muestra "CLANC - Ancud". Es editable por ciudad en la modal de Locaciones.
--
-- NOTA 2 (registros viejos): si la locación fue sembrada en tabla vacía, locacion.id == id
--   del país legacy, por lo que los quotes/house/master ya guardados (con ids legacy)
--   resuelven solos. Si los ids no coinciden, esos registros viejos mostrarán el país/ciudad
--   en blanco hasta re-guardarse (es el caso "solo nuevos guardados" ya acordado).
