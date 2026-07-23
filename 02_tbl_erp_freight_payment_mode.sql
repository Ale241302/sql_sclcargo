-- Catálogo: Freight Payment Mode (Prepaid / Collect)
-- Usado en: crearhouse/editarhouse (val_payment_terms)
-- NOTA: NO confundir con tbl_erp_payment_terms (plantillas de términos de pago de quotes).
-- data-value = codigo (PPX/CCX). Estos códigos alimentan el XML del manifiesto; se conservan tal cual.

CREATE TABLE IF NOT EXISTS public.tbl_erp_freight_payment_mode (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    codigo         VARCHAR(50)  NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1',
    CONSTRAINT uq_tbl_erp_freight_payment_mode_codigo UNIQUE (codigo)
);

INSERT INTO public.tbl_erp_freight_payment_mode (codigo, nombre) VALUES
    ('PPX', 'Prepaid'),
    ('CCX', 'Collect')
ON CONFLICT (codigo) DO NOTHING;
