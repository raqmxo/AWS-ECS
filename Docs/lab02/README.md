# Crear tu primer imagen de Docker

## Ok, pero qué es Docker?

QUE ES DOCKER EN 5 PARRAFOS!!!

Las definiciones de tareas de Amazon ECS usan imágenes de Docker para lanzar contenedores en las instancias de contenedor de sus clústeres. En esta sección, puede crear una imagen Docker de una aplicación web simple y probarla en su sistema local o instancia de EC2. Luego puede enviar la imagen al registro de contenedor (como Amazon ECR o Docker Hub) para que pueda utilizarla en la definición de tareas de ECS.

## Creación de una imagen Docker de una aplicación web simple

Cree un archivo denominado `Dockerfile`. Un `Dockerfile` es un manifiesto que describe la imagen base para su imagen Docker y qué desea instalar y que se ejecute en ella. Para obtener más información acerca de los archivos Docker, consulte [Docker Reference](https://docs.docker.com/engine/reference/builder/).

    touch Dockerfile

Editar el Dockerfile que acaba de crear y añadir el siguiente contenido.

    FROM ubuntu:12.04

    # Install dependencies
    RUN apt-get update -y
    RUN apt-get install -y apache2

    # Install apache and write hello world message
    RUN echo "Hello World!" > /var/www/index.html

    # Configure apache
    RUN a2enmod rewrite
    RUN chown -R www-data:www-data /var/www
    ENV APACHE_RUN_USER www-data
    ENV APACHE_RUN_GROUP www-data
    ENV APACHE_LOG_DIR /var/log/apache2

    EXPOSE 80

    CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]

Este Dockerfile utiliza la imagen Ubuntu 12.04. Las instrucciones RUN actualizan la caché del paquete, instalan algunos paquetes de software para el servidor web y, a continuación, escriben el contenido "Hello World!" en la raíz de documentos del servidor web. El folleto EXPOSE expone el puerto 80 en el contenedor y las instrucciones CMD inician el servidor web.

Cree la imagen Docker desde el Dockerfile.

    nota

    Algunas versiones de Docker pueden requerir la ruta completa a su Dockerfile en el siguiente comando en lugar de la ruta relativa que se muestra a continuación.

    docker build -t hello-world .

Ejecute docker images para comprobar que la imagen se haya creado correctamente.

    docker images --filter reference=hello-world

Salida:

    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    hello-world         latest              e9ffedc8c286        4 minutes ago       258MB

Ejecute la nueva imagen. La opción -p 80:80 asigna el puerto 80 expuesto en el contenedor al puerto 80 del sistema de host. Para obtener más información acerca de docker run, consulte Docker run reference.

    docker run -p 80:80 hello-world

    nota

    La salida desde el servidor web Apache se muestra en la ventana de la terminal. Puede hacer caso omiso del mensaje "Could not reliably determine the server's fully qualified domain name"

Abra un navegador y encuentre el servidor que está ejecutando Docker y alojando su contenedor.

Si utiliza una instancia de EC2, este es el valor DNS público para el servidor, que es la misma dirección que utiliza para conectarse a la instancia con SSH. Asegúrese de que el grupo de seguridad para la instancia permite el tráfico entrante en el puerto 80.

Si ejecuta Docker de forma local, dirija el navegador a http://localhost/.

Si utiliza una máquina Docker en un equipo Windows o Mac, encuentre la dirección IP del VirtualBox VM que aloja Docker con el comando docker-machine y sustituya el nombre de la máquina con el nombre de la máquina docker que utilice.

    docker-machine ip machine-name

Debería ver una página web que diga "Hello, World!" statement.

Detenga el contenedor de Docker escribiendo Ctrl + c.

(Opcional) Envíe su imagen a Amazon EC2 Container Registry.

Amazon ECR es un servicio administrado de registro de Docker de AWS. Los clientes puedes usar la CLI de Docker que ya conocen para insertar, extraer y administrar imágenes. Para obtener información detallada sobre el producto de Amazon ECR, casos prácticos de clientes destacados y preguntas frecuentes, consulte las páginas de detalle del producto de Amazon EC2 Container Registry.

    nota

    Esta sección requiere la AWS CLI. Si no ha instalado la AWS CLI en su sistema, consulte Installing the AWS Command Line Interface en la AWS Command Line Interface Guía del usuario.

