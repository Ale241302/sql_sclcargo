-- Vínculo determinista package-type -> código de bulto Aduana.
-- LCL: tbl_erp_unit_measures_unidades_asociadas (pack units EDIFACT, ej. "BAG (Bag)")
-- FCL: tbl_erp_container_type (ej. "20GP", "40RE")
-- El backend (manifestarHouseAction) leerá codigo_bulto para llenar tipo_bultos del manifiesto.

ALTER TABLE public.tbl_erp_unit_measures_unidades_asociadas
    ADD COLUMN IF NOT EXISTS codigo_bulto VARCHAR(10);

ALTER TABLE public.tbl_erp_container_type
    ADD COLUMN IF NOT EXISTS codigo_bulto VARCHAR(10);

-- ── Seed LCL: por prefijo EDIFACT (3 letras antes del primer espacio) ──
UPDATE public.tbl_erp_unit_measures_unidades_asociadas
SET codigo_bulto = CASE UPPER(split_part(unidad_medida, ' ', 1))
    WHEN 'BAG' THEN '64'  WHEN 'BAL' THEN '65'  WHEN 'BBG' THEN '64'  WHEN 'BBL' THEN '44'
    WHEN 'BDL' THEN '90'  WHEN 'BIC' THEN '24'  WHEN 'BKG' THEN '64'  WHEN 'BKT' THEN '51'
    WHEN 'BLC' THEN '65'  WHEN 'BLE' THEN '65'  WHEN 'BLU' THEN '65'  WHEN 'BND' THEN '90'
    WHEN 'BOB' THEN '91'  WHEN 'BOT' THEN '32'  WHEN 'BOX' THEN '22'  WHEN 'BSK' THEN '36'
    WHEN 'BXI' THEN '22'  WHEN 'BXT' THEN '51'  WHEN 'CAG' THEN '33'  WHEN 'CAN' THEN '29'
    WHEN 'CAS' THEN '40'  WHEN 'CBC' THEN '78'  WHEN 'CBY' THEN '43'  WHEN 'CCS' THEN '29'
    WHEN 'CHS' THEN '24'  WHEN 'CNA' THEN '78'  WHEN 'CNB' THEN '78'  WHEN 'CNC' THEN '78'
    WHEN 'CND' THEN '78'  WHEN 'CNE' THEN '78'  WHEN 'CNF' THEN '78'  WHEN 'CNT' THEN '78'
    WHEN 'CNX' THEN '78'  WHEN 'COI' THEN '91'  WHEN 'COL' THEN '91'  WHEN 'CRT' THEN '21'
    WHEN 'CSK' THEN '38'  WHEN 'CTN' THEN '22'  WHEN 'CUB' THEN '51'  WHEN 'CYL' THEN '12'
    WHEN 'DRM' THEN '45'  WHEN 'DUF' THEN '64'  WHEN 'ENV' THEN '67'  WHEN 'FIR' THEN '37'
    WHEN 'FLX' THEN '64'  WHEN 'FRM' THEN '26'  WHEN 'FSK' THEN '42'  WHEN 'HGH' THEN '38'
    WHEN 'HMP' THEN '36'  WHEN 'HRB' THEN '22'  WHEN 'JAR' THEN '41'  WHEN 'JUG' THEN '41'
    WHEN 'KEG' THEN '37'  WHEN 'LBK' THEN '4'   WHEN 'LOG' THEN '18'  WHEN 'LSE' THEN '98'
    WHEN 'MLV' THEN '78'  WHEN 'MPK' THEN '61'  WHEN 'MRP' THEN '13'  WHEN 'MSV' THEN '78'
    WHEN 'PAI' THEN '51'  WHEN 'PAL' THEN '51'  WHEN 'PCE' THEN '10'  WHEN 'PCL' THEN '61'
    WHEN 'PCS' THEN '10'  WHEN 'PKG' THEN '61'  WHEN 'PLT' THEN '80'  WHEN 'POV' THEN '85'
    WHEN 'REL' THEN '83'  WHEN 'RLL' THEN '13'  WHEN 'ROL' THEN '13'  WHEN 'RVR' THEN '83'
    WHEN 'SAK' THEN '62'  WHEN 'SBC' THEN '64'  WHEN 'SCS' THEN '63'  WHEN 'SHT' THEN '89'
    WHEN 'SPI' THEN '12'  WHEN 'SPL' THEN '83'  WHEN 'SVN' THEN '78'  WHEN 'TBE' THEN '11'
    WHEN 'TIN' THEN '29'  WHEN 'TKR' THEN '77'  WHEN 'TKT' THEN '77'  WHEN 'TLD' THEN '78'
    WHEN 'TNK' THEN '77'  WHEN 'TRC' THEN '38'  WHEN 'TRI' THEN '22'  WHEN 'TRK' THEN '24'
    WHEN 'TRY' THEN '27'  WHEN 'TSS' THEN '24'  WHEN 'TTC' THEN '29'  WHEN 'TUB' THEN '11'
    WHEN 'UNP' THEN '99'  WHEN 'VEH' THEN '85'  WHEN 'VPK' THEN '78'  WHEN 'WDC' THEN '28'
    ELSE '93'
END;

-- ── Seed FCL: por tamaño / reefer del contenedor ──
UPDATE public.tbl_erp_container_type
SET codigo_bulto = CASE
    WHEN codigo_container IN ('40RE','40REHC','40NOR') THEN '76'
    WHEN codigo_container IN ('20RE','20NOR')          THEN '75'
    WHEN codigo_container LIKE '40%' OR codigo_container LIKE '42%' THEN '74'
    WHEN codigo_container LIKE '20%'                   THEN '73'
    ELSE '93'
END;
