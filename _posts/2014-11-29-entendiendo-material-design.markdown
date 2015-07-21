---
layout: post
title: Entendiendo Material Design
date: '2014-11-29 11:00:00'
tags:
  - Artículos
---

[![materialdesign_introduction](http://androcode.es/wp-content/uploads/2015/02/materialdesign_introduction_shk3ov-1024x550.png)](http://androcode.es/wp-content/uploads/2015/02/materialdesign_introduction_shk3ov.png)

_"Material design es un lenguaje visual creado para nuestros usuarios que sintetiza los principios clásicos del buen diseño con la innovación y posibilidad de la tecnología y la ciencia, [material design."](http://www.google.com/design/spec/material-design/introduction.html#)_

###### Material como una metáfora

Material design está motivado por el estudio del comportamiento de las superficies, papel y tinta.

Los fundamentos de la superficie y la luz entrañan la esencia para explicar los movimientos de los objetos, como interactúan y como se transforman.

[![materialdesign_principles_metaphor](http://androcode.es/wp-content/uploads/2015/02/materialdesign_principles_metaphor1_morr1c.png)](http://androcode.es/wp-content/uploads/2015/02/materialdesign_principles_metaphor1_morr1c.png)


###### Material es gráfico e intencional

Determinadas opciones de color, tipografías y espacios en blanco puestos de forma intencionada, ayudan a enfatizar las funcionalidades principales de forma evidente además de proporcionar puntos de referencia para el usuario.

[![intentional](http://androcode.es/wp-content/uploads/2015/02/intentional_qgerzi-1024x1024.png)](http://androcode.es/wp-content/uploads/2015/02/intentional_qgerzi.png)

<!--more-->

## Movimiento

Los objetos se presentan al usuario sin romper la continuidad de una experiencia, reorganizándose y transformándose, cada aplicación cuenta una historia a través del diseño.

[![pixate](http://androcode.es/wp-content/uploads/2015/02/pixate_jcdowa.gif)](http://androcode.es/wp-content/uploads/2015/02/pixate_jcdowa.gif)

## Colores

La especificación de Material Design hace hincapié en sombras atrevidas y en las luces, en colores inesperados y vibrantes, por ello la propia especificación provee [una paleta de colores que se pueden usar y combinar.](http://www.google.com/design/spec/style/color.html#color-color-palette)

De una forma muy sencilla se pueden especificar los colores de todos los componentes, barra de navegación, color de acento y demás bajo la versión 21 del framework, o bien con la librería de compatibilidad AppCompat.

[![Screen Shot 2014-11-25 at 20.56.30](http://androcode.es/wp-content/uploads/2015/02/Screen-Shot-2014-11-25-at-20.56.30_rct2ey-1024x1014.png)](http://androcode.es/wp-content/uploads/2015/02/Screen-Shot-2014-11-25-at-20.56.30_rct2ey.png)

Únicamente modificando el _styles.xml_ bajo la v21 se puede conseguir los colores de la imagen
<pre class="brush: xml; gutter: true; first-line: 1">&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;resources&gt;
    &lt;color name="theme_primary"&gt;#48C2F9&lt;/color&gt;
    &lt;color name="theme_dark"&gt;#18B5F9&lt;/color&gt;
    &lt;color name="theme_accent"&gt;#FFCB00&lt;/color&gt;
    &lt;color name="theme_components"&gt;#FFB400&lt;/color&gt;
    &lt;color name="theme_wbackgound"&gt;#F5F5F5&lt;/color&gt;

    &lt;!-- Base application theme. --&gt;
    &lt;style name="AppTheme" parent="android:Theme.Material.Light"&gt;
        &lt;item name="android:colorPrimary"&gt;@color/theme_primary&lt;/item&gt;
        &lt;item name="android:colorPrimaryDark"&gt;@color/theme_dark&lt;/item&gt;
        &lt;item name="android:navigationBarColor"&gt;@color/theme_primary&lt;/item&gt;
        &lt;item name="android:colorAccent"&gt;@color/theme_accent&lt;/item&gt;
        &lt;item name="android:colorControlActivated"&gt;@color/theme_components&lt;/item&gt;
        &lt;item name="android:colorControlNormal"&gt;@color/theme_accent&lt;/item&gt;
        &lt;item name="android:windowBackground"&gt;@color/theme_wbackgound&lt;/item&gt;
    &lt;/style&gt;
&lt;/resources&gt;</pre>


## Palette

_Palette_ es una librería incluída en la librería de compatibilidad v7, que permite extraer colores de una imagen, _Palette_ extrae ciertos perfiles con un número determinado de colores, la extracción de colores dependiendo del número de colores es una operación costosa, por lo que debería no usarse en el hilo principal, por ello se proveen métodos asíncronos para esta tarea.

**Para importar la librería:**
<pre class="brush: java; gutter: true; first-line: 1">dependencies {
    compile 'com.android.support:palette-v7:21.0.0'
}</pre>
**Para conseguir la paleta:**
<pre class="brush: java; gutter: true; first-line: 1">Palette.generateAsync(bitmap, new Palette.PaletteAsyncListener() {
       @Override
       public void onGenerated(Palette palette) {

            bookTitle.setTextColor(palette.getLightVibrantColor(defaultTextColor));
            bookAuthor.setTextColor(palette.getVibrantColor(defaultTextColor));
      }
});</pre>
![](https://camo.githubusercontent.com/2b430a3cc1181af701fbc920d32b46eada33867a/68747470733a2f2f6c68332e676f6f676c6575736572636f6e74656e742e636f6d2f2d745376657a7157483553632f56476e707272316b3144492f4141414141414141784c632f55372d6a4e32416d35796f2f77313230302d68313036342d6e6f2f70616c657474655f616461707465722e676966)

## 

## Elevación

Material design introduce un nuevo concepto en cuanto al diseño en android, la elevación para los elementos de la interfaz gráfica.

La elevación ayuda a los usuarios a entender la importancia de cada elemento y centrar su atención en la tarea principal.

[![elevation_sample](http://androcode.es/wp-content/uploads/2015/02/elevation_sample_esatql.gif)](http://androcode.es/wp-content/uploads/2015/02/elevation_sample_esatql.gif)

Este ejemplo se puede conseguir facilmente añadiendo un _StateListAnimator_ que defina las animaciones en función del estado de una vista, de tal forma que tan solo con una línea en vuestro _layout_ se pude conseguir una animación suave que dará el foco a la vista que se pretenda mostrar.

Este ejemplo se ha hecho únicamente con el siguiente _layout_ y _selector_:

  **Selector, translation_selector:**

<pre class="brush: xml; gutter: true; first-line: 1; highlight: [31,42,54]">&lt;FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    xmlns:card_view="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#EAEAEA"
    &gt;

    &lt;android.support.v7.widget.Toolbar
        android:layout_height="wrap_content"
        android:layout_width="match_parent"
        android:background="?android:colorPrimary"
        android:minHeight="?attr/actionBarSize"
        android:elevation="5dp"
        /&gt;

    &lt;LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:layout_gravity="center_vertical"
        android:layout_marginLeft="@dimen/activity_horizontal_margin"
        android:layout_marginRight="@dimen/activity_horizontal_margin"
        &gt;

        &lt;android.support.v7.widget.CardView
            android:layout_gravity="center"
            android:layout_width="100dp"
            android:layout_height="96dp"
            android:layout_marginTop="16dp"
            android:stateListAnimator="@drawable/translation_selector"
            android:elevation="2dp"
            android:clickable="true"
            card_view:cardCornerRadius="4dp"
            /&gt;

        &lt;android.support.v7.widget.CardView
            android:layout_gravity="center"
            android:layout_width="100dp"
            android:layout_height="96dp"
            android:layout_marginTop="16dp"
            android:stateListAnimator="@drawable/translation_selector"
            android:elevation="2dp"
            android:clickable="true"
            card_view:cardCornerRadius="4dp"
            /&gt;

        &lt;android.support.v7.widget.CardView
            android:layout_gravity="center"
            android:layout_width="100dp"
            android:layout_height="96dp"
            android:layout_marginTop="16dp"
            android:layout_marginBottom="@dimen/activity_vertical_margin"
            android:stateListAnimator="@drawable/translation_selector"
            android:elevation="2dp"
            android:clickable="true"
            card_view:cardCornerRadius="4dp"
            /&gt;

    &lt;/LinearLayout&gt;
&lt;/FrameLayout&gt;</pre>
**Selector, translation_selector:**
<pre class="brush: java; gutter: true; first-line: 1">&lt;selector xmlns:android="http://schemas.android.com/apk/res/android"&gt;
    &lt;item android:state_pressed="true"&gt;
        &lt;set&gt;
            &lt;objectAnimator android:propertyName="translationZ"
                android:duration="@android:integer/config_shortAnimTime"
                android:valueTo="10dp"
                android:valueType="floatType"/&gt;
        &lt;/set&gt;
    &lt;/item&gt;
    &lt;item
        android:state_pressed="false"
        &gt;
        &lt;set&gt;
            &lt;objectAnimator android:propertyName="translationZ"
                android:duration="100"
                android:valueTo="2dp"
                android:valueType="floatType"/&gt;
        &lt;/set&gt;
    &lt;/item&gt;
&lt;/selector&gt;</pre>

## Transiciones

Las transiciones fueron introducidas con android KitKat 4.4, con Lollipop y Material Design toman un papel muy importante a la hora de diseñar la experiencia de usuario, el propio tema de material añade transiciones para sus actividades, incluyendo la capacidad de utilizar elementos visuales compartidos y transiciones predefinidas como _Explode, Fade_.

Es tan sencillo como configurar el nombre de la vista de una actividad a la otra y especificar, antes de cambiar de actividad cuál es el elemto compartido.

**Layout 1**
<pre class="brush: xml; gutter: true; first-line: 1; highlight: [9]">    &lt;Button
        android:id="@+id/fab_button"
        android:layout_width="@dimen/fab_size"
        android:layout_height="@dimen/fab_size"
        android:layout_marginRight="@dimen/activity_horizontal_margin"
        android:layout_below="@+id/holder_view"
        android:layout_marginTop="-26dp"
        android:layout_alignParentEnd="true"
        android:transitionName="fab"
        android:background="@drawable/ripple_round"
        android:stateListAnimator="@anim/fab_anim"
        android:elevation="5dp"
        /&gt;
      ...</pre>
En este caso la vista compartida es un _floating action button_, el atributo importante en este caso es el de _android:transitionName="fab"_ ya que es el nombre que identifica al a vista en la transición de las actividades

**Actividad 2**:
<pre class="brush: java; gutter: true; first-line: 1">        ...
        Intent i  = new Intent (TransitionFirstActivity.this, 
            TransitionSecondActivity.class);

        ActivityOptions transitionActivityOptions = ActivityOptions.makeSceneTransitionAnimation(
            TransitionFirstActivity.this, Pair.create(fabButton, "fab"));

        startActivity(i, transitionActivityOptions.toBundle());
       ...</pre>
**Layout 2**
<pre class="brush: java; gutter: true; first-line: 9">    &lt;Button
        android:id="@+id/fab_button"
        android:layout_width="@dimen/fab_size"
        android:layout_height="@dimen/fab_size"
        android:layout_marginRight="@dimen/activity_horizontal_margin"
        android:layout_centerHorizontal="true"
        android:layout_alignParentBottom="true"
        android:background="@drawable/ripple_round"
        android:stateListAnimator="@anim/fab_anim"
        android:transitionName="fab"
        android:elevation="5dp"/&gt;</pre>
Todo esto se ilustra de la siguiente forma:

[![68747470733a2f2f6c68342e676f6f676c6575736572636f6e74656e742e636f6d2f2d646d44466f4637633555592f564437374e73464b386b492f4141414141414141754c4d2f4d74537150384a6f51636f2f773238322d683439392d6e6f2f323031342d31302d313625324230305f35315f33342e6769](http://androcode.es/wp-content/uploads/2015/02/68747470733a2f2f6c68342e676f6f676c6575736572636f6e74656e742e636f6d2f2d646d44466f4637633555592f564437374e73464b386b492f4141414141414141754c4d2f4d74537150384a6f51636f2f773238322d683439392d6e6f2f323031342d31302d313625324230305f35315f33342e6769_se68d9.gif)](http://androcode.es/wp-content/uploads/2015/02/68747470733a2f2f6c68342e676f6f676c6575736572636f6e74656e742e636f6d2f2d646d44466f4637633555592f564437374e73464b386b492f4141414141414141754c4d2f4d74537150384a6f51636f2f773238322d683439392d6e6f2f323031342d31302d313625324230305f35315f33342e6769_se68d9.gif)

## Ripples

Android Lollipop, siguiendo con los principios de material design, provee un feedback visual al usuario para que sepa que ha ocurrido algo, toda acción conlleva una reacción, esto hasta ahora se venía haciendo usando _state list drawables._

El efecto del _Ripple_, se puede comparar como una expansión en una superficie líquida, una expansión desde el punto donde se ha tocado.

Los Ripples, son un nuevo tipo de Drawable (RippleDrawable), para usarlo es tan sencillo como asignarlo como _background_ a una vista.

[![ripples](http://androcode.es/wp-content/uploads/2015/02/ripples_vrwyiv.gif)](http://androcode.es/wp-content/uploads/2015/02/ripples_vrwyiv.gif)

###### Referencias y recursos:

[Material design android samples](https://github.com/saulmm/Android-Material-Example)

[Material design spec](http://www.google.com/design/spec/material-design/introduction.html)

[Defining custom animations](https://developer.android.com/training/material/animations.html)

[What material means to android - David Gonzalez](https://speakerdeck.com/malmstein/what-material-design-means-to-android)

[Material design checklist](http://android-developers.blogspot.com.es/2014/10/material-design-on-android-checklist.html)

[Creating apps with material design](http://developer.android.com/training/material/index.html)

[Material design bytes](https://www.youtube.com/playlist?list=PLOU2XLYxmsIJFcNKpAV9B_aQmz2h68fw_)

[Creating apps with material design](http://developer.android.com/training/material/index.html)