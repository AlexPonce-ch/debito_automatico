CREATE TABLE `emi_t_debito_diario` (
  `db_id` BIGINT NOT NULL AUTO_INCREMENT,
  `db_pan` VARCHAR(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_cuenta` VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_identcli` VARCHAR(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_numdoc` VARCHAR(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_status` VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `db_ctacargo1` VARCHAR(30) NOT NULL,  
  `db_clamon1` INT NOT NULL,  
  `db_ctacargo2` VARCHAR(30) NOT NULL,  
  `db_clamon2` INT NOT NULL,  
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
    REFERENCES `emi_t_dba_bacth `(`batch_id`)  
    ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `emi_t_dba_batch` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `batch_id` VARCHAR(36) NOT NULL UNIQUE,  -- UUID único para identificar cada batch
    `estado` VARCHAR(20) NOT NULL DEFAULT 'EN PROCESO',
    `fecha_inicio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Inicio del procesamiento
    `fecha_fin` DATETIME NULL,  -- Se llena cuando el batch se completa o falla
    `total_registros` INT DEFAULT 0,  -- Cantidad de registros en el batch
    `registros_procesados` INT DEFAULT 0,  -- Registros efectivamente procesados
    `registros_fallidos` INT DEFAULT 0,  -- Registros con error
    `mensaje_error` TEXT NULL  -- En caso de fallos, se guarda el error
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
