CREATE DEFINER=`root`@`localhost` PROCEDURE `pa_mdp_i_debito_pendiente`(
	IN batch_id VARCHAR(36), -- nuevo campo uuid
    OUT s_codigo INT,         -- Código de error/éxito
    OUT s_mensaje VARCHAR(255) -- Mensaje descriptivo
)
BEGIN

	DECLARE v_fec_proceso DATE;
    DECLARE v_filas_insertada INT DEFAULT 0;
    
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET s_codigo = 1;
        SET s_mensaje = 'Error al insertar datos en emi_t_debito_pendientes';
    END;
    
    SET v_fec_proceso = DATE(NOW());
    
    -- Insertar registros en emi_t_debito_pendientes combinando domiciliados y vencidos
    INSERT INTO emi_t_debito_diario (
        db_pan, 
        db_cuenta, 
        db_identcli, 
        db_numdoc, 
        db_status,
		db_ctargo1,
		db_clamon1, 
		db_ctargo2, 
		db_clamon2,
        db_pago_min, 
        db_pago_contado, 
        db_d_fec_top_pag, 
        db_cu_forpago, 
        db_fecext, 
        db_impmin, 
        db_ic_impago, 
        db_ic_numrecimp,
        db_dr_fecvenmov, 
        db_tip_deb, 
        db_processdate, 
        db_estado_actual, 
        db_batch_id
    )
    SELECT 
        a.mp_pan, a.mp_cuenta, a.mp_identcli, b.p1_numdoc, h.s_cod_es,
		d.lc_ctargo1, d.lc_clamon1, d.lc_ctargo2, d.lc_clamon2, 
        e.m_pago_min, e.m_pago_contado, e.d_fec_top_pag, f.cu_forpago,
        g.ex_fecext, g.ex_impmin, l.ic_impago, l.ic_numrecimp,
        m.dr_fecvenmov, 'Domiciliado', v_fec_proceso, 'pendiente', batch_id
    FROM 
        medio_pago_tarjeta_mp a
        INNER JOIN datos_comunes_personas_p1 b ON a.mp_identcli = b.p1_identcli
        INNER JOIN limite_cuenta_lc d ON a.mp_cuenta = d.lc_cuenta
        INNER JOIN emi_maestro_cartera_diaria e ON a.mp_cuenta = e.i_num_cuenta
        INNER JOIN cuenta_medio_pago_cu f ON a.mp_cuenta = f.cu_cuenta
        INNER JOIN contrato_impagado_ic l ON a.mp_cuenta = l.ic_cuenta 
        INNER JOIN desgloce_por_linea_ultimo_recibido_dr m ON a.mp_cuenta = m.dr_cuenta
        INNER JOIN emi_t_ext_cred_ex g ON a.mp_cuenta = g.ex_cuenta
        INNER JOIN estado_cuenta_tarjeta h ON a.mp_pan = h.s_pan
    WHERE 
        a.mp_calpart = 'TI' -- sea titular
        AND b.p1_indrepos = 'S' -- sea domiciliado
        AND h.s_cod_es = '000000000-2-1-5' -- un campo que se agrego (para saber si la tarjeta esta Activa o Inactiva)
        AND DATE(e.d_fec_top_pag) = v_fec_proceso  -- validar que la fecha de tope sea igual a la fecha del proceso
		AND g.ex_impmin > 0 -- validar por cada dédito  que el campo IMPMIN no haya realizado el pago ya que si el valor es igual a 0 no se debe realizar el debito.
        AND (
            (f.cu_forpago = '03' AND e.m_pago_min > 0) --  validar si el cliente tiene el valor 03 en FORPAGO se debe considerar que el saldo campo pago minimo sea mayor a cero
            OR
            (f.cu_forpago = '04' AND e.m_pago_contado > 0) -- - validar si el cliente tiene el valor 04 en FORPAGO considerar que el saldo del campos m_pago_contado sea mayor 0
        )
        AND v_fec_proceso <= DATE(g.ex_fecext) -- El proceso se debe realizar hasta la fecha de cierre del siguiente ciclo de facturación(FECHA DE CORTE-> FECEXT)
    UNION ALL
    SELECT 
        a.mp_pan, a.mp_cuenta, a.mp_identcli, b.p1_numdoc, h.s_cod_es,
        d.lc_ctargo1, d.lc_clamon1, d.lc_ctargo2, d.lc_clamon2, 
        e.m_pago_min, e.m_pago_contado, e.d_fec_top_pag, f.cu_forpago,
        g.ex_fecext, g.ex_impmin, l.ic_impago, l.ic_numrecimp,
        m.dr_fecvenmov, 'Vencida', v_fec_proceso, 'pendiente', batch_id
    FROM 
        medio_pago_tarjeta_mp a
        INNER JOIN datos_comunes_personas_p1 b ON a.mp_identcli = b.p1_identcli
        INNER JOIN limite_cuenta_lc d ON a.mp_cuenta = d.lc_cuenta
        INNER JOIN emi_maestro_cartera_diaria e ON a.mp_cuenta = e.i_num_cuenta
        INNER JOIN cuenta_medio_pago_cu f ON a.mp_cuenta = f.cu_cuenta
        INNER JOIN emi_t_ext_cred_ex g ON a.mp_cuenta = g.ex_cuenta
        INNER JOIN venta_cartera_castigada k ON a.mp_cuenta = k.cuenta
        INNER JOIN contrato_impagado_ic l ON a.mp_cuenta = l.ic_cuenta 
        INNER JOIN desgloce_por_linea_ultimo_recibido_dr m ON a.mp_cuenta = m.dr_cuenta
        INNER JOIN estado_cuenta_tarjeta h ON a.mp_pan = h.s_pan
    WHERE
		-- reglas de negocio
		a.mp_calpart = 'TI' -- sea titular 
		AND b.p1_indrepos = 'N' -- cliento no domiciliado
        AND l.ic_impago  > 0 
        AND k.estado = '021'  -- Excluir tarjetas con estado "VENTA de CARTERA CASTIGADA" (020)
        AND (d.lc_ctargo1 IS NOT NULL AND d.lc_ctargo1 != '') -- Validar que lc_ctargo1  no estén vacíos y la cadena este vacia son la cuenta a debitar
        AND (d.lc_ctargo2 IS NOT NULL AND d.lc_ctargo2 != '') -- Validar que lc_ctargo2 no estén vacíos y la cadena este vacia son la cuentas a debitar
        -- caso
        AND(
			( e.m_deuda_vcda > 0 AND h.ic_numrecimp = 1 AND v_fec_proceso > DATE(e.d_fec_top_pag)) -- Caso a: Valor Vencido de Clientes con 1 Pago Vencido en adelante antes de la fecha tope de pago
            OR(e.m_pago_min > 0 AND h.ic_numrecimp >= 1 AND v_fec_proceso > DATE(e.d_fec_top_pag)) -- Caso b: Valor Pago Mínimo de Clientes con 1 Pago Vencido en adelante desde la fecha tope de pago
            OR(e.m_pago_min > 0 AND h.ic_numrecimp = 0 AND v_fec_proceso  >= DATE(g.ex_fecext)) -- Caso c: Valor Pago Mínimo de Clientes con 0 Pagos Vencidos y que aún no han pagado, estando a N días de cerrar el ciclo
            OR(e.m_deuda_vcda <= e.m_pago_min) -- Caso d: Valor Mínimo de clientes vencidos o parciales que estén próximos a cerrar el Ciclo de Facturación
        )
        AND DATE(m.dr_fecvenmov) > v_fec_proceso; -- Validar que el campo “FECVENMOV” sea mayor a la fecha de ejecución del proceso.
        
	SET v_filas_insertada = ROW_COUNT();  
    -- Validar si se insertaron registros
    IF v_filas_insertada > 0 THEN
        SET s_codigo = 0;
        SET s_mensaje = CONCAT('Se insertaron ', v_filas_insertada, ' registros correctamente.');
    ELSE
        SET s_codigo = 2;
        SET s_mensaje = 'No se insertaron registros.';
    END IF;
    
END

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pa_i_batch_proceso`(OUT s_batch_id VARCHAR(36))
BEGIN
    DECLARE EXISTS HANDLER FOR SQLEXCEPTION
    BEGIN
        -- En caso de error, establecer el UUID en NULL y generar un error controlado
        SET s_batch_id = NULL;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar el batch_proceso';
    END;
    
    -- Generar un UUID
    SET s_batch_id = UUID();
    
    -- Insertar el registro con valores por defecto
    INSERT INTO emit_t_dba_batch (batch_id) VALUES (s_batch_id);
    
    -- Confirmar la inserción
    IF ROW_COUNT() = 0 THEN
        SET s_batch_id = NULL;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pudo insertar el registro en batch_procesos';
    END IF;
END $$

DELIMITER ;




DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pa_obtener_parametro`(IN e_pa_id INT, OUT s_pa_valor TEXT)
BEGIN
    DECLARE v_pa_valor TEXT;

    -- Obtener el valor de pa_valor
    SELECT pa_valor INTO v_pa_valor
    FROM emi_tc_m_parametro
    WHERE pa_id = e_pa_id;

    -- Asignar el valor al parámetro de salida
    SET s_pa_valor = v_pa_valor;
END
DELIMITER ;




