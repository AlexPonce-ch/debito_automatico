CREATE TABLE emi_maestro_cartera_diaria (
    i_num_cuenta Varchar(12) NOT NULL,
    i_id_fec_proceso INT NOT NULL,
    i_id_fec_cor_act INT NOT NULL,
    i_empresa INT NOT NULL,
    m_sald_ant_rot DECIMAL(19,4) NOT NULL,
    m_sald_act_rot DECIMAL(19,4) NOT NULL,
    m_sald_act_dif DECIMAL(19,4) NOT NULL,
    m_por_confirmar DECIMAL(19,4) NULL,
    m_pago_min DECIMAL(19,4) NOT NULL, -- 9
    i_num_pagos_vcdos INT NULL,
    m_deuda_vcda DECIMAL(19,4) NULL,
    m_pago_min_top DECIMAL(19,4) NULL,
    m_cuotas_dif DECIMAL(19,4) NULL,
    m_sald_disponible DECIMAL(19,4) NOT NULL,
    m_pago_contado DECIMAL(19,4) NOT NULL, -- 15
    m_sobregiro DECIMAL(19,4) NULL,
    m_sald_a_favor DECIMAL(19,4) NULL,
    m_int_rot_mes DECIMAL(19,4) NULL,
    m_int_mora_mes DECIMAL(19,4) NULL,
    m_int_dif_mes DECIMAL(19,4) NULL,
    m_cupo_utilizado DECIMAL(19,4) NULL,
    i_cod_oficina INT NULL,
    i_id_calif_bb INT NULL,
    m_capital_castigado DECIMAL(19,4) NULL,
    m_capital_ngi DECIMAL(19,4) NULL,
    m_capital_rotativo DECIMAL(19,4) NULL,
    m_capital_vcdo DECIMAL(19,4) NULL,
    m_capital_x_vcer DECIMAL(19,4) NULL,
    d_fec_top_pag DATETIME NULL, -- 28
    i_fec_top_pag INT NULL,
    s_indi_tip_deb_autor VARCHAR(8) NULL,
    s_rep_r21_demand VARCHAR(8) NULL,
    s_ind_cdr_garante CHAR(1) NULL,
    s_afinidad VARCHAR(8) NULL,
    s_cta_autori_deb VARCHAR(30) NULL,
    m_a_pend_dif DECIMAL(19,4) NULL,
    s_mot_canc INT NULL,
    m_monto_ult_pag DECIMAL(19,4) NULL,
    m_monto_ult_cons DECIMAL(19,4) NULL,
    i_id_fec_ult_cons INT NULL,
    i_ejec_cta INT NULL,
    d_fec_ult_pag DATETIME NULL,
    m_pag_mes DECIMAL(19,4) NULL,
    m_cred_mes DECIMAL(19,4) NULL,
    m_dev_mes DECIMAL(19,4) NULL
);

CREATE TABLE datos_personas_fisica_p2 (
    p2_id INT AUTO_INCREMENT PRIMARY KEY,
    p2_codent CHAR(4) NOT NULL,
    p2_identcli VARCHAR(15) NOT NULL,
    p2_tiporeg CHAR(2) NOT NULL,
    p2_nombre VARCHAR(50) NOT NULL,
    p2_apelli1 VARCHAR(50) NOT NULL,
    p2_apelli2 VARCHAR(50) NOT NULL,
    p2_codpaisnct INT NOT NULL,
    p2_nompaisnct VARCHAR(50) NOT NULL,
    p2_codpaisnac INT NOT NULL,
    p2_nompaisnac VARCHAR(50) NOT NULL,
    p2_codpaisres INT NOT NULL,
    p2_nompaisres VARCHAR(50) NOT NULL,
    p2_sexper CHAR(1) NOT NULL,
    p2_indestciv CHAR(1) NOT NULL,
    p2_regecon CHAR(1) NOT NULL,
    p2_indtracor CHAR(2) NOT NULL,
    p2_fecnac DATE NOT NULL,
    p2_codprof VARCHAR(10) NOT NULL,
    p2_fecfelicita VARCHAR(4) NOT NULL,
    p2_tipfelicita CHAR(1) NOT NULL,
    p2_fecalta DATE NOT NULL,
    p2_fecbaja DATE NOT NULL,
    p2_processdate INT NOT NULL
);

