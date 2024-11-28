-- Видалення існуючих таблиць для уникнення конфліктів
DROP TABLE IF EXISTS FinancialImpact CASCADE;
DROP TABLE IF EXISTS FinancialData CASCADE;
DROP TABLE IF EXISTS Recommendation CASCADE;
DROP TABLE IF EXISTS NoiseLevel CASCADE;
DROP TABLE IF EXISTS Sensor CASCADE;
DROP TABLE IF EXISTS User CASCADE;

-- Таблиця Sensor
CREATE TABLE Sensor (
    sensorId SERIAL PRIMARY KEY,
    sensorType VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- Таблиця NoiseLevel
CREATE TABLE NoiseLevel (
    noiseLevelId SERIAL PRIMARY KEY,
    value FLOAT CHECK (value >= 0 AND value <= 120),
    unit VARCHAR(10) DEFAULT 'дБ' CHECK (unit = 'дБ'),
    sensorId INT NOT NULL REFERENCES Sensor(sensorId),
    userId INT NOT NULL
);

-- Таблиця User
CREATE TABLE User (
    userId SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Таблиця Recommendation
CREATE TABLE Recommendation (
    recommendationId SERIAL PRIMARY KEY,
    description VARCHAR(500),
    createdAt DATE NOT NULL,
    userId INT NOT NULL REFERENCES User(userId)
);

-- Таблиця FinancialData
CREATE TABLE FinancialData (
    financialDataId SERIAL PRIMARY KEY,
    indicator VARCHAR(100) NOT NULL,
    value FLOAT CHECK (value > 0),
    period VARCHAR(7) NOT NULL CHECK (period ~ '^\d{4}-\d{2}$'),
    noiseLevelId INT REFERENCES NoiseLevel(noiseLevelId)
);

-- Таблиця FinancialImpact
CREATE TABLE FinancialImpact (
    impactId SERIAL PRIMARY KEY,
    impactDescription VARCHAR(500),
    reportDate DATE NOT NULL,
    financialDataId INT REFERENCES FinancialData(financialDataId),
    userId INT REFERENCES User(userId)
);

-- Додаткові обмеження для NoiseLevel.userId
ALTER TABLE NoiseLevel ADD CONSTRAINT fk_userId FOREIGN KEY (userId) REFERENCES User(userId);

-- Регулярні вирази для атрибутів
ALTER TABLE User ADD CONSTRAINT chk_role CHECK (role ~ '^[A-Za-z]+$');
ALTER TABLE Sensor ADD CONSTRAINT chk_location CHECK (location ~ '^[A-Za-z0-9\s,]+$');
