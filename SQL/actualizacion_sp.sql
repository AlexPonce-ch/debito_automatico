DELIMITER $$

CREATE PROCEDURE pa_mdp_c_debito_pendiente()
BEGIN

	DECLARE v_fec_proceso DATE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'ERROR' AS status, 'Ocurrió un error durante la ejecución del SP' AS message;
    END;
    
    SET v_fec_proceso = CURDATE();

    -- DOM
    SELECT 
        a.mp_pan, 
        a.mp_cuenta, 
        a.mp_identcli, 
        CASE WHEN d.cu_forpago = 03 THEN c.m_pago_min ELSE NULL END AS m_pago_min,
        CASE WHEN d.cu_forpago = 04 THEN c.m_pago_contado ELSE NULL END AS m_pago_contado,
        d.cu_forpago,
        c.m_deuda_vcda, 
        e.ic_numrecimp,
        c.d_fec_top_pag, 
        g.ex_fecext, 
        f.dr_fecvenmov, 
        g.ex_impmin, 
        e.ic_impago, 
        v_fec_proceso AS processdate, 
        'DOM' AS db_tip_deb, 
        'Pendiente' AS db_est_proce
    FROM medio_pago_tarjeta_mp a  
    INNER JOIN datos_comunes_personas_p1 b ON a.mp_identcli = b.p1_identcli
    INNER JOIN emi_maestro_cartera_diaria c ON a.mp_cuenta = c.i_num_cuenta
    INNER JOIN cuenta_medio_pago_cu d ON a.mp_cuenta = d.cu_cuenta
    INNER JOIN contrato_impagado_ic e ON a.mp_cuenta = e.ic_cuenta 
    INNER JOIN desgloce_por_linea_ultimo_recibido_dr f ON a.mp_cuenta = f.dr_cuenta
    INNER JOIN emi_t_ext_cred_ex g ON a.mp_cuenta = g.ex_cuenta
    INNER JOIN ods_estado_cuenta_tarjeta h ON a.mp_pan = h.s_pan
    INNER JOIN venta_cartera_castigada i ON a.mp_cuenta = i.cuenta
    WHERE
        b.p1_indrepos = 'S'
        AND a.mp_calpart = 'TI'
        AND h.s_cod_es = '000000000-2-1-5'
        AND (
            (d.cu_forpago = 03 AND c.m_pago_min > 0)
            OR
            (d.cu_forpago = 04 AND c.m_pago_contado > 0)
        )
        -- AND (c.d_fec_top_pag = v_fec_proceso)
		AND (v_fec_proceso >= c.d_fec_top_pag AND v_fec_proceso <= g.ex_fecext)
        AND c.m_deuda_vcda > 0

    UNION ALL

    -- VEN (sin cambios)
    SELECT 
        a.mp_pan, 
        a.mp_cuenta, 
        a.mp_identcli, 
        c.m_pago_min, 
        c.m_pago_contado, 
        d.cu_forpago,
        c.m_deuda_vcda, 
        e.ic_numrecimp,
        c.d_fec_top_pag, 
        g.ex_fecext, 
        f.dr_fecvenmov, 
        g.ex_impmin, 
        e.ic_impago, 
        v_fec_proceso AS processdate, 
        'VEN' AS db_tip_deb, 
        'Pendiente' AS db_est_proce
    FROM medio_pago_tarjeta_mp a  
    INNER JOIN datos_comunes_personas_p1 b ON a.mp_identcli = b.p1_identcli
    INNER JOIN emi_maestro_cartera_diaria c ON a.mp_cuenta = c.i_num_cuenta
    INNER JOIN cuenta_medio_pago_cu d ON a.mp_cuenta = d.cu_cuenta
    INNER JOIN contrato_impagado_ic e ON a.mp_cuenta = e.ic_cuenta 
    INNER JOIN desgloce_por_linea_ultimo_recibido_dr f ON a.mp_cuenta = f.dr_cuenta
    INNER JOIN emi_t_ext_cred_ex g ON a.mp_cuenta = g.ex_cuenta
    INNER JOIN ods_estado_cuenta_tarjeta h ON a.mp_pan = h.s_pan
    INNER JOIN venta_cartera_castigada i ON a.mp_cuenta = i.cuenta
    WHERE
        a.mp_calpart = 'TI'
        AND e.ic_impago > 0
        AND h.s_cod_es <> '21'
        AND (
            (c.m_deuda_vcda > 0 AND e.ic_numrecimp >= 1 AND v_fec_proceso < c.d_fec_top_pag AND v_fec_proceso >= DATE_ADD(g.ex_fecext, INTERVAL 1 DAY))
            OR (c.m_pago_min > 0 AND e.ic_numrecimp >= 1 AND v_fec_proceso > c.d_fec_top_pag AND v_fec_proceso >= DATE_ADD(g.ex_fecext, INTERVAL 1 DAY))
        )
        AND v_fec_proceso = DATE_ADD(c.d_fec_top_pag, INTERVAL 1 DAY)
        AND f.dr_fecvenmov > v_fec_proceso;
END $$

DELIMITER ;

CALL pa_mdp_c_debito_pendiente();