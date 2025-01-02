-- Create table for VIP vehicles
CREATE TABLE IF NOT EXISTS `vehicles2` (
    `name` VARCHAR(60) NOT NULL,
    `model` VARCHAR(60) NOT NULL,
    `price` INT NOT NULL,
    `category` VARCHAR(60) DEFAULT NULL,
    PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert VIP vehicles
INSERT INTO `vehicles2` (`name`, `model`, `price`, `category`) VALUES
    ('Tanque', 'abrams', 50, 'tanques'),
    ('Tanque2', 'abrams2', 50, 'tanques'),
    ('AH-64', 'ah64d', 80, 'helicopteros'),
    ('ares', 'ares', 10, 'no blindados'),
    ('Barracks', 'Barracks', 2, 'no blindados'),
    ('barrage', 'Barrage', 20, 'blindados'),
    ('minitanque', 'brad', 25, 'tanques'),
    ('minitanque2', 'brad2', 25, 'tanques'),
    ('hmmer', 'bspec', 5, 'blindados'),
    ('buzzard', 'buzzard', 30, 'helicopteros'),
    ('buzzard2', 'buzzard2', 20, 'helicopteros'),
    ('cargobob', 'cargobob', 40, 'helicopteros'),
    ('f15', 'f15s', 50, 'aviones'),
    ('f16', 'f16liaf', 50, 'aviones'),
    ('f22', 'f22a', 60, 'aviones'),
    ('H4R', 'H4REntityMTR', 15, 'no blindados'),
    ('H4Rx', 'H4RxST2', 10, 'no blindados'),
    ('hmmer con misiles', 'hasrad', 15, 'blindados'),
    ('havok', 'havok', 10, 'helicopteros'),
    ('Camion2', 'hmvs', 2, 'no blindados'),
    ('hunter', 'hunter', 50, 'helicopteros'),
    ('hycrh', 'hycrh7', 5, 'no blindados'),
    ('f35', 'hydra', 80, 'aviones'),
    ('Khanjali', 'Khanjali', 100, 'tanques'),
    ('tanquemedio', 'lav25ifv', 25, 'tanques'),
    ('lazer', 'lazer', 50, 'aviones'),
    ('tanque3', 'm1128s', 40, 'tanques'),
    ('antiareos', 'm142as', 15, 'tanques'),
    ('Camion4', 'm977hl', 2, 'no blindados'),
    ('Camion', 'man', 2, 'no blindados'),
    ('antiminas', 'mrap', 15, 'blindados'),
    ('hmmer con misiles2', 'msquaddie', 15, 'blindados'),
    ('Camion5', 'mtfft', 2, 'no blindados'),
    ('heli de transporte', 'nh90', 30, 'helicopteros'),
    ('policecar1', 'police2', 8, 'no blindados'),
    ('polvigeros', 'polvigerospeed', 5, 'no blindados'),
    ('rafalec', 'rafalec', 50, 'aviones'),
    ('rt3000', 'rt3000wb', 5, 'no blindados'),
    ('sherman', 'sherman', 30, 'tanques'),
    ('tiger', 'tiger', 25, 'tanques'),
    ('typhoon', 'typhoon', 50, 'aviones'),
    ('hmmer2', 'unarmed1', 5, 'blindados'),
    ('hmmer3', 'unarmed2', 5, 'blindados'),
    ('hmmer con torreta', 'uparmor', 10, 'blindados'),
    ('hmmer con torreta2', 'uparmorw', 10, 'blindados'),
    ('valkyrie', 'valkyrie', 40, 'helicopteros'),
    ('vigerozx', 'vigerozxwb', 8, 'no blindados');

-- Create table for vehicle categories if not exists
CREATE TABLE IF NOT EXISTS `vehicle_categories2` (
    `name` VARCHAR(60) NOT NULL,
    `label` VARCHAR(60) NOT NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert vehicle categories
INSERT INTO `vehicle_categories2` (`name`, `label`) VALUES
    ('aviones', 'Aviones'),
    ('blindados', 'Blindados'),
    ('emergencias', 'Emergencias'),
    ('helicopteros', 'Helicopteros'),
    ('no blindados', 'No blindados'),
    ('tanques', 'Tanques');