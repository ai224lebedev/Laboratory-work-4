-- Видалення існуючих таблиць для уникнення конфліктів
DROP TABLE IF EXISTS financial_impact CASCADE;
DROP TABLE IF EXISTS financial_data CASCADE;
DROP TABLE IF EXISTS recommendation CASCADE;
DROP TABLE IF EXISTS noise_level CASCADE;
DROP TABLE IF EXISTS sensor CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;

-- Таблиця sensor
CREATE TABLE sensor (
    sensor_id SERIAL PRIMARY KEY,
    sensor_type VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- Таблиця noise_level
CREATE TABLE noise_level (
    noise_level_id SERIAL PRIMARY KEY,
    value FLOAT CHECK (value >= 0 AND value <= 120),
    unit VARCHAR(10) DEFAULT 'дБ' CHECK (unit = 'дБ'),
    sensor_id INT NOT NULL REFERENCES sensor (sensor_id),
    user_id INT NOT NULL
);

-- Таблиця "user"
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Таблиця recommendation
CREATE TABLE recommendation (
    recommendation_id SERIAL PRIMARY KEY,
    description VARCHAR(500),
    created_at DATE NOT NULL,
    user_id INT NOT NULL REFERENCES "user" (user_id)
);

-- Таблиця financial_data
CREATE TABLE financial_data (
    financial_data_id SERIAL PRIMARY KEY,
    indicator VARCHAR(100) NOT NULL,
    value FLOAT CHECK (value > 0),
    period VARCHAR(7) NOT NULL CHECK (period ~ '^\d{4}-\d{2}$'),
    noise_level_id INT REFERENCES noise_level (noise_level_id)
);

-- Таблиця financial_impact
CREATE TABLE financial_impact (
    impact_id SERIAL PRIMARY KEY,
    impact_description VARCHAR(500),
    report_date DATE NOT NULL,
    financial_data_id INT REFERENCES financial_data (financial_data_id),
    user_id INT REFERENCES "user" (user_id)
);

-- Додаткові обмеження для noise_level.user_id
ALTER TABLE noise_level ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES "user" (user_id);

-- Регулярні вирази для атрибутів
ALTER TABLE "user" ADD CONSTRAINT chk_role CHECK (role ~ '^[A-Za-z]+$');
ALTER TABLE sensor ADD CONSTRAINT chk_location
CHECK (location ~ '^[A-Za-z0-9\s,]+$');

-- Перевірка результатів
SELECT 'schema successfully created.' AS status;
