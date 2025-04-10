
```makefile
.PHONY: setup seed backup deploy test docker

# 使用环境变量：DB_USER, DB_NAME, DB_PASSWORD 必须预先设置

DB_CONN = psql -U $(DB_USER) -d $(DB_NAME)

setup:
	@echo "Setting up database schema and triggers..."
	$(DB_CONN) -f sql/schema.sql
	$(DB_CONN) -f sql/triggers.sql

seed:
	@echo "Loading seed data..."
	$(DB_CONN) -f sql/seed_data.sql

backup:
	@echo "Performing database backup..."
	./scripts/backup.sh

deploy:
	@echo "Deploying database schema, triggers and seed data..."
	./scripts/deploy.sh

test:
	@echo "Running database tests..."
	pytest tests/

docker:
	@echo "Building Docker image..."
	docker build -t smartdevicedb docker/
