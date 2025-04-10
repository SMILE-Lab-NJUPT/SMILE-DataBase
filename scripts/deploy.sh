#!/bin/bash
# 部署数据库（建表、触发器、种子数据加载）
# 要求已设置 DB_USER 与 DB_NAME 环境变量

echo "部署数据库架构..."
psql -U "$DB_USER" -d "$DB_NAME" -f sql/schema.sql

echo "部署触发器..."
psql -U "$DB_USER" -d "$DB_NAME" -f sql/triggers.sql

echo "加载种子数据..."
psql -U "$DB_USER" -d "$DB_NAME" -f sql/seed_data.sql

echo "数据库部署完成。"
