-- Migración: pasa el catálogo de almacenistas de Aduana (tbl_almacenista_bl) a organizaciones
-- (tbl_erp_organizations_list) marcadas como Almacén (is_warehouse=true) + su dirección por
-- defecto (tbl_erp_organizations_address). Así aparecen en el select "Search warehouse keeper"
-- del manifiesto (que ahora se alimenta de warehouse_orgs = orgs con is_warehouse=true).
-- Idempotente: puede correrse varias veces sin duplicar (dedupe por nombre).

-- 0) Asegurar columnas nuevas (por si el entorno aún no las tiene).
ALTER TABLE public.tbl_erp_organizations_list
    ADD COLUMN IF NOT EXISTS is_warehouse boolean DEFAULT false,
    ADD COLUMN IF NOT EXISTS cod_almacen  text;

-- 1) Crear una organización por cada almacenista (dedupe por nombre; tax_id = valor_id,
--    cod_almacen = codigo_almacen). No se recrea si ya existe una org-almacén con ese nombre.
INSERT INTO public.tbl_erp_organizations_list
    (name_organization, tax_id, cod_almacen, is_warehouse, estado, fecha_creacion)
SELECT DISTINCT ON (UPPER(TRIM(a.nombre)))
       TRIM(a.nombre),
       NULLIF(TRIM(a.valor_id), ''),
       NULLIF(TRIM(a.codigo_almacen), ''),
       true,
       '1',
       now()
FROM public.tbl_almacenista_bl a
WHERE COALESCE(TRIM(a.nombre), '') <> ''
  AND NOT EXISTS (
      SELECT 1 FROM public.tbl_erp_organizations_list o
      WHERE o.is_warehouse = true
        AND UPPER(TRIM(o.name_organization)) = UPPER(TRIM(a.nombre))
  )
ORDER BY UPPER(TRIM(a.nombre)), a.id;

-- 2) Dirección por defecto de cada org migrada (link por nombre). País = Chile (los
--    almacenistas de Aduana son extraportuarios chilenos; su columna nacion venía vacía).
--    Ciudad = match por nombre contra tbl_ciudad_locacion_erp (best-effort, NULL si no hay).
INSERT INTO public.tbl_erp_organizations_address
    (id_organizations, address_type, address, id_pais, id_city, "default", fecha_creacion)
SELECT DISTINCT ON (o.id)
       o.id::text,
       'Delivery Address',
       a.direccion,
       (SELECT l.id::text FROM public.tbl_locacion_erp l
         WHERE UPPER(l.codigo_pais) = 'CL' OR UPPER(l.pais) = 'CHILE'
         ORDER BY l.id LIMIT 1),
       (SELECT c.id::text FROM public.tbl_ciudad_locacion_erp c
         WHERE UPPER(TRIM(c.nombre_ciudad)) = UPPER(TRIM(a.ciudad))
         ORDER BY c.id LIMIT 1),
       '1',
       now()
FROM public.tbl_almacenista_bl a
JOIN public.tbl_erp_organizations_list o
     ON o.is_warehouse = true
    AND UPPER(TRIM(o.name_organization)) = UPPER(TRIM(a.nombre))
WHERE NOT EXISTS (
    SELECT 1 FROM public.tbl_erp_organizations_address ad
    WHERE ad.id_organizations = o.id::text
)
ORDER BY o.id, a.id;
