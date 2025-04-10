import pytest
import psycopg2
from psycopg2 import sql
from src.db_config import DB_CONFIG

@pytest.fixture(scope="module")
def db_connection():
    conn = psycopg2.connect(
        host=DB_CONFIG["host"],
        database=DB_CONFIG["database"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        port=DB_CONFIG["port"]
    )
    yield conn
    conn.close()

def test_users_table_exists(db_connection):
    with db_connection.cursor() as cur:
        cur.execute(sql.SQL("SELECT to_regclass('public.users');"))
        result = cur.fetchone()
        assert result[0] is not None, "users 表不存在"

def test_devices_table_exists(db_connection):
    with db_connection.cursor() as cur:
        cur.execute(sql.SQL("SELECT to_regclass('public.devices');"))
        result = cur.fetchone()
        assert result[0] is not None, "devices 表不存在"

def test_sensor_data_index(db_connection):
    # 验证组合索引是否存在
    with db_connection.cursor() as cur:
        cur.execute("""
            SELECT indexname 
            FROM pg_indexes 
            WHERE tablename = 'sensor_data' AND indexdef ILIKE '%device_id, timestamp%';
        """)
        result = cur.fetchone()
        assert result is not None, "sensor_data 表组合索引不存在"
