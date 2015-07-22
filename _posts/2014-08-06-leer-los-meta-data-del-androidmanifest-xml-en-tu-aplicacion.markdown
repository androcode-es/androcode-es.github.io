---
layout: post
title: Leer los meta-data del AndroidManifest.xml en tu aplicación
date: '2014-08-06 10:00:00'
tags:
- Snippets
---

¿Os habéis preguntado alguna vez cómo se pueden pasar datos a tu activity que estén definidos directamente en el AndroidManifest.xml? ¿U os habéis preguntado como se leen esas API keys definidas en los meta datos de la aplicación en el manifest?

Pues en realidad es muy sencillo y dependiendo de donde pongamos el elemento **&lt;meta-data&gt;** se hará de una forma u otra.

<!--more-->

Estos meta datos pueden ser constantes, claves de api, cadenas con parámetros opcionales, etc. Los definimos en el AndroidManifest.xml y pueden tener distintos ámbitos. Cuando una librería nos pide meter una API key suele hacerse en un elemento **&lt;meta-data&gt;** dentro del **&lt;application&gt;** pero se puede hacer a nivel de **&lt;activity&gt;, &lt;provider&gt;, &lt;receiver&gt; **o** &lt;activity-alias&gt;** y dependiendo de dónde esté, se hará llamando a unos métodos u otros.

Pongamos por caso que tenemos un activity definido así:
<div>
<pre class="brush: xml; gutter: true; first-line: 1">&lt;activity android:name=".MiActivity"&gt;
    &lt;meta-data
        android:name="com.miapp.midato"
        android:resource="@string/midato" /&gt;
&lt;/activity&gt;</pre>
</div>
```
<activity android:name=".MiActivity">  
    <meta-data
        android:name="com.miapp.midato"
        android:resource="@string/midato" />
</activity>
```
En este caso hemos puesto una etiqueta** &lt;meta-data&gt;** en un activity, así que para leerlo nos referimos a la clase **ActivityInfo** que obtenemos a través del **PackageManager** así:
<pre class="brush: java; gutter: true; first-line: 1">ActivityInfo ai = this.getPackageManager().getActivityInfo(this.getComponentName(), PackageManager.GET_ACTIVITIES|PackageManager.GET_META_DATA);
int stringReference = ai.metaData.getInt("com.miapp.usuario")</pre>
Vemos en este caso que el atributo que hemos definido en los meta datos es un **android:resource**, por lo tanto lo tenemos que recuperar con un getInt que nos devolverá el id de la referencia, luego podemos recuperar el valor con **getString(stringReference)**.

Pero si en vez de usar **android:resource** usamos **android:value** podemos usar tipos primitivos como string, int, bool, float y color, y que recuperaríamos luego con **getString(), getInt(), getBoolean(), getFloat() y getInt()** respectivamente.

En el caso de que los meta datos sean a nivel de aplicación y los hayamos definido dentro de &lt;application&gt; entonces para recuperarlos tenemos que usar el **ApplicationInfo**:
<pre class="brush: java; gutter: true; first-line: 1">ApplicationInfo ai = getPackageManager().getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA);
Bundle bundle = ai.metaData;
String myApiKey = bundle.getString("com.miapp.usuario");</pre>
Para un **&lt;meta-data&gt;** dentro de un **&lt;receiver&gt;** usaríamos **getReceiverInfo()** y así sucesivamente.

Un truco que he aprendido es, si quieres poner dos iconos diferentes en el launcher de android para abrir tu app y que realmente solo necesitas que se abra la misma activity inicial pero con diferente parámetro, puedes usar un **&lt;activity-alias&gt;** y un **&lt;meta-data&gt;** para pasar ese parámetro.
<pre class="brush: xml; gutter: true; first-line: 1">&lt;activity
    android:name=".MainActivity"&gt;
    &lt;intent-filter&gt;
        &lt;action android:name="android.intent.action.MAIN" /&gt;
        &lt;category android:name="android.intent.category.LAUNCHER" /&gt;
    &lt;/intent-filter&gt;
&lt;/activity&gt;
&lt;activity-alias
    android:name=".MainActivityWithParameter"
    android:targetActivity=".MainActivity"&gt;
    &lt;intent-filter&gt;
        &lt;action android:name="android.intent.action.MAIN" /&gt;
        &lt;category android:name="android.intent.category.LAUNCHER" /&gt;
    &lt;/intent-filter&gt;
    &lt;meta-data android:name="com.miapp.specialparameter"
        android:value="true" /&gt;
 &lt;/activity-alias&gt;</pre>
Y luego en el onCreate o donde quieras del MainActivity.java, leer si existe este parámetro con **getBoolean("com.miapp.specialparameter",false);** y hacer una cosa u otra según esté presente  o no.

Espero que os haya gustado este mini tutorial y si tenéis preguntas os intentaré contestar aquí, y si no, a [StackOverflow](http://www.stackoverflow.com)!
