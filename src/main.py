import psycopg2
from psycopg2.extras import RealDictCursor
from db_config import DB_CONFIG

def get_connection():
    try:
        conn = psycopg2.connect(
            host=DB_CONFIG["host"],
            database=DB_CONFIG["database"],
            user=DB_CONFIG["user"],
            password=DB_CONFIG["password"],
            port=DB_CONFIG["port"]
        )
        return conn
    except Exception as e:
        print("数据库连接失败：", e)
        exit(1)

def fetch_devices():
    conn = get_connection()
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("SELECT * FROM devices;")
        devices = cur.fetchall()
    conn.close()
    return devices

if __name__ == '__main__':
    devices = fetch_devices()
    print("当前设备列表：")
    for device in devices:
        print(f"ID: {device['device_id']}, Name: {device['device_name']}, Status: {device['status']}")
