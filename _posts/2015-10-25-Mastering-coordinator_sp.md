---
layout: post
title: Perfeccionando el Coordinator Layout
date: '2015-10-28 11:00:00'
author: saulmm
tags:
- Artículos
---

En el [Google I/O 15](https://www.youtube.com/watch?v=7V-fIGMDsmE), Google lanzó una librería de diseño que implementa varios componentes extrictamente relacionados con la [especificación de Material Design](https://www.google.com/design/spec/material-design/introduction.html), entre estos se encuentran nuevos _ViewGroups_ como el `AppbarLayout`, `CollapsingToolbarLayout` y `CoordinatorLayout`.

Bien combinados y configurados estos _Viewgroups_ pueden ser muy poderosos, por lo tanto he decidido a escribir un post con diferentes configuraciones y reflexiones. 

<br>
## CoordinatorLayout

Como su propio nombre indica, el objetivo y filosofía de este _ViewGroup_ es el de **coordinar** las vistas de su interior.

Veamos la siguiente imagen:

![](http://androcode.es/wp-content/uploads/2015/10/simple_coordinator.gif)

<br>
En este ejemplo se puede apreciar como las vistas se coordinan entre sí, a simple vista podemos ver que algunas vistas **dependen** de otras (hablaremos de esto más adelante), esta sería la estructura más sencilla a la hora de utilizar el `CoordinatorLayout`
<br>

```xml
<?xml version="1.0" encoding="utf-8"?>

<android.support.design.widget.CoordinatorLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@android:color/background_light"
    android:fitsSystemWindows="true"
    >

    <android.support.design.widget.AppBarLayout
        android:id="@+id/main.appbar"
        android:layout_width="match_parent"
        android:layout_height="300dp"
        android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar"
        android:fitsSystemWindows="true"
        >

        <android.support.design.widget.CollapsingToolbarLayout
            android:id="@+id/main.collapsing"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            app:layout_scrollFlags="scroll|exitUntilCollapsed"
            android:fitsSystemWindows="true"
            app:contentScrim="?attr/colorPrimary"
            app:expandedTitleMarginStart="48dp"
            app:expandedTitleMarginEnd="64dp"
            >

            <ImageView
                android:id="@+id/main.backdrop"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:scaleType="centerCrop"
                android:fitsSystemWindows="true"
                android:src="@drawable/material_flat"
                app:layout_collapseMode="parallax"
                />

            <android.support.v7.widget.Toolbar
                android:id="@+id/main.toolbar"
                android:layout_width="match_parent"
                android:layout_height="?attr/actionBarSize"
                app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
                app:layout_collapseMode="pin"
                />
        </android.support.design.widget.CollapsingToolbarLayout>
    </android.support.design.widget.AppBarLayout>

    <android.support.v4.widget.NestedScrollView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:layout_behavior="@string/appbar_scrolling_view_behavior"
        >

        <TextView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:textSize="20sp"
            android:lineSpacingExtra="8dp"
            android:text="@string/lorem"
            android:padding="@dimen/activity_horizontal_margin"
            />
    </android.support.v4.widget.NestedScrollView>

    <android.support.design.widget.FloatingActionButton
        android:layout_height="wrap_content"
        android:layout_width="wrap_content"
        android:layout_margin="@dimen/activity_horizontal_margin"
        android:src="@drawable/ic_comment_24dp"
        app:layout_anchor="@id/main.appbar"
        app:layout_anchorGravity="bottom|right|end"
        />
</android.support.design.widget.CoordinatorLayout>
```

Si examinamos el esqueleto de esta estructura parece algo más facil, este `CoordinatorLayout` tiene únicamente tres hijos, un `AppbarLayout` y una vista _scrolleable_ y un `FloatingActionBar`.

```xml
<CoordinatorLayout>
    <AppbarLayout/>
    <scrollableView/>
    <FloatingActionButton/>
</CoordinatorLayout>
```


<br>
## AppBarLayout

Básicamente un `AppBarLayout` es un `LinearLayout` con esteroides, los hijos se colocan en forma vertical, existen ciertos parámetros con los que los hijos podrán aparecer y desaparecer de distinta manera en función del _scroll_ en el contenido. 

Puede sonar algo confuso al principio, por eso creo que una imagen vale más que mil palabras y si es un .gif, todavía es mejor:

![](http://androcode.es/wp-content/uploads/2015/10/2015-10-27-03_51_37.gif)

El `AppBarLayout` en este caso es la vista coloreada de azul, colocada debajo de la imagen que se colapsa, contiene un `Toolbar`, un `LinearLayout` con el título y un subtitulo y un `TabLayout.

Podemos comportar el comportamiento de los hijos directos de un `AppbarLayout`con el parámetro: `layout_scrollFlags`. El valor: `scroll` esta presente en casi todas las vistas, si no fuera especificado en ninguna, los componentes dentro del `AppbarLayout` quedarían estáticos permitiendo que el contenido (scrollable) pase por detrás de esta. 

Con el parámetro: `snap`, evitamos caer en medios estados y siempre se oculte o muestre el alto total de la vista. El `LinearLayout` que contiene el texto será mostrado siempre que el usuario haga scroll hacia arriba (`enterAlways`), y el `TabLayout`, siempre quedara a la vista, ya que no se ha especificado ninguna bandera.

El verdadero poder del `AppbarLayout` radica en la correcta combinación de los parámetros de scroll:

```xml
<AppBarLayout>
    <CollapsingToolbarLayout
        app:layout_scrollFlags="scroll|snap"
        />

    <Toolbar
        app:layout_scrollFlags="scroll|snap"
        />

    <LinearLayout
        android:id="+id/title_container"
        app:layout_scrollFlags="scroll|enterAlways"
        />

    <TabLayout /> <!-- no flags -->
</AppBarLayout>
```

Estos son los parámetros disponibles, de acuerdo a la documentación en Google Developers. De todos modos, mi recomendación es siempre jugar con el ejemplo. El repositorio de Github con estas implementaciones se encuentra al final del artículo.

                                                                         
`SCROLL_FLAG_ENTER_ALWAYS`:
When entering (scrolling on screen) the view will scroll on any downwards scroll event, regardless of whether the scrolling view is also scrolling. 

`SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED`: An additional flag for 'enterAlways' which modifies the returning view to only initially scroll back to it's collapsed height.                      

`SCROLL_FLAG_EXIT_UNTIL_COLLAPSED`: When exiting (scrolling off screen) the view will be scrolled until it is 'collapsed'.                              

`SCROLL_FLAG_SCROLL`: The view will be scroll in direct relation to scroll events.                                                                                        
`SCROLL_FLAG_SNAP`: Upon a scroll ending, if the view is only partially visible then it will be snapped and scrolled to it's closest edge.                       
<br>
## CoordinatorLayout Behaviors

Hagamos una pequeña prueba, vayamos a Android Studio (>= 1.4) y creemos un proyecto con la siguiente plantilla _Scrolling Activity_, sin tocar nada, lo compilamos y esto será lo que nos encontremos:

![](http://androcode.es/wp-content/uploads/2015/10/2015-10-27-03_59_27.gif)
_He quitado el titulo de la actividad para aclarar el ejemplo_

<br>
Si revisamos el código generado, tanto ni en los layouts como en las clases java no encontraremos nada en cuanto a una animación de _scale_ al hacer scroll. ¿Por qué?

 La respuesta está en el propio código fuente del `FloatingActionButton`, desde que Android Studio en su v1.2 incluye un decompilador java, `ctrl/cmd + click` en el nombre de la clase y ya tenemos el source:

```java
/*
 * Copyright (C) 2015 The Android Open Source Project
 *
 *  Floating action buttons are used for a
 *  special type of promoted action. 
 *  They are distinguished by a circled icon 
 *  floating above the UI and have special motion behaviors 
 *  related to morphing, launching, and the transferring anchor point.
 * 
 *  blah.. blah.. 
 */
@CoordinatorLayout.DefaultBehavior(
    FloatingActionButton.Behavior.class)
public class FloatingActionButton extends ImageButton {
    ...

    public static class Behavior 
        extends CoordinatorLayout.Behavior<FloatingActionButton> {

        private boolean updateFabVisibility(
           CoordinatorLayout parent, AppBarLayout appBarLayout, 
           FloatingActionButton child {

           if (a long condition) {
                // If the anchor's bottom is below the seam, 
                // we'll animate our FAB out
                child.hide();
            } else {
                // Else, we'll animate our FAB back in
                child.show();
            }
        }
    }

    ...
}
```

Quien se está encargando de la animación de _scale_ es un elemento llamado `Behavior`, extensión de `CoordinatorLayout.Behavior<FloatingAcctionButton>`, el cuál dependiendo de algunos factores, muestra el FAB o no. Interesante, ¿verdad?.

###SwipeDismissBehavior

Sigamos buceando, si buscamos dentro del paquete de la _design support library_, nos encontraremos con una clase pública llamada: `SwipeDismissBehavior`. Con este `Behavior` podremos muy fácilmente implementar la funcionalidad de _swipe to dismiss_:

![](http://androcode.es/wp-content/uploads/2015/10/hammerheadLMY48Msaulmm10242015161844.gif)


```java
@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_swipe_behavior);
    mCardView = (CardView) findViewById(R.id.swype_card);

    final SwipeDismissBehavior<CardView> swipe 
        = new SwipeDismissBehavior();

        swipe.setSwipeDirection(
            SwipeDismissBehavior.SWIPE_DIRECTION_ANY);

        swipe.setListener(
            new SwipeDismissBehavior.OnDismissListener() {
            @Override public void onDismiss(View view) {
                Toast.makeText(SwipeBehaviorExampleActivity.this,
                    "Card swiped !!", Toast.LENGTH_SHORT).show();
            }

            @Override 
            public void onDragStateChanged(int state) {}
        });

        LayoutParams coordinatorParams = 
            (LayoutParams) mCardView.getLayoutParams();
        
        coordinatorParams.setBehavior(swipe);
    }
```

## Custom Behaviors

Crear un `Behavior` personalizado no es tan dificil como pueda parecer, únicamente hay que tener en cuenta dos elementos: hijo y dependencia. 

<br>
![](http://androcode.es/wp-content/uploads/2015/10/Screen-Shot-2015-10-27-at-04.42.37-e1445917457348.png)
<br>

El hijo es la vista que realzará el comportamiento, la dependencia será quien sirva de disparador para interactuar con el elemento hijo, en el siguiente ejemplo el hijo sería el `ImageView` del perro y la dependencia el `Toolbar`, de tal modo que siempre que se mueva el `Toolbar` se moverá el `ImageView`.

![](http://androcode.es/wp-content/uploads/2015/10/2015-10-27-04_30_50.gif)

Para crear un _behavior_ personalizado, lo primero es extender de: `CoordinatorLayout.Behavior<T>`, siendo `T` la clase a la que pertenecerá la vista que nos interese coordinar, posteriormente hay que sobreescribir dos métodos:

- layoutDependsOn
- onDependentViewChanged

El método `layoutDependsOn` se llamará cada vez que algo ocurra algo en el layout, lo que tendremos que hacer será devolver `true` se identifique nuestra dependencia, por ejemplo cuando se haya hecho scroll, de esa forma podremos hacer que nuestra vista hija reaccione en consecuencia.

```java
   @Override
   public boolean layoutDependsOn(       
      CoordinatorLayout parent, 
      CircleImageView, child, 
      View dependency) {
   
      return dependency instanceof Toolbar; 
  } 
```

Siempre que se devuelva `true` se llamará el segundo método: `onDependentViewChanged`, aquí es donde debemos implementar las animaciones, translaciones o movimientos aportados en nuestra vista hija.

```java
   public boolean onDependentViewChanged( 
      CoordinatorLayout parent, 
      CircleImageView avatar, 
      View dependency) { 
      
      modifyAvatarDependingDependencyState(avatar, dependency);
   }

   private void modifyAvatarDependingDependencyState(
    CircleImageView avatar, View dependency) {
        //  avatar.setY(dependency.getY());
        //  avatar.setBlahBlat(dependency.blah / blah);
    } 
```

Todo junto

```java
 public static class AvatarImageBehavior 
   extends  CoordinatorLayout.Behavior<CircleImageView> {

   @Override
   public boolean layoutDependsOn( 
    CoordinatorLayout parent, 
    CircleImageView, child, 
    View dependency) {
   
       return dependency instanceof Toolbar; 
  }      

  public boolean onDependentViewChanged(       
    CoordinatorLayout parent, 
    CircleImageView avatar, 
    View dependency) { 
      modifyAvatarDependingDependencyState(avatar, dependency);
   }

  private void modifyAvatarDependingDependencyState(
    CircleImageView avatar, View dependency) {
        //  avatar.setY(dependency.getY());
        //  avatar.setBlahBlat(dependency.blah / blah);
    }    
}
```

## Resources

## Resources

- [Coordinator Behavior Example](https://github.com/saulmm/CoordinatorBehaviorExample) - Github
- [Coordinator Examples](https://github.com/saulmm/CoordinatorExamples) - Github
- [Introduction to coordinator layout on Android](https://lab.getbase.com/introduction-to-coordinator-layout-on-android/) - Grzesiek Gajewski

