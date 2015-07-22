---
layout: post
title: Otra forma de acelerar el emulador de Android
date: '2014-02-21 11:00:00'
tags:
  - Tutoriales
---

Por muchos es sabido que el emulador de android que viene con el SDK deja mucho que desear. Afortunadamente existen alternativas como usar [android-x86 y virtualbox para virtualizar un dispositivo android ](http://androcode.es/2011/10/aumenta-la-velocidad-del-emulador-de-android-en-un-400/ "Aumenta la velocidad del emulador de Android en un 400%")como vimos anteriormente. Pero hoy voy a contaros otra forma, disponible desde hace un tiempo, que también está basado en virtualización pero está mejor integrado con el entorno de desarrollo como puede ser Eclipse. En este caso vamos a usar la virtualización existente en los procesadores Intel, y una imagen de disco de android para x86, también provista por intel a través del SDK Manager de Android, de forma que convierte este proceso en algo fácil y rápido.

###### Requisitos:

- Procesador con Intel que soporte Intel VT-x, EM64T y Execute Disable(XD) Bit habilitado en la BIOS.
- Tener instalado el [SDK de Android.<!--more-->](https://developer.android.com/sdk/index.html "Android SDK")

###### Instalación en Windows

Una vez instalado el SDK de Android, abrimos el SDK Manager que usamos para descargarnos las diferentes versiones de Android y marcamos para descargar el Intel HAXM dentro de la pestaña de "extras". Aunque lo instalemos desde el SDK Manager en realidad sólo nos copia un instalador a la carpeta "extras" donde está instalado el SDK de Android, así que vamos a ésa carpeta de nuestro disco duro e instalamos IntelHaxm.exe. Otra cosa que debemos marcar para instalar es la Intel x86 Atom System Image de la versión de Android que deseemos, de esta manera podremos crear AVDs con esta imagen del sistema.

[![intel_haxm_1](http://androcode.es/wp-content/uploads/2015/02/intel_haxm_1_nufouv.png)](http://androcode.es/wp-content/uploads/2015/02/intel_haxm_1_nufouv.png)[![Intel HAXM.exe](http://androcode.es/wp-content/uploads/2015/02/ScreenShot017_ho8kzb.png)](http://androcode.es/wp-content/uploads/2015/02/ScreenShot017_ho8kzb.png)

Ejecutamos el instalador y seguimos los pasos. En caso de que nuestra BIOS no tenga configurada la opción de VT-x deberemos arrancar la BIOS, para activarla más o menos así, y luego volver a instalar el Intel HAXM:

[![](http://software.intel.com/sites/default/files/haxm07.jpg)](http://software.intel.com/sites/default/files/haxm07.jpg)

###### Crear el AVD

Una vez instalado el SDK y el Intel HAXM, procederemos a crear un dispositivo android virtual, para ello abrimos el AVD Manager y creamos un AVD nuevo.

Deberemos elegir un target del que nos hayamos bajado su imagen Intel x86 como hemos hecho en el paso anterior con el SDK Manager, así podremos elegir, en CPU/ABI, la opción Intel Atom (x86).

Ponemos un nombre y elegimos un dispositivo cualquiera.

Importante seleccionar "Use Host GPU" para que utilice OpenGL para el renderizado, de esta manera la parte gráfica irá más rápida. Una vez hecho todo esto, hacemos click en OK, para generar el AVD y luego una vez creado, pulsamos en Start y arrancamos el emulador. Debería tardar sólo 15 segundos y debemos ver un mensaje de que está arrancando en "fast virtual mode"

[![intel_haxm_3](http://androcode.es/wp-content/uploads/2015/02/intel_haxm_3_ywl9tw.png)](http://androcode.es/wp-content/uploads/2015/02/intel_haxm_3_ywl9tw.png)

Una vez hecho esto, podemos instalar y probar nuestra aplicación en el emulador e incluso controlar algunos aspectos como la ubicación GPS, simular recibir llamadas o mensajes, etc. desde la pestaña "Emulator control" de la perspectiva "DDMS" (En Eclipse: Window &gt; Open perspective &gt; DDMS).

Para más información, resolución de problemas y cómo instalarlo en Linux, podéis leer [este artículo de la página de Intel](http://software.intel.com/en-us/android/articles/speeding-up-the-android-emulator-on-intel-architecture#_Toc358213274 "Intel HAXM") que lo explica con más detalle.
