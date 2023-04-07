# DOCKER
Docker es una herramienta que tiene como objetivo simplificar el proceso de construcción, distribución y despliegue de aplicaciones mediante la utilización de contenedores

# ÍNDICE
- [Bases](#bases)
    - [Imagen 🖼️](#imagen-🖼️)
    - [Contenedor ⏹️](#contenedor-⏹️)
    - [Volumen 🗂️](#volumen-🗂️)
        - [Tipos de volúmenes](#tipos-de-volúmenes)
    - [Nertwork 🌐](#nertwork-🌐)
    - [Logs](#Logs)
    - [Termina interactiva](#termina-interactiva)
- [Contenedores múltiples](#contenedores-múltiples)


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
