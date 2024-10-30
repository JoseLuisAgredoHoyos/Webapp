Proyecto Web con Docker Compose
Este proyecto utiliza Docker Compose para facilitar la configuración, administración y despliegue de una aplicación web completa. La aplicación está diseñada para funcionar en un entorno con tres contenedores:

Un contenedor para la aplicación web .
Un contenedor para la base de datos .
Un contenedor para un proxy inverso que enruta el tráfico hacia la aplicación web.
¿Qué es Docker Compose?
Docker Compose es una herramienta que permite definir y ejecutar aplicaciones multicontenedor. Con Docker Compose, puedes configurar y conectar fácilmente varios servicios en contenedores mediante un solo archivo ( docker-compose.yml). Esto permite que todas las partes de una aplicación, como el servidor web, la base de datos y el proxy, se gestionen y ejecuten de manera coordinada.

Arquitectura de contenedores
En este proyecto, Docker Compose orquesta los contenedores para la aplicación web, la base de datos y el proxy. Cada uno de estos contenedores tiene su propio propósito y configuración:

1. Contenedor de la Aplicación Web
Este contenedor ejecuta el código de la aplicación web. Podría ser una aplicación en Flask , Node.js , Django o cualquier otro framework web.

Propósito : Servir la lógica de la aplicación y manejar las solicitudes HTTP.
Puerto : Normalmente el puerto 8080 dentro del contenedor, mapeado al puerto correspondiente en el host.
Dependencias : Este servicio puede depender de la base de datos para almacenar y recuperar información.
2. Contenedor de la Base de Datos
El contenedor de la base de datos proporciona almacenamiento para la aplicación web. En este ejemplo, usamos una base de datos PostgreSQL .

Propósito : Almacenar y gestionar los datos necesarios para la aplicación web.
Volúmenes : Se utiliza un volumen para mantener la persistencia de datos incluso después de que el contenedor haya sido detenido o eliminado.
Configuración : Variables de entorno para configurar el nombre de la base de datos, el usuario y la contraseña.
3. Contenedor de proxy inverso
El contenedor de proxy inverso, configurado con Nginx , recibe las solicitudes externas y las ingresa al contenedor de la aplicación web.

Propósito : Manejar el tráfico y distribuir las solicitudes hacia la aplicación web.
Configuración : Incluye reglas de proxy, como el reenvío de encabezados y la gestión de conexiones HTTPS.

Archivodocker-compose.yml
Aquí tienes un ejemplo de configuración del archivo docker-compose.ymlpara esta arquitectura:

version: '3.8'

services:
  webapp:
    build: ./app  # Dockerfile de la aplicación web
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://user:password@database/dbname
    depends_on:
      - database

  database:
    image: postgres:13  # Imagen de PostgreSQL
    environment:
      POSTGRES_DB: dbname
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - pgdata:/var/lib/postgresql/data

  proxy:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./proxy/nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - webapp

volumes:
  pgdata:

webapp : Construye la imagen de la aplicación web y exponen el puerto 8080.
base de datos : Usa la imagen de PostgreSQL y crea un volumen para la persistencia de datos.
proxy : Usa la imagen de Nginx y se configura como proxy inverso en el puerto 80.

Configuración del proxy (Nginx)
Para el contenedor de proxy inverso, cree un archivo de configuración de Nginx nginx.confen el directorio proxycon el siguiente contenido:

user nginx;
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    upstream webapp {
        server webapp:8080;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://webapp;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}

Este archivo configura el proxy para redirigir el tráfico desde el puerto 80 hacia el contenedor webappen el puerto 8080.

1-Construye y ejecuta los contenedores:

docker-compose up --build

2-Acceda a la aplicación web en http://localhost(manejado por el proxy en Nginx).

3-Para detener y eliminar los contenedores, volúmenes y redes creados por Docker Compose:

docker-compose down -v

Conclusión

Este proyecto demuestra cómo usar Docker Compose para organizar y gestionar múltiples contenedores en una aplicación web. Docker Compose permite encapsular cada servicio de la aplicación, simplificando el despliegue y la escalabilidad del sistema.