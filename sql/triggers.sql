-- 示例触发器：当用户表发生更新时，记录日志到 logs 表

CREATE OR REPLACE FUNCTION log_user_update()
RETURNS trigger AS $$
BEGIN
    INSERT INTO logs (timestamp, user_id, action, details)
    VALUES (NOW(), NEW.user_id, 'UPDATE', 'User record updated from username: ' || OLD.username || ' to ' || NEW.username);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_user_update ON users;

CREATE TRIGGER trg_user_update
AFTER UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION log_user_update();
