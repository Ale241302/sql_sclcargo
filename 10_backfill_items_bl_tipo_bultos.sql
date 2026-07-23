-- Backfill de tbl_items_bl.tipo_bultos: convierte valores antiguos (nombre de unidad EDIFACT en inglés
-- como "BAG (Bag)", o código de contenedor como "20GP", o código numérico) al NOMBRE de bulto español
-- (convención del manifiesto). NO toca filas que ya son un nombre de bulto válido.
-- Idempotente: correrlo de nuevo no cambia nada (las filas ya quedan como nombre válido y se excluyen).

UPDATE public.tbl_items_bl b
SET tipo_bultos = tb.nombre
FROM public.tbl_erp_tipo_bulto tb
WHERE tb.codigo = COALESCE(
        NULLIF((SELECT a.codigo_bulto FROM public.tbl_erp_unit_measures_unidades_asociadas a
                WHERE a.unidad_medida = b.tipo_bultos LIMIT 1), ''),
        NULLIF((SELECT c.codigo_bulto FROM public.tbl_erp_container_type c
                WHERE c.codigo_container = b.tipo_bultos LIMIT 1), ''),
        CASE WHEN b.tipo_bultos ~ '^[0-9]+$' THEN b.tipo_bultos END
      )
  AND b.tipo_bultos IS NOT NULL
  AND b.tipo_bultos <> ''
  AND b.tipo_bultos NOT IN (SELECT nombre FROM public.tbl_erp_tipo_bulto);
