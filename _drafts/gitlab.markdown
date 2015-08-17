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

## Repositorio de Gitlab

//TODO crear un repo

## Instalar Gitlab Multi Runner
Lo primero es instalar el runner de gitlab en la máquina que queramos usar para compilar 

## Asociar