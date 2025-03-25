CREATE TABLE `emi_t_debito_diario` (
  `db_id` BIGINT NOT NULL AUTO_INCREMENT,
  `db_pan` VARCHAR(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_cuenta` VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_identcli` VARCHAR(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_numdoc` VARCHAR(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_status` VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_pago_min` DECIMAL(17,2) NOT NULL,
  `db_pago_contado` DECIMAL(17,2) NOT NULL,
  `db_d_fec_top_pag` DATE NOT NULL, 
  `db_cu_forpago` INT NOT NULL, 
  `db_fecext` DATE NOT NULL, 
  `db_impmin` DECIMAL(17,2) NOT NULL, 
  `db_ic_impago` DECIMAL(17,2) NOT NULL,
  `db_ic_numrecimp` DECIMAL(17,2) NOT NULL,
  `db_dr_fecvenmov` DATE NOT NULL,
  `db_tip_deb` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_processdate` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `db_estado_actual` VARCHAR(20) DEFAULT 'pendiente',
  `db_batch_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`db_id`),
  CONSTRAINT `fk_batch` 
    FOREIGN KEY (`db_batch_id`)  
    REFERENCES `emi_t_dba_batch`(`batch_id`)  
    ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


