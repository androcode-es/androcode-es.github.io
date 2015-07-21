---
layout: post
title: Generar ID único en la instalación de nuestras apps
date: '2013-04-19 10:00:00'
tags:
	- Snippets
---

Hace poco tuve que pelearme con la generación de un ID único para el dispositivo o la instalación que estoy ejecutando de mi aplicación y tras buscar mucho por Internet encontré varias opciones pero siempre con algún inconveniente que hacía imposible su uso real.

Las distintas opciones que encontré _(y sus inconvenientes)_ son estas:

- _IMEI:_ Sólo disponible en dispositivos con SIM disponible. Necesita declarar permiso en el manifest.</span>
- *Secure.ANDROID_ID:* Sólo existe desde Android 2.2 y con posibles valores duplicados entre dispositivos.
- _MAC del WiFi/BT:_ Sólo funciona si está activo el receptor. Necesitamos pedir permiso en el manifest.
- _Build.SERIAL:_ Disponible a partir de Android 2.3. Sólo obligatorio para dispositivos sin SIM.
Como podéis ver no hay nada que directamente nos identifique el dispositivo o la instalación de forma única y, por tanto, que podamos usar como ID de la misma.

Tras mucho pelearme me crucé con un snippet de código que Reto Meier indicó en el Google I/O de 2011 como mejor aproximación para obtener dicha identificación y que no tiene ninguno de los inconvenientes que sí veíamos en las opciones anteriores.

<!--more-->

El snippet en concreto es este que os copio aquí debajo y que podéis pegar en cualquier clase de vuestro proyecto directamente ya que no necesita ningún permiso especial a declarar en el manifest y es compatible incluso con Android 1.0...

```
private static String uniqueID = null;
private static final String PREF_UNIQUE_ID = "PREF_UNIQUE_ID";

public synchronized static String id(Context context) {
	if (uniqueID == null) {
		SharedPreferences sharedPrefs = context.getSharedPreferences(PREF_UNIQUE_ID, Context.MODE_PRIVATE);
		uniqueID = sharedPrefs.getString(PREF_UNIQUE_ID, null);
		if (uniqueID == null) {
			uniqueID = UUID.randomUUID().toString();
			Editor editor = sharedPrefs.edit();
			editor.putString(PREF_UNIQUE_ID, uniqueID);
			editor.commit();
		}
	}
	return uniqueID;
}
```

Y para obtener el código desde cualquier punto de nuestro proyecto tan solo debemos llamar al método _id()_ pasándole un objeto de tipo _Context_, por ejemplo:
<pre class="brush: java; gutter: true; first-line: 1">String deviceID = id(Activity.this);</pre>
Y hasta aquí este pequeño snippet que seguro le dais un buen uso... ;)