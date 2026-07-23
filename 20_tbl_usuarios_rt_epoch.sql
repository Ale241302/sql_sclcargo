-- ============================================================================
-- 20_tbl_usuarios_rt_epoch.sql
-- Soporte para el REFRESH TOKEN (sesión persistente sin re-login).
-- El JWT de refresh (cookie httpOnly scl_rt) lleva un "epoch"; al hacer logout
-- se incrementa tbl_usuarios.rt_epoch para invalidar TODOS los tokens previos.
-- Sin esta columna la revocación no persiste y, según el entorno, el refresh
-- puede no renovar la sesión => el sistema vuelve a pedir iniciar sesión.
-- Ejecutar manualmente en la base de datos PostgreSQL de PRODUCCIÓN.
-- ============================================================================

ALTER TABLE public.tbl_usuarios
    ADD COLUMN IF NOT EXISTS rt_epoch INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN public.tbl_usuarios.rt_epoch
    IS 'Contador de revocación de refresh tokens (se incrementa en logout / revocar_refresh_token).';
