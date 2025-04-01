CREATE TABLE emi_t_batch_proceso (
  bp_id INT NOT NULL AUTO_INCREMENT,
  bp_batch_id VARCHAR(36) COLLATE utf8mb4_general_ci NOT NULL,
  bp_estado VARCHAR(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'EN PROCESO',
  bp_fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  bp_fecha_fin DATETIME DEFAULT NULL,
  bp_total_registros INT DEFAULT 0,
  bp_registros_procesados INT DEFAULT 0,
  bp_registros_fallidos INT DEFAULT 0,
  bp_mensaje_error TEXT COLLATE utf8mb4_general_ci,
  CONSTRAINT pk_emi_t_batch_proceso PRIMARY KEY (bp_id),
  CONSTRAINT uq_emi_t_batch_id UNIQUE (bp_batch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
-- nueva tabla final 

CREATE TABLE emi_t_mdp_debito_pendiente(
  dp_id BIGINT NOT NULL AUTO_INCREMENT,
  dp_pan VARCHAR(22) COLLATE utf8mb4_general_ci NOT NULL,
  dp_cuenta VARCHAR(30) COLLATE utf8mb4_general_ci NOT NULL,
  dp_identcli VARCHAR(8) COLLATE utf8mb4_general_ci NOT NULL,
  dp_pago_min DECIMAL(17,2) NOT NULL,
  dp_pago_contado DECIMAL(17,2) NOT NULL,
  dp_cu_forpago INT DEFAULT NULL,
  dp_m_deuda_vcda DECIMAL(17,2) NOT NULL,
  dp_ic_numrecimp DECIMAL(17,2) NOT NULL,
  dp_fec_top_pag DATE NOT NULL,
  dp_fecext DATE NOT NULL,
  dp_dr_fecvenmov DATE NOT NULL,
  dp_s_cod_es VARCHAR(15) NOT NULL,
  dp_estado_c VARCHAR (10) NOT NULL,
  dp_impfac_total DECIMAL(17,2) NOT NULL,
  dp_total_debitar DECIMAL(17,2) NOT NULL,
  dp_apelli1 VARCHAR(36) NOT NULL,
  dp_apelli2 VARCHAR(36) NOT NULL,
  dp_nombre VARCHAR(40) NOT NULL,
  dp_tip_deb CHAR(4) NOT NULL,
  dp_est_proce VARCHAR(10) NOT NULL,
  dp_processdate INT NOT NULL 
  dp_batch_id VARCHAR(36) COLLATE utf8mb4_general_ci NOT NULL,
  CONSTRAINT pk_emi_t_mdp_debito_pendiente PRIMARY KEY (dp_id),
  CONSTRAINT fk_debito_diario_batch FOREIGN KEY (dp_batch_id)
    REFERENCES emi_t_batch_proceso (bp_batch_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;