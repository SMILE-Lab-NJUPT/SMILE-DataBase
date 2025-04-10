# 基于官方 PostgreSQL 镜像构建
FROM postgres:13

ENV POSTGRES_USER=smartuser
ENV POSTGRES_PASSWORD=smartpass
ENV POSTGRES_DB=smartdb

# 初始化数据库时执行 SQL 脚本（按字母顺序执行）
COPY sql/schema.sql /docker-entrypoint-initdb.d/
COPY sql/triggers.sql /docker-entrypoint-initdb.d/
COPY sql/seed_data.sql /docker-entrypoint-initdb.d/

# 可在此添加额外配置或初始化脚本