CREATE TABLE datos_comunes_personas_p1 (
    p1_id INT AUTO_INCREMENT PRIMARY KEY,
    p1_codent CHAR(4) NOT NULL,
    p1_identcli VARCHAR(15) NOT NULL,
    p1_tiporeg CHAR(2) NOT NULL,
    p1_tipdoc CHAR(1) NOT NULL,
    p1_numdoc VARCHAR(20) NOT NULL,
    p1_tipper CHAR(1) NOT NULL,
    p1_estper CHAR(1) NOT NULL,
    p1_fecest DATE NOT NULL,
    p1_tipclien VARCHAR(2) NOT NULL,
    p1_subtipcli VARCHAR(2) NOT NULL,
    p1_codidioma CHAR(2) NOT NULL,
    p1_bloqueo CHAR(1) NOT NULL,
    p1_indrepos CHAR(1) NOT NULL,
    p1_nivseg INT NOT NULL,
    p1_publicidad CHAR(1) NOT NULL,
    p1_indvip CHAR(1) NOT NULL,
    p1_fecalta DATE NOT NULL,
    p1_fecbaja DATE NOT NULL,
    p1_cnae VARCHAR(20),  
    p1_codcirbe VARCHAR(20),  
    p1_claveacc VARCHAR(20),  
    p1_sitclave VARCHAR(20),  
    p1_codcontrib VARCHAR(20),  
    p1_processdate INT NOT NULL
);

CREATE TABLE medio_pago_tarjeta_mp(
    mp_id INT AUTO_INCREMENT PRIMARY KEY,
    mp_cuenta VARCHAR(12) NOT NULL,
    mp_identcli VARCHAR(8) NOT NULL,
    mp_calpart CHAR(2) NOT NULL,
    mp_pan VARCHAR(22) NOT NULL,
    mp_status char(1) NOT NULL, -- campo nuevo  
    mp_indsittar INT NOT NULL
);

CREATE TABLE cuenta_medio_pago_cu (
    cu_id INT AUTO_INCREMENT PRIMARY KEY,
    cu_codent CHAR(4) NOT NULL,
    cu_centalta CHAR(4) NOT NULL,
    cu_cuenta VARCHAR(20) NOT NULL,
    cu_tiporeg CHAR(2) NOT NULL,
    cu_numorden INT NOT NULL,
    cu_fecultcar DATE NOT NULL,
    cu_producto VARCHAR(10) NOT NULL,
    cu_subprodu VARCHAR(10) NOT NULL,
    cu_tipocto VARCHAR(10) NOT NULL,
    cu_fecproven DATE NOT NULL,
    cu_fecultven DATE NOT NULL,
    cu_fecresol DATE NOT NULL,
    cu_identcli VARCHAR(15) NOT NULL,
    cu_codblq INT NOT NULL,
    cu_indblqope CHAR(1) NOT NULL,
    cu_codestcta INT NOT NULL,
    cu_clasifcont CHAR(1) NOT NULL,
    cu_fecultestcta DATE NOT NULL,
    cu_codconven VARCHAR(10) NOT NULL,
    cu_indctaemp INT NOT NULL,
    cu_codbus INT NOT NULL,
    cu_codelemento INT NOT NULL,
    cu_tiprolcuenta CHAR(1) NOT NULL,
    cu_inddomcarcre INT NOT NULL,
    cu_forpago INT NOT NULL, -- 03 (pago aplazado) -> pago min   04 (Pago fijo con operación financiada) -> pago contado
    cu_indsitcta INT NOT NULL,
    cu_ofigestora VARCHAR(10) NOT NULL,
    cu_conprod VARCHAR(10) NOT NULL,
    cu_fecbaja DATE NOT NULL,
    cu_fecalta DATE NOT NULL,
    cu_indtipocto INT NOT NULL,
    cu_intgenmora DECIMAL(20,4) NOT NULL,
    cu_porpagoa DECIMAL(10,4) NOT NULL,
    cu_imppago DECIMAL(20,4) NOT NULL,
    cu_numextpen INT NOT NULL,
    cu_numultext INT NOT NULL,
    cu_grupoliq INT NOT NULL,
    cu_fecultfac DATE NOT NULL,
    cu_fecantfac DATE NOT NULL,
    cu_saldacre DECIMAL(15,2) NOT NULL,
    cu_saldorev DECIMAL(15,2) NOT NULL,
    cu_motbaja INT NOT NULL,
    cu_tipbon VARCHAR(20) NOT NULL,
    cu_codformato VARCHAR(20) NOT NULL,
    cu_codcam VARCHAR(10) NOT NULL,
    cu_fecultblq DATE NOT NULL,
    cu_salkact DECIMAL(15,2) NOT NULL,
    cu_porriesg DECIMAL(10,4) NOT NULL,
    cu_provriesact DECIMAL(20,4) NOT NULL,
    cu_feccalriesact DATE NOT NULL,
    cu_impdemandado DECIMAL(20,4) NOT NULL,
    cu_impdemant DECIMAL(20,4) NOT NULL,
    cu_codcat CHAR(1) NOT NULL,
    cu_fecaltacat DATE NOT NULL,
    cu_fecmodcat DATE NOT NULL,
    cu_fecbajacat DATE NOT NULL,
    cu_impdotgen DECIMAL(20,4) NOT NULL,
    cu_numdiasact INT NOT NULL,
    cu_indcrefi CHAR(2) NOT NULL,
    cu_fecrefi DATE NOT NULL,
    cu_codestbcact VARCHAR(10) NOT NULL,
    cu_codestbcant VARCHAR(10) NOT NULL,
    cu_fecultestbc DATE NOT NULL,
    cu_processdate INT NOT NULL
);


