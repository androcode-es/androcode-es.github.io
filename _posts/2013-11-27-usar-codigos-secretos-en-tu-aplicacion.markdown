---
layout: post
title: Usar códigos secretos en tu aplicación
date: '2013-11-27 11:00:00'
author: rafa
tags:
- Snippets
---

[![androcode_secret_code](http://androcode.es/wp-content/uploads/2015/02/androcode_secret_code_rmtwnf.png)](http://androcode.es/wp-content/uploads/2015/02/androcode_secret_code_rmtwnf.png)

Estoy seguro de que todos habréis usado alguna vez un "código secreto" en vuestro móvil. Son los códigos que al introducirlos en el teclado del "teléfono" (el de llamar, que los smartphones también hacen eso, eh) permiten acceder a alguna función especial, como ver el IMEI _(*#06#)_ o información del teléfono _(*#*#4636#*#*)_. Pero no queda ahí la cosa, porque podemos crear nuestros propios códigos, y vamos a ver cómo.

<!--more-->

###### ¿De dónde viene esto?

[![protips_original_recorte](http://androcode.es/wp-content/uploads/2015/02/protips_original_recorte_bg3m30.png)](http://androcode.es/wp-content/uploads/2015/02/protips_original_recorte_bg3m30.png)

Bueno, de dónde viene realmente no lo sé, pero sí os diré cómo me enteré yo de su existencia. Hace unos (muchos) meses estaba preparando un teléfono viejo para dárselo a alguien, ya sabéis, configurar algunas cosas e instalar aplicaciones básicas. Como tenía versión 2.3, sin duda le puse en la pantalla principal el widget de bienvenida que traía Android por aquel entonces, ¿lo recordáis? Pero tuve una mejor idea: modificar el widget para poner consejos y mensajes más personales. Así de detallista soy :p. Así que me bajé el [código fuente](https://android.googlesource.com/platform/packages/apps/Protips/+/master) (gracias, Open Source), me creé un proyecto con él y empecé a cambiar cosas. Sorpresa la mía al ver en el AndroidManifest.xml un Intent-Filter que no había visto antes:

<pre class="brush: xml; gutter: true; first-line: 1">&lt;receiver android:name=".ProtipWidget" android:label="@string/widget_name"&gt;
            &lt;intent-filter&gt;
                &lt;action android:name="android.appwidget.action.APPWIDGET_UPDATE" /&gt;
                &lt;action android:name="com.android.protips.NEXT_TIP" /&gt;
                &lt;action android:name="com.android.protips.HEE_HEE" /&gt;
            &lt;/intent-filter&gt;
            &lt;intent-filter&gt;
                &lt;action android:name="android.provider.Telephony.SECRET_CODE" /&gt;
                &lt;data android:scheme="android_secret_code" android:host="8477" /&gt;
            &lt;/intent-filter&gt;
            &lt;meta-data android:name="android.appwidget.provider" android:resource="@xml/widget_build" /&gt;
        &lt;/receiver&gt;</pre>

Ese _android.provider.Telephony.SECRET_CODE_ es bastante llamativo, ¿no? Con el número 8477 (que corresponde al [_Phoneword_](http://es.wikipedia.org/wiki/Phonewords) de "TIPS") en los datos y la acción perteneciente al paquete Telephony, no hay que ser un genio para deducir que ese código se introduce en el marcador del teléfono. Lo hice y... Voilà! Los consejos del widget cambiaron por completo:

[![protips__secret](http://androcode.es/wp-content/uploads/2015/02/protips__secret_vyez3e.png "Gracias por las capturas, mi viejo HTC Legend :)")](http://androcode.es/wp-content/uploads/2015/02/protips__secret_vyez3e.png)

¡Toma huevo de pascua! Como veis, al introducir el código los consejos originales cambian por unos en tono más de humor. Y como de costumbre en Android, si el widget puede nosotros también.

¿Por qué os cuento esto? Pues para que sirva de moraleja: **leyendo código fuente**, tanto de Android como de otros proyectos, **se aprende mucho**.

###### Déjate de rollos, cómo se hace

El funcionamiento de los códigos secretos propios no tiene misterio. En el anterior extracto de manifiesto tenéis la mitad del trabajo hecho. Sólo hay que añadir un Intent-Filter a nuestro AndroidManifest.xml con la acción android.provider.Telephony.SECRET_CODE, y con la especificación de esquema "android_secret_code" y nuestro número secreto como host. Hay que tener en cuenta que estos códigos se introducen en el dialer en formato *#*#código#*#*, pero nosotros aquí sólo especificamos el número.

La segunda parte es añadir el elemento que recibe ese Intent. Podría ser cualquiera, por ejemplo una Activity o un Broadcast Receiver que active cierta función en la aplicación. Una implementación básica podría ser:
<pre class="brush: java; gutter: true; first-line: 1">public class SecretCodeReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals("android.provider.Telephony.SECRET_CODE")) {
            String numero = intent.getData().getHost();
            if (numero.equals("732738")) {
                Toast.makeText(context, "¡Función chachipiruli altamente secreta desbloqueada!", Toast.LENGTH_SHORT).show();
            } else {
                // Podemos usar el mismo receiver para otros códigos distintos
            }
        }
    }
}</pre>
Y listo. Por supuesto las posibilidades no acaban aquí. Ya sabéis lo versátiles que son los Intents, así que posibilidades de explotar esta pequeña función hay infinitas. A mí se me ocurren varias aparte de los huevos de pascua y pantallas ocultas. ¿Y a vosotros? ¿Para qué usaríais los códigos secretos? ¿Los conocíais ya?
