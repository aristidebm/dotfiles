.PHONY: format shell dbshell migrate migration show-urls show-migrations messages compile check install install-dev

DATABASE_URL := $(or $(DATABASE_URL), "postgresql://postgres:postgres@172.18.0.2:5432/postgres")

install:
	@uv pip install -U -r requirements.txt

install-dev: install
	@uv pip install -U -r requirements.dev.txt

format:
	@black .

shell:
	@python manage.py shell_plus

dbshell:
	@pgcli ${DATABASE_URL}

migrate:
	@python manage.py migrate

migration:
	@python manage.py makemigrations

show-urls:
	@python manage.py show_urls

show-migrations:
	@python manage.py showmigrations

messages:
	@python manage.py makemessages --all --ignore="venv*"

compile:
	@python manage.py compilemessages
