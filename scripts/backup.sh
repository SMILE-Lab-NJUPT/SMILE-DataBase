#!/bin/bash
# 备份 PostgreSQL 数据库示例脚本
# 要求已设置 DB_USER 和 DB_NAME 环境变量

BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"

echo "正在备份数据库 $(echo $DB_NAME) 到文件 $BACKUP_FILE ..."
pg_dump -U "$DB_USER" -d "$DB_NAME" -F c -f "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "备份成功！"
else
    echo "备份失败！" >&2
fi
