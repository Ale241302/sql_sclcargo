-- Catálogo: Organizations Position (cargo del Contact Person)
-- Usado en: crearorganization/editarorganization (modal Contact Person -> select "Position")
-- Backend: OrganizacitionsController (crearOrganizationsPosition / editarOrganizationsPosition / listar_helpers_organizations)
-- Modelo:  TblErpOrganizationsPosition

CREATE TABLE IF NOT EXISTS public.tbl_erp_organizations_position (
    id             SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    nombre_postion VARCHAR(150) NOT NULL,
    estado         CHAR(1)      DEFAULT '1'
);

INSERT INTO public.tbl_erp_organizations_position (nombre_postion) VALUES
    ('finanzas'),
    ('pagos'),
    ('ventas'),
    ('customer'),
    ('gerencia comercial'),
    ('gerencia operativa'),
    ('gerencia finanzas'),
    ('gerencia general');
