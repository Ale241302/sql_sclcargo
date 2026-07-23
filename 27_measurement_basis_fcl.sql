-- Catálogo: Measurement Basis (submódulo 34) — registros de unidades y métodos de envío.
--
-- Agrega la columna is_maritimo_fcl si no existe, y actualiza los registros
-- de la tabla tbl_erp_measurement_basis con sus respectivos funcionamientos
-- y flags habilitados para los diferentes métodos de envío.

ALTER TABLE public.tbl_erp_measurement_basis
    ADD COLUMN IF NOT EXISTS is_maritimo_fcl BOOLEAN DEFAULT false;

-- Asegurar que los registros antiguos no queden con is_maritimo_fcl en NULL
UPDATE public.tbl_erp_measurement_basis SET is_maritimo_fcl = false WHERE is_maritimo_fcl IS NULL;

-- Insertar/actualizar registros
INSERT INTO public.tbl_erp_measurement_basis (id, des, funcionamiento, is_air, is_maritimo, is_road, is_maritimo_fcl, activo, estado)
VALUES
    (1, 'Shipment', 'SHIPMENT', true, true, true, true, true, '1'),
    (2, 'Container Count', 'CONTAINER_COUNT', false, false, true, true, true, '1'),
    (3, 'TEU', NULL, false, false, true, true, true, '1'),
    (4, 'Container Type', 'CONTAINER_COUNT', false, false, true, true, true, '1'),
    (5, 'Free Days', 'FREE_DAYS', false, true, false, true, true, '1'),
    (6, 'Free Days + Container Type', 'FREE_DAYS_CONTAINER', false, true, false, true, true, '1'),
    (7, 'Unit', 'PACKAGE_COUNT', true, true, true, true, true, '1'),
    (8, 'Weight', 'WEIGHT', true, true, false, false, true, '1'),
    (9, 'Volume', 'VOLUME', true, true, false, false, true, '1'),
    (10, 'Chargeable', 'VOLUMETRIC_WEIGHT', true, true, false, false, true, '1'),
    (11, 'W/M', 'VOLUMETRIC_WEIGHT', false, true, false, false, true, '1'),
    (12, 'Minimum', 'MINIMUM', true, true, false, false, true, '1')
ON CONFLICT (id) DO UPDATE SET
    des = EXCLUDED.des,
    funcionamiento = EXCLUDED.funcionamiento,
    is_air = EXCLUDED.is_air,
    is_maritimo = EXCLUDED.is_maritimo,
    is_road = EXCLUDED.is_road,
    is_maritimo_fcl = EXCLUDED.is_maritimo_fcl,
    activo = EXCLUDED.activo,
    estado = EXCLUDED.estado;

-- Ajustar secuencia del id para que futuras inserciones no colisionen
SELECT setval(pg_get_serial_sequence('public.tbl_erp_measurement_basis', 'id'), COALESCE((SELECT MAX(id) FROM public.tbl_erp_measurement_basis), 1));