CREATE TABLE limite_cuenta_lc (
    lc_id INT AUTO_INCREMENT PRIMARY KEY,
    lc_cuenta VARCHAR(12) NOT NULL,
    lc_clamon1 INT NOT NULL,
    lc_ctargo1 VARCHAR(30),
    lc_clamon2 INT NOT NULL,
    lc_ctargo2 VARCHAR(30)
);


CREATE TABLE contrato_impagado_ic (
    ic_id INT AUTO_INCREMENT PRIMARY KEY,
    ic_cuenta VARCHAR(12) NOT NULL,
    ic_impago DECIMAL(10,2) NOT NULL,
    ic_impapl decimal (10,2) not null,
    ic_numrecimp INT NOT NULL
);

CREATE TABLE recibido_impagado_ri(
    ri_id INT AUTO_INCREMENT PRIMARY KEY,
    ri_codent CHAR(4) NOT NULL,
    ri_centalta CHAR(4) NOT NULL,
    ri_cuenta VARCHAR(20) NOT NULL,
    ri_tiporeg CHAR(2) NOT NULL,
    ri_numorden INT NOT NULL,
    ri_clamon INT NOT NULL,
    ri_numsecimp BIGINT NOT NULL,
    ri_numsecrec BIGINT NOT NULL,
    ri_fecalta DATE NOT NULL,
    ri_fecemimov DATE NOT NULL,
    ri_fecvenmov DATE NOT NULL,
    ri_imprec DECIMAL(20,2) NOT NULL,
    ri_impago DECIMAL(20,2) NOT NULL,
    ri_impapl DECIMAL(20,2) NOT NULL,
    ri_fecultapl DATE NOT NULL,
    ri_fecenvcob DATE NOT NULL,
    ri_processdate INT NOT NULL
);

CREATE TABLE emi_t_ext_cred_ex (
    ex_id BIGINT AUTO_INCREMENT,
    ex_codent CHAR(4) NOT NULL,
    ex_centalta CHAR(4) NOT NULL,
    ex_cuenta VARCHAR(12) NOT NULL,
    ex_pan VARCHAR(22) NOT NULL,
    ex_tiporeg CHAR(2) NOT NULL,
    ex_numorden BIGINT NOT NULL,
    ex_registro VARCHAR(457) NOT NULL,
    ex_tokennegocio VARCHAR(37) NOT NULL,
    ex_numextcta INT NOT NULL,
    ex_clamon INT NOT NULL,
    ex_indrep INT NOT NULL,
    ex_desindrep VARCHAR(30) NOT NULL,
    ex_forpago INT NOT NULL,
    ex_sigimptotpag CHAR(1) NOT NULL,
    ex_imptotpag DECIMAL(17,2) NOT NULL,
    ex_sigimpmin CHAR(1) NOT NULL,
    ex_impmin DECIMAL(17,2) NOT NULL,
    ex_sigimpcargo CHAR(1) NOT NULL,
    ex_impcargo DECIMAL(17,2) NOT NULL,
    ex_fecext DATE NOT NULL, -- 21
    ex_fecliq DATE NOT NULL,
    ex_fecliqant DATE NOT NULL,
    ex_feccar DATE NOT NULL,
    ex_fecvalcar DATE NOT NULL,
    ex_porint DECIMAL(7,4) NOT NULL,
    ex_porpagoa DECIMAL(7,4) NOT NULL,
    ex_sigimpexclim CHAR(1) NOT NULL,
    ex_impexclim DECIMAL(17,2) NOT NULL,
    ex_sigimsalaplprx CHAR(1) NOT NULL,
    ex_imsalaplprx DECIMAL(17,2) NOT NULL,
    ex_sigimpcargoant CHAR(1) NOT NULL,
    ex_impcargoant DECIMAL(17,2) NOT NULL,
    ex_numsecrec BIGINT NOT NULL,
    ex_inpfijoapl DECIMAL(15,2) NOT NULL,
    ex_fecvenult DATE NOT NULL,
    ex_fecvenpro DATE NOT NULL,
    ex_processdate INT NOT NULL,
    CONSTRAINT pk_ex_id PRIMARY KEY (ex_id)
);



