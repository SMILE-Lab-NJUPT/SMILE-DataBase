-- 插入种子用户数据（密码均为示例散列值）
INSERT INTO users (username, password_hash, role) VALUES 
('alice', '$2b$12$EXAMPLE_HASH_ALICE', 'ADMIN'),
('bob', '$2b$12$EXAMPLE_HASH_BOB', 'USER');

-- 插入种子设备数据
INSERT INTO devices (device_name, device_type, location, status, esp_mac, ip_address) VALUES
('客厅空调', '空调', '客厅', 'OFF', 'AA:BB:CC:DD:EE:FF', '192.168.1.100'),
('卧室摄像头', '摄像头', '卧室', 'ON', '11:22:33:44:55:66', '192.168.1.101');

-- 插入种子传感数据（建议根据当前日期插入合理的时间）
INSERT INTO sensor_data (device_id, timestamp, data_type, value)
VALUES 
(1, NOW() - INTERVAL '1 hour', 'temperature', 26.5),
(1, NOW() - INTERVAL '50 minutes', 'humidity', 45.0),
(2, NOW() - INTERVAL '30 minutes', 'temperature', 22.0);
  
-- 插入权限数据
INSERT INTO permissions (user_id, device_id, perm_level, valid_time_range)
VALUES
(1, 2, 'CONTROL', '[2023-01-01,2030-01-01)'),
(2, NULL, 'VIEW', NULL);

-- 插入初步日志记录
INSERT INTO logs (user_id, device_id, action, details)
VALUES
(1, 2, 'LOGIN', '管理员 alice 登录系统'),
(NULL, 1, 'DEVICE_STATUS', '设备客厅空调状态更新');
