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