CREATE TABLE `desgloce_por_linea_ultimo_recibido_dr` (
    `dr_id` BIGINT NOT NULL AUTO_INCREMENT,  -- Identificador único (opcional)
    `dr_cuenta` VARCHAR(20) NOT NULL,        -- Número de cuenta
    `dr_fecvenmov` DATE NOT NULL,            -- Fecha de vencimiento del movimiento
    PRIMARY KEY (`dr_id`)                    -- Clave primaria
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE venta_cartera_castigada (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Identificador único
    pan VARCHAR(16) NOT NULL,                  -- Número de tarjeta (PAN)
    cuenta VARCHAR(20) NOT NULL,               -- Número de cuenta
    estado CHAR(3) NOT NULL,                   -- Estado (020 o 021)
    fecha_venta DATE NOT NULL,                 -- Fecha de venta
    monto DECIMAL(15, 2) NOT NULL,             -- Monto de la cartera
    descripcion TEXT,                          -- Descripción adicional (opcional)
    CHECK (estado IN ('020', '021'))           -- Restricción para el campo estado
);


CREATE TABLE `emi_t_debito_pendientes` (
  `db_id` bigint NOT NULL AUTO_INCREMENT,
  `db_pan` varchar(255) ,
  `db_cuenta` varchar(255),
  `db_identcli` varchar(255),
  `db_numdoc` varchar(255),
  `db_status` varchar(255),
  `db_ctargo1` varchar(30) DEFAULT NULL,  
  `db_clamon1` int DEFAULT NULL,  
  `db_ctargo2` varchar(30) DEFAULT NULL,  
  `db_clamon2` int DEFAULT NULL,  
  `db_pago_min` double , 
  `db_pago_contado` double, 
  `db_d_fec_top_pag` datetime(6) , 
  `db_cu_forpago` int , 
  `db_fecext` date, 
  `db_impmin` double , 
  `db_ic_impago` double ,
  `db_ic_numrecimp` double ,
  `db_dr_fecvenmov` date,
  `db_tip_deb` varchar(225) ,
  `db_processdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `db_estado_actual` ENUM('pendiente', 'procesado', 'error', 'reintento') DEFAULT 'pendiente',
  `db_batch_id` varchar(36) NOT NULL,
   PRIMARY KEY (`db_id`),
   CONSTRAINT `fk_batch` 
	FOREIGN KEY (`db_batch_id`)  
    REFERENCES `batch_procesos`(`batch_id`)  
    ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE batch_procesos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id VARCHAR(36) NOT NULL UNIQUE,  -- UUID único para identificar cada batch
    estado ENUM('EN PROCESO', 'COMPLETADO', 'FALLIDO') NOT NULL DEFAULT 'EN PROCESO',
    fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Inicio del procesamiento
    fecha_fin DATETIME NULL,  -- Se llena cuando el batch se completa o falla
    total_registros INT DEFAULT 0,  -- Cantidad de registros en el batch
    registros_procesados INT DEFAULT 0,  -- Registros efectivamente procesados
    registros_fallidos INT DEFAULT 0,  -- Registros con error
    mensaje_error TEXT NULL  -- En caso de fallos, se guarda el error
);


CREATE TABLE emi_tc_m_parametro (
    pa_id INT PRIMARY KEY,
    pa_parent VARCHAR(50),
    pa_nombre VARCHAR(50),
    pa_valor TEXT,
    pa_descripcion TEXT,
    pa_fecha_creacion DATETIME,
    pa_fecha_actualizacion DATETIME,
    pa_estado CHAR(1)
);


  CREATE TABLE venta_cartera_castigada (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Identificador único
    pan VARCHAR(16) NOT NULL,                  -- Número de tarjeta (PAN)
    cuenta VARCHAR(20) NOT NULL,               -- Número de cuenta
    estado CHAR(3) NOT NULL,                   -- Estado (020 o 021)
    fecha_venta DATE NOT NULL,                 -- Fecha de venta
    monto DECIMAL(15, 2) NOT NULL,             -- Monto de la cartera
    descripcion TEXT,                          -- Descripción adicional (opcional)
    CHECK (estado IN ('020', '021'))           -- Restricción para el campo estado
);



CREATE TABLE ods_estado_cuenta_tarjeta (
    i_id_estado INT PRIMARY KEY,
    s_cod_estado VARCHAR(50),
    s_estado VARCHAR(100),
    s_cod_sub_estado VARCHAR(50),
    s_sub_estado VARCHAR(100),
    s_descripcion TEXT,
    i_id_estado_aux INT,
    s_pan VARCHAR(12),
    s_cod_es VARCHAR(16)
);

