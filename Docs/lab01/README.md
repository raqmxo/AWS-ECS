# Instalación y Configuración de Docker

En este laboratorio instalaremos el software de Docker en su laptop. Docker está disponible en muchos sistemas operativos diferentes, incluidas las distribuciones de Linux más modernas, como Ubuntu, e incluso en Mac OSX y Windows. Dependiendo del sistema operativo que ud. disponga, es posible que requiera diferente porceso de instalación. En general tanto para los sistemas operativos Linux como Windows, ud. podrá encontrar las instrucciones de instalación en las siguientes páginas:

[Docker download](https://www.docker.com/get-started)

[Docker Install](https://docs.docker.com/install/)

En este laboratorio mostramos las instrucciones para instalarlo en una máquina Linux.

Ejecute el siguiente comando desde una terminal de su equipo:

```
docker --version
```

Si ud. no obtiene una salida similar a la siguiente, es probable que requiera descargar e instalar el producto.

```
docker --version
Docker version 18.06.1-ce, build e68fc7a
```

Para instalar Docker en su sistema operativo, ejecute el siguiente comando en una terminal de su equipo:

```
sudo yum install -y docker
```

Inicie el servicio de Docker a través del siguiente comando:

```
sudo service docker start
```

Agregue a su usuario al grupo `docker` para que pueda ejecutar comandos de docker sin la necesidad de ejecutarlos a través de la cuenta de root o `sudo`.

```
sudo usermod -a -G docker your_user_name
```

Cierre sesión y vuelva a iniciarla para actualizar los nuevos permisos de grupo de `docker`.

Compruebe que puede ejecutar comandos de `docker` ejecutando el siguiente comando desde una terminal en su equipo:

```
docker info
```

Si todo está en orden, debera observar una salida similar a la siguiente:

```
$ docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 18.06.1-ce
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host ipvlan macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
...
HTTP Proxy: gateway.docker.internal:3128
HTTPS Proxy: gateway.docker.internal:3129
Registry: https://index.docker.io/v1/
Labels:
Experimental: true
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
```

## Proceda a la siguiente etapa del taller

[Crear tu primer imagen de Docker](https://github.com/raqmxo/AWS-ECS/blob/master/Docs/lab02/README.md)
