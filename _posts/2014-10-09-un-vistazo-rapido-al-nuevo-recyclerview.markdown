---
layout: post
title: Un vistazo rápido al nuevo RecyclerView
date: '2014-10-09 10:00:00'
---

[![lpreview](http://androcode.es/wp-content/uploads/2015/02/lpreview_smlprn.jpg)](http://androcode.es/wp-content/uploads/2015/02/lpreview_smlprn.jpg)

Con la versión preview de _[android L](http://developer.android.com/preview/index.html "android L"),_ Google ha presentado dos nuevos [_Widgets_](https://developer.android.com/preview/material/ui-widgets.html), _RecyclerView_ y _CardView_, este artículo tratará el primero, el _RecyclerView_.

Este nuevo _Widget_ entra en juego cuando el propósito es mostrar gran número de _Views_ repetidamente, listas, grids, etc..., tantas que no entran en la pantalla.

_RecyclerView_ implementa un sistema para llevar a cabo esta tarea, de forma sencilla y eficiente.

**<span style="font-size: medium">Proyecto de ejemplo</span>**

[![rv_demo](http://androcode.es/wp-content/uploads/2015/02/rv_demo_b2udsp.gif)](http://androcode.es/wp-content/uploads/2015/02/rv_demo_b2udsp.gif)

Todos los ejemplos de código que se muestran en este artículo se pueden encontrar en este proyecto en GitHub de forma funcional:

[https://github.com/saulmm/RecyclerView-demo.git](https://github.com/saulmm/RecyclerView-demo.git)

<!--more-->

**<span style="font-size: medium">La API de RecyclerView</span>**

A diferencia del _ListView,_ _GridView,_ etc... el _RecyclerView_ se dedica únicamente a lo que su nombre indica, reciclar, reutilizar recursos y evitar el uso reiterado del costoso [_findViewById_](http://developer.android.com/reference/android/app/Activity.html#findViewById(int)), no se preocupa del aspecto visual, para ello está el _LayoutManager._

Una clase una tarea, esa es la filosofía que sigue la _API_ del _RecyclerView,_ un paquete de clases  internas cada una con una responsabilidad:

*   **_Adapter_**
*   _**ViewHolder**_
*   _**LayoutManager**_
*   _**ItemDecoration**_
*   **_ItemAnimator_**
**<span style="font-size: medium">Adapter</span>**

Esta clase se encarga de crear las _Views_ necesarias para cada elemento del _RecyclerView_, además, está muy unida al _ViewHolder_, teniendo que ser indicado en la declaración de la clase, muchos pensaréis que esto no es nuevo, que Google ya aconsejara este [patrón](http://developer.android.com/training/improving-layouts/smooth-scrolling.html "patrón") tiempo atrás, esta vez fuerza a utilizarlo, teniendo que ser indicado en la implementación del _Adapter_, un paso adelante, sin duda.

El método _OnCreateViewHolder_ inicializa el _ViewHolder_
<pre class="brush: java; gutter: true; first-line: 17">    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parentViewGroup, int i) {

        View rowView = LayoutInflater.from (parentViewGroup.getContext())
            .inflate(R.layout.list_basic_item, parentViewGroup, false);

        return new ViewHolder (rowView);
    }</pre>
El método _onBindViewHolder(ViewHolder viewholder, int position)_ se usa para configurar el contenido de las _Views_
<pre class="brush: java; gutter: true; first-line: 25">    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {

        final SampleModel rowData = sampleData.get(position);
        viewHolder.textViewSample.setText(rowData.getSampleText());
        viewHolder.itemView.setTag(rowData);
    }</pre>
<span style="font-size: medium">**ViewHolder**</span>

Como venía diciendo, el patrón _ViewHolder_ no es nada nuevo, de hecho Google, lo lleva recomendando desde hace tiempo, se puede pensar en el como un _cache_ de las vistas, pudiendo reutilizarlas en vez de crearlas nuevamente.
<pre class="brush: java; gutter: true; first-line: 39">    
   @Override
   public static class ViewHolder extends RecyclerView.ViewHolder {

        private final TextView textViewSample;

        public ViewHolder(View itemView) {
            super(itemView);

            textViewSample = (TextView) itemView.findViewById(
                R.id.textViewSample);
        }
    }</pre>
<span style="font-size: medium">**LayoutManager**</span>

El _LayoutManager_ se encarga del layout de todas las vistas dentro del _RecyclerView_, concretando con el _LinearLayoutManager_, permite entre otros acceder a elementos mostrados en la pantalla como el primer elemento, último, o por ejemplo, el último completamente visible, esto de forma horizontal o vertical, en el ejemplo se ha utilizado la disposición en vertical.
<pre class="brush: java; gutter: true; first-line: 19">    

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(mLayoutManager);</pre>
<span style="font-size: medium">**ItemDecorator**</span>

Otro eslabón importante, son los llamados _ItemDecorator_, estos permiten modificar los elementos del RecycleView, este además, ofrece además ofrece un elemento llamado insets (márgenes) que pueden aplicarse a las vistas sin necesidad de modificar los parámetros del layout.

En el ejemplo, se muestra como se usan los _ItemDecorators_ para dibujar un pequeño _Divider_ entre los elementos del _RecyclerView_:
<pre class="brush: java; gutter: true; first-line: 19">    
package saulmm.com.recyclerviewproject;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.support.v7.widget.RecyclerView;
import android.view.View;

public class SampleDivider extends RecyclerView.ItemDecoration {

    private static final int[] ATTRS = { android.R.attr.listDivider };

    private Drawable mDivider;

    public SampleDivider(Context context) {
        TypedArray a = context.obtainStyledAttributes(ATTRS);
        mDivider = a.getDrawable(0);
        a.recycle();

    }

    @Override
    public void onDrawOver(Canvas c, RecyclerView parent) {

        int left = parent.getPaddingLeft();
        int right = parent.getWidth() - parent.getPaddingRight();

        int childCount = parent.getChildCount();

        for (int i = 0; i &lt; childCount; i++) {

            View child = parent.getChildAt(i);

            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) child
                    .getLayoutParams();

            int top = child.getBottom() + params.bottomMargin;
            int bottom = top + mDivider.getIntrinsicHeight();

            mDivider.setBounds(left, top, right, bottom);
            mDivider.draw(c);
        }
    }
}</pre>
**ItemAnimator**

La clase _ItemAnimator_ como su nombre indica, anima el _RecyclerView_ cuando se añade y se elimina un elemento, el _RecyclerView_ utiliza un _ItemAnimator_ por defecto.

El _RecyclerView_ ha de saber cuando se inserta un elemento o se elimina, con elementos como _ListViews_, _GridViews_, etc... esto se conseguía llamando al método _notifyDataSetChanged()_, a nivel de performance, es bastante costoso, ya que redibuja todos los items en el _layout_, lo propio con el _RecyclerView_ es usar el método _notifyItemInserted()_ para añadir, y _notifyItemRemoved()_ para eliminar, actualizando solo la parte apropiada.

**Referencias:**

[Wolfram RittMeyer - A first Glance at Android's RecyclerView](http://www.grokkingandroid.com/first-glance-androids-recyclerview/)

[Wires are obsolete - Building a RecyclerView](http://wiresareobsolete.com/2014/09/recyclerview-layoutmanager-2/)

[Android L - Reference](http://developer.android.com/preview/reference.html)