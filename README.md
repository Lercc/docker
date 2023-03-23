# DOCKER

## IMAGEN 🖼️
Archivo construido mediante capas en la cual figuran todas las dependencias, configuraciones, scripts, binarios, etc necesarios para su ejecucíon. Además es el archivo base con el cúal se creará el contenedor.

### COMANDOS 🖼️
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

## CONTENEDOR ⏹️
Instancia de una imagen corriendo en un entorno aislado.

### COMANDOS ⏹️
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

## VOLUMEN 🗂️
Instancia de una imagen corriendo en un entorno aislado.

### COMANDOS 🗂️
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

## NETWORK 🌐
Instancia de una imagen corriendo en un entorno aislado.

### COMANDOS 🌐
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




