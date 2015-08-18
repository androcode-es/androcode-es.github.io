---
layout: post
title: Integración Contínua con Gitlab CI
author: rafa
tags:
- Artículos
---

En el trabajo llevamos algunos meses usando GitLab.com, un clon libre de GitHub, y nos encanta. Primero lo usamos en nuestro propio servidor, pero viendo que en Gitlab.com tenemos repositorios privados gratuitos y actualizaciones automáticas comenzamos a migrarnos a su nube.

Aunque virtudes tiene muchas, yo hoy voy a hablar por una concreta: Integración contínua *by the face*. GitLab tiene otro producto llamado GitLab CI, un gestor de builds apoyado en los repositorios de Gitlab, y lo mejor es que si usamos gitlab.com tenemos acceso a esta herramienta gratis, también para repositorios privados.

<!--more-->

Los que uséis GitHub con Travis ya sabéis lo cómodo que es configurar integración contínua en un proyecto. Se trata de añadir un archivo de configuración al proyecto y listo. Con Gitlab CI es parecido, pero hay una pega: que nosotros debemos proporcionar la máquina que ejecutará la compilación. Con las últimas versiones el proceso se ha simplificado tremendamente, y a continuación vamos a ver cómo configurar una máquina para hacer compilaciones de proyectos Android.

# ¿Por qué no otro?
//TODO gitlab vs jenkins

# Runners

Gitlab CI se basa en el concepto de Runners. No se trata de gente que escribe en twitter lo mucho que corre, sino de máquinas asociadas a nuestro proyecto que ejecutarán las tareas de compilación. Podemos tener n máquinas asociadas a un proyecto, y varios proyectos usando la misma máquina. Estas máquinas pueden ser servidores de Amazon EC2, DigitalOcean, ordenadores de la oficina o incluso tu propio portátil. Gitlab CI utilizará los runners que estén disponibles en cada momento.

Hasta hace poco era algo tedioso configurar los runners para compilar según tus necesidades, pero gracias al nuevo Multi Runner oficial y su soporte para Docker es facilísimo.

# Cómo hacerlo
El proceso es realmente sencillo. Lo describo brevemente por facilitar la búsqueda de información. 

## Repositorio de Gitlab

Lo primero es obviamente alojar el código en un repositorio de Gitlab. Bien sea en una instalación propia o en la nube de Gitlab.com, ya sea público o privado. No hay mucho que explicar aquí.

## Instalar Gitlab Multi Runner
Lo siguiente es instalar el runner de gitlab en la máquina que queramos usar para compilar. La elección es cosa vuestra, se puede instalar en Linux, Windows, OSX o como un servicio Doker. Yo he probado a instalarlo directamente en mi Mac personal, un pc Ubuntu de la oficina y un servidor dedicado de DigitalOcean. 

El proceso es **muy fácil**, tenéis las instrucciones en la página del repositorio del multi runner:

- [Linux](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/linux-repository.md)
- [OSX](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/osx.md)
- [Windows](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/windows.md)
- [Más opciones](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner#installation)

## Asociar el runner
Tal como se explica en las instrucciones, lo que queda es registrar el runner con nuestro Gitlab CI. Se hace con el comando `gitlab-ci-multi-runner register`, y nos pedirá una serie de datos.

- **gitlab-ci coordinator URL**: Si estamos usando el servicio en la nube de Gitlab.com será *https://ci.gitlab.com/*

- **gitlab-ci token**: Este token es el que asocia el runner con nuestro proyecto. Lo encontramos en la sección Runners del panel de control de Gitlab CI.

![runners-section](./gitlab-runners.png)

- **Descripción**: No necesitas un tutorial para esto. Identifica el runner con nombre.

- **Executor**: Aquí hay que decidir si queremos que las builds se ejecuten en la máquina tal cual o dentro de un contenedor Docker (entre otras). Yo prefiero la segunda opción, de esa forma la build no dependerá de la configuración de la máquina. Nos preguntará por el nombre de la imagen de docker. Yo utilizo `sloydev/android-env`, una imagen configurada por mí publicada en Docker Hub. Podéis usar esa misma u otra propia.

Las demás opciones las podemos ignorar (intro). Podemos ver en la sección de Runners que aparece el nuestro.

![runners-section](./gitlab-runners2.png)


## Configuración del proyecto
Con esto debería estar todo preparado en la parte de servidor. Sólo falta añadir el archivo de configuración al proyecto para decirle a Gitlab CI qué hacer. Se hace añadiendo un archivo de YAML a la raíz, muy similar a como se hace con Travis CI.

//TODO