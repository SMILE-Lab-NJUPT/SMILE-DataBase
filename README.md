# SmileDB 数据库项目

本项目隶属于```Smile团队```的```基于open Harmony的智能家居系统```

本项目实现了一套面向智能设备系统的数据库方案，包含用户、设备、传感数据、权限及日志等各类表结构。项目设计注重数据安全、性能优化、分区存储及审计功能，同时支持自动备份和 Docker 部署。

## 目录结构

```
SmartDeviceDB/
├── README.md
├── Makefile
├── docker
│   └── Dockerfile
├── docs
│   └── design_documentation.md
├── scripts
│   ├── backup.sh
│   └── deploy.sh
├── sql
│   ├── schema.sql
│   ├── seed_data.sql
│   └── triggers.sql
├── src
│   ├── main.py
│   └── db_config.py
└── tests
    └── test_db.py

```

## 环境要求

- PostgreSQL 12 及以上版本
- Python 3.8+（需要安装 `psycopg2` 库）
- Docker（选做，快速搭建环境）
- GNU Make

## 快速开始

### 1. 数据库部署（使用 Makefile）

1. 配置环境变量（例如在 shell 中设置）：
   ```bash
   export DB_USER=smartuser
   export DB_NAME=smartdb
   export DB_PASSWORD=smartpass
    ```

2. 初始化数据库及创建表结构、触发器：
    
    ```bash
    make setup
    ```
    
3. 加载种子数据：
    
    ```bash
    make seed
    ```
    

### 2. 使用 Docker 快速搭建

在 `docker/` 目录下的 `Dockerfile` 基于官方 PostgreSQL 镜像构建数据库实例，可通过以下命令构建镜像：

```bash
make docker
docker run -d --name smartdb -p 5432:5432 smartdevicedb
```

### 3. 运行示例应用

进入 `src/` 目录运行 `main.py`：

```bash
python src/main.py
```

### 4. 执行单元测试

确保已安装 pytest，执行：

```bash
make test
```

### 5. 数据库备份与部署

* 备份数据库：
    
    ```bash
    make backup
    ```
    
* 部署（重复执行建表、触发器和种子数据加载）：
    
    ```bash
    make deploy
    ```
    

## 其它说明

* 数据表均支持索引与分区，传感数据表（sensor_data）采用按时间分区策略，便于管理大数据量历史数据。
    
* 日志表和触发器用于安全审计，防范非法数据修改。
    
* 项目提供自动化构建脚本与 Docker 支持，便于持续集成与快速部署。
    

更多详细设计请查看 docs/design_documentation.md。
