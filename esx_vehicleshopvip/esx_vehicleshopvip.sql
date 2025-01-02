-- Create table for storing VIP coins for each player
CREATE TABLE `vip_coins` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `player_id` VARCHAR(60) NOT NULL UNIQUE,
    `coins` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create table for storing VIP vehicles
CREATE TABLE `vip_vehicles` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL,
    `model` VARCHAR(60) NOT NULL,
    `price` INT NOT NULL,
    `category` VARCHAR(60) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert initial data into vip_vehicles table
INSERT INTO `vip_vehicles` (name, model, price, category) VALUES
    ('VIP Supercar', 'vip_supercar', 1000, 'super'),
    ('VIP Sports Car', 'vip_sportscar', 750, 'sports'),
    ('VIP Luxury Sedan', 'vip_luxurysedan', 500, 'sedans'),
    ('VIP Offroad', 'vip_offroad', 600, 'offroad'),
    ('VIP Motorcycle', 'vip_motorcycle', 300, 'motorcycles');
