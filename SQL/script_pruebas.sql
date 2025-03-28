use ods_maestro_saldo;



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
        CURDATE() AS processdate, 
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
        AND c.m_deuda_vcda > 0
        AND e.ic_impago > 0
        AND h.s_cod_es <> '021'
        AND CURDATE() = DATE_ADD(c.d_fec_top_pag, INTERVAL 1 DAY) #Fecha de ejecución debe ser el día siguiente a la Fecha Tope de Pago:
        AND f.dr_fecvenmov > CURDATE();
        
    






