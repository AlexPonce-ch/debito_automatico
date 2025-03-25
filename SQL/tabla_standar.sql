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


CREATE TABLE emi_t_debito_diario (
  dd_id BIGINT NOT NULL AUTO_INCREMENT,
  dd_pan VARCHAR(22) COLLATE utf8mb4_general_ci NOT NULL,
  dd_cuenta VARCHAR(30) COLLATE utf8mb4_general_ci NOT NULL,
  dd_identcli VARCHAR(25) COLLATE utf8mb4_general_ci NOT NULL,
  dd_numdoc VARCHAR(25) COLLATE utf8mb4_general_ci NOT NULL,
  dd_status VARCHAR(20) COLLATE utf8mb4_general_ci NOT NULL,
  dd_pago_min DECIMAL(17,2) NOT NULL DEFAULT 0.00,
  dd_pago_contado DECIMAL(17,2) NOT NULL DEFAULT 0.00,
  dd_fec_top_pag DATE NOT NULL,
  dd_cu_forpago INT NOT NULL,
  dd_fecext DATE NOT NULL,
  dd_impmin DECIMAL(17,2) NOT NULL DEFAULT 0.00,
  dd_ic_impago DECIMAL(17,2) NOT NULL DEFAULT 0.00,
  dd_ic_numrecimp DECIMAL(17,2) NOT NULL DEFAULT 0.00,
  dd_fecvenmov DATE NOT NULL,
  dd_tip_deb VARCHAR(50) COLLATE utf8mb4_general_ci NOT NULL,
  dd_processdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dd_estado_actual VARCHAR(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendiente',
  dd_batch_id VARCHAR(36) COLLATE utf8mb4_general_ci NOT NULL,
  CONSTRAINT pk_emi_t_debito_diario PRIMARY KEY (dd_id),
  CONSTRAINT fk_debito_diario_batch FOREIGN KEY (dd_batch_id)
    REFERENCES emi_t_batch_proceso (bp_batch_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;