-- 建立 Users 表
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    face_feature BYTEA,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 建立 Devices 表
CREATE TABLE IF NOT EXISTS devices (
    device_id SERIAL PRIMARY KEY,
    device_name VARCHAR(255) NOT NULL,
    device_type VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    status VARCHAR(50),
    last_active_time TIMESTAMP DEFAULT NOW(),
    esp_mac VARCHAR(17),
    ip_address INET
);

-- 建立 SensorData 表（采用 PostgreSQL 分区：按照 timestamp 划分分区）
CREATE TABLE IF NOT EXISTS sensor_data (
    record_id SERIAL PRIMARY KEY,
    device_id INTEGER NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    data_type VARCHAR(50) NOT NULL,
    value NUMERIC NOT NULL,
    CONSTRAINT fk_device
        FOREIGN KEY(device_id) 
	    REFERENCES devices(device_id)
	    ON DELETE CASCADE
) PARTITION BY RANGE (timestamp);

-- 示例：创建 2023 年 1 月的分区（可依此创建后续分区）
CREATE TABLE IF NOT EXISTS sensor_data_2023_01 PARTITION OF sensor_data
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

-- 为 device_id 与 timestamp 建立组合索引
CREATE INDEX IF NOT EXISTS idx_sensor_data_device_time ON sensor_data (device_id, timestamp);

-- 建立 Permissions 表
CREATE TABLE IF NOT EXISTS permissions (
    perm_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    device_id INTEGER,
    perm_level VARCHAR(50) NOT NULL,
    valid_time_range TSRANGE,
    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
	    REFERENCES users(user_id)
	    ON DELETE CASCADE,
    CONSTRAINT fk_device_perm
        FOREIGN KEY(device_id)
	    REFERENCES devices(device_id)
	    ON DELETE CASCADE
);

-- 建立 Logs 表
CREATE TABLE IF NOT EXISTS logs (
    log_id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    user_id INTEGER,
    device_id INTEGER,
    action VARCHAR(255),
    details TEXT,
    CONSTRAINT fk_user_log
        FOREIGN KEY(user_id)
	    REFERENCES users(user_id)
	    ON DELETE SET NULL,
    CONSTRAINT fk_device_log
        FOREIGN KEY(device_id)
	    REFERENCES devices(device_id)
	    ON DELETE SET NULL
);
