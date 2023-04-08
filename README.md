# DOCKER
Docker es una herramienta que tiene como objetivo simplificar el proceso de construcción, distribución y despliegue de aplicaciones mediante la utilización de contenedores

# ÍNDICE
- [Bases](#bases)
    - [Imagen 🖼️](#imagen-%EF%B8%8F)
    - [Contenedor ⏹️](#contenedor-%EF%B8%8F)
    - [Volumen 🗂️](#volumen-%EF%B8%8F)
        - [Tipos de volúmenes](#tipos-de-volúmenes)
    - [Network 🌐](#network-%EF%B8%8F)
    - [Logs](#logs)
    - [Termina interactiva](#termina-interactiva)
- [Contenedores múltiples](#contenedores-múltiples)
- [Dockenizar una aplicación](#dockenizar-una-aplicación)
    - [Multi-state build](#multi-state-build)
    - [Docker compose build](#docker-compose-build)
- [Github actions](#github-actions)
- [Nginx](#nginx)


# Bases
## Imagen 🖼️
Archivo construido mediante capas en la cual figuran todas las dependencias, configuraciones, scripts, binarios, etc necesarios para su ejecucíon. Además es el archivo base con el cúal se creará el contenedor.

- Descargar una imagen:
```bash
    $ docker pull <nombre_de_la_imagen>:<tag_de_versión>
    $ docker pull mysql:8.0.29
```

- Listado de imágenes
```bash
    $ docker images
```

- Eliminado de imágenes
```bash
    $ docker image rm <nombre_de_la_imagen>:<tag_de_versión>
    $ docker image rm mysql:8.0.29
    // 
    $ docker rmi <nombre_de_la_imagen>:<tag_de_versión>
    $ docker rmi mysql:8.0.29
```

- Eliminado de todas las imágenes
```bash
    $ docker image prune
    $ docker image prune -a     // todas las imágenes no usadas
```

## Contenedor ⏹️
Instancia de una imagen corriendo en un entorno aislado.

- Crear un contenedor:
```bash
    $ docker container run --detach -publish <puerto_de_la_maquina_host>:<puerto_del_contenedor> --name <nombre_del_contenedor> --volume <nombre_del_volumen> --network <nombre_de_la_network> <nombre_de_la_imagen>:<tag_de_versión>
    $ docker container run -d -p 3306:3306 --name mysql-container --volume mysql-db-volume --network app-network mysql:8.0.29
```

- Listado de contenedores
```bash
    $ docker container ls       // lista de contenedores en ejecución
    $ docker container ls -a    // lista de todos los contenedores
```

- Eliminado de contenedores
```bash
    $ docker container rm <nombre_del_contenedor>
    $ docker container rm mysql-container

    $ docker container rm -f <nombre_del_contenedor>    // forzar borrado si el contenedor esta en ejecución
    $ docker container rm -f mysql-container
```

- Ejecutar o para un contenedor
```bash
    $ docker container start <nombre_del_contenedor>
    $ docker container start mysql-container

    $ docker container stop <nombre_del_contenedor>
    $ docker container stop mysql-container
```

## Volumen 🗂️
Proporcionan la capacidad de conectar rutas específicas del sistema de archivos del contenedor a la máquita host.
Si se montan directorios en el contenedor, los cambios en ese directorio tbn se ven reflejados en la máquina host.

### Tipos de volúmenes
1. NAMED VOLUMES: Se especifica tanto el path del contenedor como de la máquina host.
2. BIND VOLUMES: Trabaja con paths abosolutos.
3. ANONYMOUS VOLUMES: Solo se especifica el path del contenedor y Docker asigna automáticamente en el host.

- Crear un volumen:
```bash
    $ docker volumen create <nombre_del_volumen>
    $ docker volumen create mysql-db-volume
```

- Listado de volúmenes
```bash
    $ docker volumen ls
```

- Eliminado de volúmenes
```bash
    $ docker volumen rm <nombre_del_volumen>
    $ docker volumen rm mysql-db-volume
```

## Nertwork 🌐
Instancia de una imagen corriendo en un entorno aislado.

- Crear una network:
```bash
    $ docker network create <nombre_del_network>
    $ docker network create app-network 
```

- Listado de networks
```bash
    $ docker network ls
```

- Eliminado de network
```bash
    $ docker network rm <nombre_del_network>
    $ docker network rm app-network 
```

- Asignación de network
```bash
    $ docker network connect <nombre_del_network> <id_o_nombre_del_contenedor>
    $ docker network connect <nombre_del_network> <id_o_nombre_del_contenedor>
```
## Logs
Para ver el output del proyecto montado en el contenedor
```bash
    $ docker container logs <nombre_del_contenedor>
    $ docker container logs --folow <nombre_del_contenedor>
```

## Termina interactiva
Acceder a la terminal intreciva del contenedor
```bash
    $ docker  exec -it <nombre_del_contenedor> <ejecutable>
    $ docker  exec -it mysql-container bash
    $ docker  exec -it mysql-container /bin/sh
```

Editar con ```vi```, ver con ```cat```, editar: ```i```, guardar:```:wq!```

# Contenedores múltiples
Uso de Docker Compose permite ejecutar de manera sencilla todas las instrucciones necesarias para poner en marcha los contenedores con todo lo requerido por nuestra aplicación.

```bash
    $ docker compose up
```
```bash
    $ docker compose down
```

## Múltiples servicios
```bash
version: '3.1'

services:
    db:
        container_name: ${MONGO_DB_NAME}
        image: mongo:6.0
        volumes:
            - poke-vol:/data/db
        # ports:
        #   - 27017:27017
        restart: always
        environment:
            MONGO_INITDB_ROOT_USERNAME: ${MONGO_USERNAME}
            MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
        command: ['--auth']

    mongo-express:
        depends_on:
            - db
        image: mongo-express:1.0.0-alpha.4
        environment:
            ME_CONFIG_MONGODB_ADMINUSERNAME: ${MONGO_USERNAME}
            ME_CONFIG_MONGODB_ADMINPASSWORD: ${MONGO_PASSWORD}
            ME_CONFIG_MONGODB_SERVER: ${MONGO_DB_NAME}
        ports:
            - 8080:8081
        restart: always

    poke-app:
        depends_on:
            - db
            - mongo-express
        image: klerith/pokemon-nest-app:1.0.0
        ports:
            - 3000:3000
        environment:
            # MONGODB: mongodb://lercc:123456@pokemonDB:27017
            MONGODB: mongodb://${MONGO_USERNAME}:${MONGO_PASSWORD}@${MONGO_DB_NAME}:27017
            DB_NAME: ${MONGO_DB_NAME}
        restart: always

volumes:
    poke-vol:
        external: false
```

# Dockenizar una aplicación
-   Dockenizar una aplicación: Proceso de tomar un código fuente y generar una imagen lista para montar y correrla en un contenedor.
```bash
$ docker build --tag cron-ticker:1.0.0
```

### Dockerfile
```dockerfile
# BUILDX: CONSTUCCIÓN PARA MULTIPLES PLATAFORMAS https://docs.docker.com/build/building/multi-platform/
# FROM --plataform=linux/amd64 node:19.2-alpine3.16
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16
# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t <username>/<image>:latest --push .
FROM node:19.2-alpine3.16
# /app /usr /lib

# cd app
WORKDIR /app

#    Origen       Destino [/app]
COPY package.json ./

# instalar dependencias
RUN npm install

# copia Origen Destino [/app] ignorando los archivos que estan en el dockerignore 
COPY . .

# realizar testing
RUN npm run test

# borrar las pruebas
RUN rm -rf tests && rm -rf node_modules

# instalar únicamente dependencias de producción
RUN npm install --prod

# comando run de la imagen
CMD ["node", "app.js"]
```

## Multi-state build
```bash
$ docker build --tag cron-ticker:1.0.0
```

### Dockerfile
```dockerfile
# STEP: dependencies
FROM node:19.2-alpine3.16 AS dependencies
WORKDIR /app
COPY package.json ./
RUN npm install

# STEP: builder-test
FROM node:19.2-alpine3.16 AS builder-test
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
RUN npm run test

# STEP: prod-dependencies
FROM node:19.2-alpine3.16 AS prod-dependencies
WORKDIR /app
COPY package.json ./
RUN npm install --prod

# STEP: runner
FROM node:19.2-alpine3.16 AS runner
WORKDIR /app
COPY --from=prod-dependencies /app/node_modules ./node_modules
COPY . .
CMD ["node", "app.js"]
```
## Docker compose build
```bash
    $ docker compose -f docker-compose.prod.yml build
```
```bash
    $ docker compose -f docker-compose.prod.yml up
```
### doker-compose.prod.yml
```bash
version: '3'

services:
  app:
    build:
      context: .
      target: prod
      dockerfile: Dockerfile
    image: lerccen/teslo-shop-backend
    container_name: nest-app
    ports:
      - ${PORT}:${PORT}
    environment:
      APP_VERSION: ${APP_VERSION}
      STAGE: ${STAGE}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_USERNAME: ${DB_USERNAME}
      PORT: ${PORT}
      HOST_API: ${HOST_API}
      JWT_SECRET: ${JWT_SECRET}
  
  db:
    image: postgres:14.3
    restart: always
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    container_name: ${DB_NAME}
    volumes:
      - postgres-db:/var/lib/postgresql/data

volumes:
  postgres-db:
    external: false
```



# Github actions
GitHub Actions es una plataforma de automatización de flujos de trabajo (workflows) integrada en GitHub. Permite a los desarrolladores automatizar procesos de compilación, pruebas, despliegue y otras tareas que están relacionadas con el desarrollo de software.
En relación a docker se utilizará para que a partir del código del repositorio se cree una nueva imagen y se suba a docker hub con el tag automático dependiendo del nombre del commit "major:", "minor:" o cambio menor

- ```docker-graphql/.github/workflows/docker-image.yml```

```yml
name: Docker Image CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout code 
      uses: actions/checkout@v3
      with:
        fetch-depth: 0
    
    - name: Git Semantic Version
      uses: PaulHatch/semantic-version@v4.0.3
      with:
        major_pattern: "major:"
        minor_pattern: "feat:"
        format: "${major}.${minor}.${patch}-prerelease${increment}"
      id: version

    - name: Docker login
      env:
        DOCKER_USER: ${{ secrets.DOCKER_USER }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      run: |
        docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
        
    - name: Build Docker Image
      env:
        NEW_VERSION: ${{ steps.version.outputs.version }}
      run: |
        docker build -t lerccen/docker-graphql:$NEW_VERSION .
        docker build -t lerccen/docker-graphql:latest .
        
    - name: Push Docker Image
      env:
        NEW_VERSION: ${{ steps.version.outputs.version }}
      run: |
        docker push lerccen/docker-graphql:$NEW_VERSION
        docker push lerccen/docker-graphql:latest
```

# Nginx
Nginx, cuyo nombre se pronuncia como "engine-x", es un servidor web y proxy inverso altamente eficiente que se utiliza ampliamente para servir contenido estático y dinámico en la web. Asimismo, es frecuentemente empleado como un proxy inverso para gestionar la carga del servidor y equilibrar la carga en múltiples servidores. Lo utilizaremos para hacer deploy de un SPA mediante el uso de docker.
- ```/etc/nginx/conf.d/default.conf -> nginxconf :```

```nginxconf
server {
    listen       80;
    # listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```
