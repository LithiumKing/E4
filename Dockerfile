FROM python:latest

RUN apt-get update && apt-get install -y nginx postgresql postgresql-contrib

RUN pip install Django gunicorn psycopg2-binary

# копируем конфиг nginx
COPY nginx.conf /etc/nginx/sites-available/default

# копируем файлы проекта
COPY . /app

WORKDIR /app

# создаем базу данных
RUN service postgresql start \
  && su - postgres -c "psql -c \"CREATE USER myuser WITH PASSWORD 'mypassword';\"" \
  && su - postgres -c "createdb -O myuser mydb"

# запускаем сервер
CMD service nginx start && gunicorn myproject.wsgi:application --bind=0.0.0.0:8000