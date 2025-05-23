# 数据库设计文档

## 1. 系统概要

本数据库项目用于智能设备管理系统，主要功能包括用户管理、设备清单、传感数据存储、权限控制和日志记录。重点在于性能优化、安全存储和高可扩展性设计。

## 2. 数据库表设计

### 2.1 用户表（users）

- **字段**：user_id（主键，自增）、username（唯一）、password_hash、role、face_feature（二进制存储人脸特征）、created_at
- **安全要求**：密码使用 BCrypt 哈希存储，敏感数据可采用加密或分表隔离

### 2.2 设备表（devices）

- **字段**：device_id（主键）、device_name、device_type、location、status、last_active_time、esp_mac、ip_address
- **说明**：管理智能设备的基本信息及状态监控

### 2.3 传感数据表（sensor_data）

- **字段**：record_id（主键）、device_id（外键）、timestamp、data_type、value
- **优化**：建立(device_id, timestamp)组合索引，采用按时间范围分区存储，便于查询近期数据及归档历史数据

### 2.4 权限管理表（permissions）

- **字段**：perm_id（主键）、user_id（外键）、device_id（外键，可为空）、perm_level、valid_time_range
- **说明**：细粒度控制用户对设备和功能的访问权限

### 2.5 日志表（logs）

- **字段**：log_id（主键）、timestamp、user_id（可为空）、device_id（外键，可为空）、action、details
- **用途**：安全审计、异常排查、历史事件记录

## 3. 分区与索引策略

- 传感数据表按照 timestamp 划分不同分区（例如按月分区），便于大数据量表的查询和清理。
- 创建复合索引：(device_id, timestamp) 以快速响应设备及时间维度查询。

## 4. 触发器设计

- 为用户表设置审计触发器，记录用户数据变更到日志表中。
- 可扩展其他表的触发器（如设备状态变更、权限修改等），确保系统具有可追溯的修改历史。

## 5. 数据安全

- 使用账号密码及 IP 白名单进行访问限制。
- 敏感信息（密码、token、人脸特征）进行加密存储。
- 部署审计触发器与定期备份策略，保障数据完整性和恢复能力。

## 6. 历史数据存储策略

- 近期详细数据保存在主库，历史数据按聚合方式归档到冷存储或时序数据库中。
- 提供归档脚本及接口供前端查询数据趋势。

## 7. 性能优化

- 读写分离：实时写入主库，同时数据异步同步到云端主库。
- 高并发查询时使用只读从库和 Redis 缓存最近数据。
- 设备状态如心跳信息采用内存或轻量级 KV 暂存，定时批量写入数据库，减轻数据库压力。
