-- ════════════════════════════════════════════════════════════════════
--  Correos en copia (CC/BCC) por configuración de correo (SMTP)
--  Relaciona una configuración (tbl_erp_configuracionn_mail) con los
--  usuarios ERP cuyos correos recibirán copia de los envíos del sistema.
--  Ejecutar manualmente.
-- ════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.tbl_erp_configuracionn_mail_corrreo_copia (
    id               SERIAL PRIMARY KEY,
    fecha_creacion   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    id_configuracion INTEGER NOT NULL,
    id_user          INTEGER NOT NULL,
    CONSTRAINT fk_corrreo_copia_configuracion
        FOREIGN KEY (id_configuracion)
        REFERENCES public.tbl_erp_configuracionn_mail (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_corrreo_copia_user
        FOREIGN KEY (id_user)
        REFERENCES public.tbl_usuarios (id)
        ON DELETE CASCADE,
    CONSTRAINT uq_corrreo_copia_config_user
        UNIQUE (id_configuracion, id_user)
);

CREATE INDEX IF NOT EXISTS idx_corrreo_copia_configuracion
    ON public.tbl_erp_configuracionn_mail_corrreo_copia (id_configuracion);
