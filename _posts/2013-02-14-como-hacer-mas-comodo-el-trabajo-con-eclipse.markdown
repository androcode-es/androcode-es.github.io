---
layout: post
title: Hacer más cómodo el trabajo con Eclipse
date: '2013-02-14 11:00:00'
tags:
  - Tutoriales
---

Lo parezca o no, trabajar cómodo con nuestro entorno de desarrollo es muy importante de cara a la productividad. Es por eso que nos cuesta tanto cambiarnos a otro IDE cuando estamos acostumbrados a uno concreto. Nos sentimos perdidos, todo lo que es diferente nos parece peor. Porque no hay nada como escribir código cómodamente.

[![eclipse_indigo](http://androcode.es/wp-content/uploads/2015/02/eclipse_indigo_sf5siq.png)](http://androcode.es/wp-content/uploads/2015/02/eclipse_indigo_sf5siq.png)

El post de hoy no es tan exclusivo para el desarrollo Android, pero como también nos afecta a nosotros me ha parecido bien tratarlo. Vamos a ver algunos trucos y consejos para escribir código aún más fácilmente, si estamos usando Eclipse.<!--more-->

Todo lo que se comenta en esta entrada son opiniones a título personal y como orientación Para gustos colores, si no te parecen buenos consejos o tienes otros mejores, cuéntanoslo en los comentarios ;)


> Utilizaré como base el ADT Bundle para Windows que tenemos disponible en la página de desarrolladores, que contiene el SDK y una versión modificada de Eclipse 3.6 con la configuración básica para empezar a desarrollar aplicaciones Android.

###### Preparación del entorno

Lo primero que vamos a ver son algunos cambios en la configuración de Eclipse que podemos hacer para facilitarnos el trabajo. Aunque opciones hay muchas, éstas son las que me han parecido más útiles. Mi _"must have"_ personal, lo primero que tengo que cambiar si hago una instalación nueva.


###### Cambiar la codificación de caracteres

Es un tema por el que me he echado las manos a la cabeza más de una vez. Y más de dos, y de trés... Trabajar con diferentes codificaciones es un infierno, sólo causará problemas. Eclipse por defecto en Windows utiliza una codificación, en Linux otra, y en OSX otra distinta. Si trabajas siempre en la misma máquina el problema puede pasar desapercibido, pero en cuanto migras un proyecto de sistema, se lo pasas a alguien, etc. verás como los caracteres especiales se han convertido en símbolos extraños.

Los angloparlantes no suelen tener graves problemas con esto, pues la mayoría de codificaciones _respetan_ sus símbolos. Pero nosotros, con tanta tilde y símbolo raro, vamos a encontrarnos en apuros. Lo mejor es curarse en salud y cambiar desde un principio la codificación de todo el workspace, en el menú bajo Window &gt; Preferences,  a una universal como UTF-8. 

[![codificacion](http://androcode.es/wp-content/uploads/2015/02/codificacion_twaypa-300x258.png)](http://androcode.es/wp-content/uploads/2015/02/codificacion_twaypa.png)

Si lo hacéis no me lo agradeceréis porque no os daréis cuenta de que os ha servido. Pero si no, ya os arrepentiréis.  ;-)

###### Desactivar _compilado automático_ y _compilar todo_

Por defecto Eclipse tiene activada la opción de compilar automáticamente nuestro proyecto cuando guardamos algún archivo modificado. Esto es especialmente problemático en Android cuando tenemos proyectos relativamente complejos, con varias librerías externas vinculadas y demás compilar puede llevar varios segundos o peor en ordenadores con pocos recursos (¿he oído minutos?). Y no es agradable que nos interrumpan el trabajo sólo por guardar los cambios. Por ello es de lo primero que desactivo cuando abro Eclipse por primera vez. Sólo hay que desmarcar la opción en Project &gt; Build Automatically.

[![build](http://androcode.es/wp-content/uploads/2015/02/build_s0orgi-300x153.png)](http://androcode.es/wp-content/uploads/2015/02/build_s0orgi.png)

Aunque desactivando dicha opción tenemos el <del>problema</del> inconveniente de tener que compilar manualmente cuando lo necesitemos. Por suerte tenemos el atajo de teclado **Ctrl+B** para hacerlo a golpe de tecla, pero este atajo corresponde al comando _Build All_, es decir que nos compilará todos los proyectos de nuestro workspace. ¡Aún peor que lo anterior! Don't panic, es tan fácil como cambiar el atajo para que ejecute el comando _Build Project_ en su lugar, de esa forma la combinación te teclas sólo compilará el proyecto en el que nos encontremos en ese momento. En el apartado Keys de las preferencias buscamos el comando _Build All_ y le anulamos el atajo de teclado con **Unbind Command**, luego seleccionamos _Build Project_ y en Binding pulsamos la combinación Ctrl+B (u otra) para establecérsela.

[![build3](http://androcode.es/wp-content/uploads/2015/02/build3_asmolf-300x215.png)](http://androcode.es/wp-content/uploads/2015/02/build3_asmolf.png)

Aunque para ejecutar no suele hacer falta compilar porque ya lo hace solo, ya sabemos cómo se pone de tonto a veces Eclipse. Es uno de los comandos que yo más utilizo.

###### Desactivar corrección ortográfica

Curiosamente Eclipse tiene corrector ortográfico para los comentarios y documentación. Pero a los hispanohablantes no nos sirve de mucho si escribimos en español porque sólo está en inglés. Podríamos descargar e instalar un diccionario en español, pero yo prefiero optar por desactivarlo por completo y quitarme las molestas líneas rojas que salen por todas partes.

[![spelling](http://res.cloudinary.com/dttcwxrjo/image/upload/h_235,w_300/v1422989312/spelling_dsdejb.png)](http://res.cloudinary.com/dttcwxrjo/image/upload/v1422989312/spelling_dsdejb.png)

###### Explorador de paquetes en vista jerárquica

El explorador de paquetes nos permite 2 formas básicas de visualizarlos: **plana** y** jerárquica**. Por defecto nos los muestra de forma plana, pero cuando tenemos muchos paquetes anidados la jerárquica permite verlos más claramente con su estructura de árbol. ¿No os parece?

[![package](http://androcode.es/wp-content/uploads/2015/02/package_xzre6q.png)](http://androcode.es/wp-content/uploads/2015/02/package_xzre6q.png)

Podéis usar la que más os guste, en cualquier caso el cambio es sencillo.

[![package3](http://androcode.es/wp-content/uploads/2015/02/package3_nr4kyw-300x182.png)](http://androcode.es/wp-content/uploads/2015/02/package3_nr4kyw.png)

###### Ayuda para escribir código

Ahora veremos alguno ajustes orientados a facilitarnos la escritura de código. Eclipse permite un alto nivel de personalización, pero sólo veremos unos que me parecen muy interesantes. Como antes, recomiendo echar un ojo a todas las opciones y adaptarlo todo a nuestras necesidades.

###### Punto y coma siempre al final

En java las sentencias llevan un punto y coma al final. Parece una tontería, pero son incontables las veces que he tenido que desplazarme al final de la línea para poner un punto y coma. Con este cambio Eclipse colocará la puntuación correctamente al final de la línea aunque estemos editando en mitad, ahorrándonos un par de pulsaciones de tecla.

[![semicolon](http://androcode.es/wp-content/uploads/2015/02/semicolon_d3j7on-300x275.png)](http://androcode.es/wp-content/uploads/2015/02/semicolon_d3j7on.png)

###### Autocompletado de métodos mejorado

El autocompletado de Eclipse es magnífico. **Ctrl+Espacio** es la combinación que más uso con diferencia, nos ahorra escribir una barbaridad de código. Pero algo que siempre me ha reventado es cómo al completar una variable o un método desde en medio inserta el texto en vez de modificarlo.

[![overwrite12](http://androcode.es/wp-content/uploads/2015/02/overwrite12_zdjdag.png)](http://androcode.es/wp-content/uploads/2015/02/overwrite12_zdjdag.png)

Pues hace poco descubrí que se podía cambiar para que sustituyera el resto del texto. De esa forma en el ejemplo anterior obtendríamos lo siguiente:

[![overwrite34](http://androcode.es/wp-content/uploads/2015/02/overwrite34_ndqvjq.png)](http://androcode.es/wp-content/uploads/2015/02/overwrite34_ndqvjq.png)

A mi me resulta muchísimo más útil la segunda transformación, y sólo hay que cambiar una opción:

[![overwrite](http://androcode.es/wp-content/uploads/2015/02/overwrite_dhqc8k-300x275.png)](http://androcode.es/wp-content/uploads/2015/02/overwrite_dhqc8k.png)

###### Escapar Strings al pegar texto

Copiar y pegar es el recurso más utilizado. ¿Cuántas veces hemos pegado en una cadena un texto copiado de otra parte que contiene comillas y otros caracteres que necesitan ser escapados (como las comillas en un código html)? Activando esta opción no tendremos que hacerlo más, pues el texto se transformará automáticamente cuando lo peguemos para escapar dichos caracteres.

[![strings](http://androcode.es/wp-content/uploads/2015/02/strings_mrdpqp-300x276.png)](http://androcode.es/wp-content/uploads/2015/02/strings_mrdpqp.png)

Aquí vemos cómo quedaría al pegar una cadena con comillas antes y después de activar esta opción:

[![strings2](http://androcode.es/wp-content/uploads/2015/02/strings2_tqfznv.png)](http://androcode.es/wp-content/uploads/2015/02/strings2_tqfznv.png)

###### Acciones al guardar

Nos puede venir bien que Eclipse haga determinadas cosas automáticamente cuando guardamos un archivo. Por ejemplo, que reorganice las importaciones de paquetes, o que formatee el código según las reglas que le digamos. Debo confesar que yo personalmente lo tengo desactivado, porque tengo la manía de guardar los cambios constantemente, y al procesar el archivo cada vez puedo notar el retraso en contadas ocasiones si el ordenador está pasando un mal rato y no lo soporto. Pero aun así, si no sois tan maníacos como yo seguro que agradecéis esta función.

[![save](http://androcode.es/wp-content/uploads/2015/02/save_dqpzw9-300x276.png)](http://androcode.es/wp-content/uploads/2015/02/save_dqpzw9.png)

###### Formateo de código

Otra de las funciones más útiles de Eclipse es el formateo de código automático, mediante la combinación de teclas **Ctrl+Shift+F**. Nosotros escribimos (o pegamos) un churro, con las identaciones mal puestas, espacios sobrantes, etc., y Eclipse nos deja un código limpio, claro y ordenado. Pero es importante para estar cómodos con nuestro IDE que nos produzca código que nos guste. Para ello viene bien echar unos minutos en revisar las opciones de personalización del formateo de código, que no son pocas. Podemos tener varios perfiles, e incluso configurar un perfil distinto para cada proyecto (modificando las preferencias del proyecto concreto, y no las globales). Para personalizarlos creamos uno nuevo o editamos el existente (habrá que guardarlo con otro nombre).

[![format1](http://androcode.es/wp-content/uploads/2015/02/format1_kficmo-300x274.png)](http://androcode.es/wp-content/uploads/2015/02/format1_kficmo.png)

Aquí entran muy en juego los gustos de cada uno. Aconsejo mirar todas las opciones, elegir las que nos parezcan mejores, y volver a mirarlas tras llevar un tiempo con ellas para asegurarnos de que estamos cómodos con todas.

[![format2](http://androcode.es/wp-content/uploads/2015/02/format2_bhouhm-300x257.png)](http://androcode.es/wp-content/uploads/2015/02/format2_bhouhm.png)

Os comento como ejemplo las que yo suelo cambiar, que son realmente pocas: En _Identation_ pongo Tab Policy a _Tabs Only_, y activo _Statements within switch body_; en _Line Wrapping_ pongo el _Maximun line width_ a un valor alto como 200 para que no me divida las líneas, y activo _Never join already wrapped lines_ por si quiero dividirlas  manualmente; y por último en _Comments_ activo _Never join lines_ para decidir yo los saltos de línea, y pongo el _Maximun line width_ también a un valor como 200. 

Mucho ojo a esta función si trabajamos en grupo con repositorios, o si contribuímos a proyectos de software libre. Debemos adaptarnos a las normas comunes, así que si pensamos dejar que Eclipse formatee nuestro código debemos asegurarnos de respetar dichas normas. No queremos que Git nos marque todo el archivo "en rojo" cuando sólo hemos cambiado una línea, ¿verdad?

###### Etiquetas

No muy usadas, pero están ahí para ayudar a organizarnos si las necesitamos. Las etiquetas son comentarios especiales que podemos poner para marcar nuestro código. La más famosa es la etiqueta **TODO**, para dejar anotado algo que tenemos que hacer o cambiar en un futuro. Pero nosotros mismos podemos crear nuestras etiquetas personalizadas. Por ejemplo DEBUG para indicar algo que debemos quitar antes de sacar la aplicación a producción,  asignar tareas a determinadas personas en un grupo, etc. 

[![tags](http://androcode.es/wp-content/uploads/2015/02/tags_uh9kru-300x278.png)](http://androcode.es/wp-content/uploads/2015/02/tags_uh9kru.png)

Luego podemos ver la lista de etiquetas usadas en la vista Tasks (Si no la tenemos se activa en Window &gt; Show View &gt; Tasks)

[![tags2](http://androcode.es/wp-content/uploads/2015/02/tags2_neqlws.png)](http://androcode.es/wp-content/uploads/2015/02/tags2_neqlws.png)

###### Plantillas de código

Eclipse nos permite usar palabras clave para generar automáticamente determinadas estructuras de código, y más aún, crearlas a nuestro gusto. Por ejemplo, uno de los métodos más utilizados en Java es System.out.println() para imprimir texto en la consola; pues nos basta con escribir en el editor "sysout" y pulsar el autocompletado (ctrl+espacio) para que nos inserte la línea completa y nos ponga el cursor en la posición del argumento. Lo mismo ocurre con "try" para insertar un bloque try-catch.

[![codtemplate12](http://androcode.es/wp-content/uploads/2015/02/codtemplate12_kuk5re.png)](http://androcode.es/wp-content/uploads/2015/02/codtemplate12_kuk5re.png)

La lista completa podemos verla en las preferencias, y ahí mismo podemos añadir nuestras propias plantillas. Por ejemplo, podríamos crear una plantilla así para inicializar el método getView() típico del BaseAdapter: 

[![codetemplates3](http://androcode.es/wp-content/uploads/2015/02/codetemplates3_jgadxe-300x261.png)](http://androcode.es/wp-content/uploads/2015/02/codetemplates3_jgadxe.png)

[![codetemplates4](http://androcode.es/wp-content/uploads/2015/02/codetemplates4_anikbo-1024x355.png)](http://androcode.es/wp-content/uploads/2015/02/codetemplates4_anikbo.png)

Copiar código

Y en el editor de código, poniendo la palabra clave con autocompletado, nos genera el código por el que podemos movernos mediante el tabulador. ¡Magia!

[![codetemplates56](http://androcode.es/wp-content/uploads/2015/02/codetemplates56_jp3ca5.png)](http://androcode.es/wp-content/uploads/2015/02/codetemplates56_jp3ca5.png)

###### Plantillas de ADT

No hace mucho añadieron al plugin ADT la posibilidad de crear componentes de Android como Actividades para nuestras aplicaciones mediante un **asistente**, que podemos encontrar en el menú _File &gt; New_ bajo la categoría de Android, el cual nos genera el código y recursos que podemos editar fácilmente. Por ejemplo, en el caso de las Actividades nos creará un **layout** y **menú** básicos en xml, la **clase Java** correspondiente con el código para mostrar el layout y el menú, y la entrada necesaria en el **AndroidManifest.xml**. E incluso podemos decirle que nos añada elementos extra de navegación como pestañas, ViewPager y más.

[![templatesadt2](http://androcode.es/wp-content/uploads/2015/02/templatesadt2_ogac3e-300x284.png)](http://androcode.es/wp-content/uploads/2015/02/templatesadt2_ogac3e.png)

Por si fuera poco, un tiempo después añadieron la posibilidad de instalar plantillas personalizadas creadas por nosotros mismos. Yo os recomiendo [estas plantillas ](https://github.com/jgilfelt/android-adt-templates)creadas por Jeff Gilfelt para crear Actividades compatibles con la magnífica librería **[ActionBar Sherlock](http://androcode.es/2012/03/introduccion-a-actionbarsherlock/ "Introducción a ActionBarSherlock")**, entre otras. En el repositorio tenéis más información sobre para qué es cada uno de los elementos que añade. Además, instalar las plantillas es tan sencillo como pegarlas en la carpeta **/extras/templates/** del SDK.

[![templatesadt4](http://androcode.es/wp-content/uploads/2015/02/templatesadt4_qkhxyb-198x300.png)](http://androcode.es/wp-content/uploads/2015/02/templatesadt4_qkhxyb.png)

Tenéis más información sobre cómo crear plantillas en [este post de Google+](https://plus.google.com/113735310430199015092/posts/XTKTamk4As8). ¿Se os ocurren más plantillas útiles? ¿Os animáis a hacerlas y compartirlas? ;)

Y hasta aquí los cambios que os sugerimos para vuestro IDE, espero que algunos os resulten tan útiles como a mi. En futuras entregas intentaremos contar otros trucos a la hora de usar Eclipse. Si tenéis más sugerencias relacionadas son bienvenidas en los comentarios  ;-)

Fuentes: [Vogella](http://www.vogella.com/articles/Eclipse/article.html#preferences) y cosecha propia