Etiquetado de la imagen y envío a Amazon ECR

Cree un repositorio de Amazon ECR para almacenar su imagen hello-world. En los resultados, anote el repositoryUri.

    aws ecr create-repository --repository-name hello-world

Salida:

    {
        "repository": {
            "registryId": "aws_account_id",
            "repositoryName": "hello-world",
            "repositoryArn": "arn:aws:ecr:us-east-1:aws_account_id:repository/hello-world",
            "createdAt": 1505337806.0,
            "repositoryUri": "aws_account_id.dkr.ecr.us-east-1.amazonaws.com/hello-world"
        }
    }

Etiquete la imagen de hello-world con el valor de repositoryUri del paso anterior.

    docker tag hello-world aws_account_id.dkr.ecr.us-east-1.amazonaws.com/hello-world

Ejecute el comando aws ecr get-login --no-include-email para obtener el comando de autenticación de inicio de sesión en Docker para su registro.

    nota

    El comando get-login está disponible en AWS CLI a partir de 1.9.15; sin embargo, le recomendamos la versión 1.11.91 o posterior para las versiones recientes de Docker (17.06 o posterior). Puede comprobar su versión de AWS CLI con el comando aws --version. Si utiliza Docker versión 17.06 o posterior, incluya la opción --no-include-email después de get-login. Si recibe un error Unknown options: --no-include-email, instale la última versión de AWS CLI. Para obtener más información, consulte Installing the AWS Command Line Interface en la AWS Command Line Interface Guía del usuario.

    aws ecr get-login --no-include-email

Ejecute el comando docker login que se devolvió en el paso anterior. Este comando proporciona un token de autorización que es válido durante 12 horas.

importante

Si ejecuta este comando docker login, otros usuarios del sistema podrán ver la cadena del comando en una pantalla de lista de procesos (ps -e). Como el comando docker login contiene las credenciales de autenticación, existe el riesgo de que otros usuarios de su sistema puedan verlas y usarlas para obtener acceso de recepción y envío a sus repositorios. Si no se encuentra en un sistema seguro, deberá considerar este riesgo e iniciar sesión de forma interactiva omitiendo la opción -p password y después introducir la contraseña cuando se le solicite.

Envíe la imagen a Amazon ECR con el valor repositoryUri valor del paso anterior.

    docker push aws_account_id.dkr.ecr.us-east-1.amazonaws.com/hello-world

Pasos siguientes

Cuando termine de insertar la imagen, puede usar la imagen en sus definiciones de tareas de Amazon ECS, que puede utilizar para ejecutar tareas.

    nota

    Esta sección requiere la AWS CLI. Si no ha instalado la AWS CLI en su sistema, consulte Installing the AWS Command Line Interface en la AWS Command Line Interface Guía del usuario.

Registro de una definición de tarea con la imagen de hello-world

Crear un archivo llamado hello-world-task-def.json con los siguientes contenidos, sustituyendo la repositoryUri de la sección anterior con el campo image.

    {
        "family": "hello-world",
        "containerDefinitions": [
            {
                "name": "hello-world",
                "image": "aws_account_id.dkr.ecr.us-east-1.amazonaws.com/hello-world",
                "cpu": 10,
                "memory": 500,
                "portMappings": [
                    {
                        "containerPort": 80,
                        "hostPort": 80
                    }
                ],
                "entryPoint": [
                    "/usr/sbin/apache2",
                    "-D",
                    "FOREGROUND"
                ],
                "essential": true
            }
        ]
    }

Registro de una definición de tarea con el archivo hello-world-task-def.json

    aws ecs register-task-definition --cli-input-json file://hello-world-task-def.json

La definición de tarea está registrada en la familia hello-world, tal y como se define en el archivo JSON.

Ejecución de una tarea con la definición de tareas de hello-world

    importante

    Antes de poder ejecutar tareas en Amazon ECS, debe lanzar instancias de contenedor en un clúster predeterminado. Para obtener más información acerca de cómo configurar y lanzar las instancias de contenedor, consulte Configuración con Amazon ECS y Introducción al uso de Amazon ECS con Fargate

Use el siguiente comando de AWS CLI para ejecutar una tarea con la definición de tareas de hello-world.

    aws ecs run-task --task-definition hello-world
