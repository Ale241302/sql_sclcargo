-- Migrate value_tax in tbl_erp_buytariff_charge from percentage to tax ID
UPDATE public.tbl_erp_buytariff_charge c
SET value_tax = CAST(i.id AS text)
FROM public.tbl_erp_acounting_impuestos i
WHERE i.borrado = false 
  AND c.value_tax IS NOT NULL 
  AND c.value_tax <> '' 
  AND c.value_tax <> '0'
  AND CAST(REPLACE(c.value_tax, '%', '') AS numeric) = i.porcentaje_impuesto;

-- Migrate value_tax in tbl_erp_selltariff_charge from percentage to tax ID
UPDATE public.tbl_erp_selltariff_charge c
SET value_tax = CAST(i.id AS text)
FROM public.tbl_erp_acounting_impuestos i
WHERE i.borrado = false 
  AND c.value_tax IS NOT NULL 
  AND c.value_tax <> '' 
  AND c.value_tax <> '0'
  AND CAST(REPLACE(c.value_tax, '%', '') AS numeric) = i.porcentaje_impuesto;
