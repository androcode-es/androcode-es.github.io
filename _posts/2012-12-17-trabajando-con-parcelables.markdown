---
layout: post
title: Trabajando con Parcelables
date: '2012-12-17 11:00:00'
tags:
- Tutoriales
---

Hola a todos! hoy me estreno en androcode.es con un artículo sobre tipos parcelables, si no sabes lo que son, hoy aprenderás para qué sirven y cómo implementarlos.
[![](http://androcode.es/wp-content/uploads/2015/02/decibels_zesjsx-300x201.png "teach")](http://androcode.es/wp-content/uploads/2015/02/decibels_zesjsx.png)

<!--more-->

Normalmente cuando queremos pasar un objeto entre actividades tenemos varias opciones, unas más elegantes y otras menos.

Tal vez lo primero que se nos ocurra sea guardar el objeto en un campo static de una de nuestras clases, y recuperarlo en la nueva actividad, pero este tipo de prácticas no están muy bien vistas ya que puedes incurrir en problemas de concurrencia, leaks de memoria, etc.

Puede que lo siguiente que se te ocurra sea implementar en el objeto la interfaz serializable. Esta solución no es mala para objetos pequeños pero en la práctica es muy lenta y si vamos a serializar un objeto complejo y grande, no es la mejor solución. Por eso el equipo de android decidió inventarse los tipos parcelables, que en la práctica es como escribir los tipos en un [Bundle](http://developer.android.com/reference/android/os/Bundle.html) y recuperarlos después. De echo el objeto Bundle implementa la interfaz Parcelable y cuando haces intent.putExtra("key","hello world"), estás escribiendo un Bundle asociado al intent, y cuando haces getIntent().getExtras() para leer, es un Bundle de donde lees.

Pero vamos a ver esto con más detalle y vamos a ver como podemos implementar la interfaz [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html) en nuestros objetos para pasarlos entre actividades o servicios de una manera rápida.  

Puedes descargarte el [código de ejemplo de github](https://github.com/ferdy182/Android-parcelable-example "ferdy182 en GitHub Android parcelable example") Lo primero es crearnos una clase que implemente la interfaz [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html)
```
package com.example.parcelable;

import android.os.Parcel;
import android.os.Parcelable;

public class Estudiante implements Parcelable {

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {

	}

}
```

Esto nos creará un par de métodos en la clase, describeContents, que en los ejemplos siempre ponen return 0; así que de momento no nos preocupamos, y el método writeToParcel que recibe un objeto Parcel de destino y un flag que puede ser 0 o [*PARCELABLE_WRITE_RETURN_VALUE*](http://developer.android.com/reference/android/os/Parcelable.html#PARCELABLE_WRITE_RETURN_VALUE).

Yo recomiendo añadir otro constructor al objeto que reciba un Parcel para recrearlo a partir de ahí y un método readFromParcel(Parcel in) para rellenar los campos del objeto y tenerlo más ordenado.

Además vamos a añadirle unos campos a la clase, porque una clase sin campos no vale para mucho ¿no?

```
package com.example.parcelable;

import java.util.List;

import android.os.Parcel;
import android.os.Parcelable;

public class Estudiante implements Parcelable {
	int fechaNacimiento;
	String nombreCompleto;
	boolean esHijoUnico;
	float[] notas;
	List&lt;Estudiante&gt; amigos;

	public Estudiante() {
		notas = new float[3];
		amigos = new ArrayList&lt;Estudiante&gt;();
	}

	public Estudiante(Parcel in) {
		notas = new float[3];
		amigos = new ArrayList&lt;Estudiante&gt;();
		readFromParcel(in);
	}

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {

	}

	private void readFromParcel(Parcel in) {

	}

}
```

Cómo veis, he añadido unos campos de distintos tipos, incluidos un array de floats y una lista tipada (para que veáis que se pueden meter distintos tipos en un Parcel).

Ahora vamos a ver la chicha, cómo guardar el objeto en un Parcel y como recuperarlo después.

Básicamente el objeto Parcel nos expone unos métodos para escribir nuestros campos según su tipo para no equivocarnos, por lo que rellenamos nuestro método writeToParcel de la forma siguiente:
```
@Override
public void writeToParcel(Parcel dest, int flags) {
	dest.writeInt(fechaNacimiento);
	dest.writeString(nombreCompleto);
	dest.writeBooleanArray(new boolean[]{esHijoUnico});
	dest.writeFloatArray(notas);
	dest.writeTypedList(amigos);
}
```
Mientras escribía esto he descubierto que [no hay un método Parcel.writeBoolean(boolean val)](http://code.google.com/p/android/issues/detail?id=5973) (gracias Google!) por lo que podéis o bien escribirlo en un array de booleans con un único valor, o escribir un byte y luego parsearlo como boolean.

Ahora vamos a ver como recuperaríamos nuestro objeto de un Parcel, así que rellenamos el método readFromParcel de esta manera:
```
private void readFromParcel(Parcel in) {
	fechaNacimiento = in.readInt();
	nombreCompleto = in.readString();

	boolean[] temp = new boolean[1];
	in.readBooleanArray(temp);
	esHijoUnico = temp[0];

	in.readFloatArray(notas);
	in.readTypedList(amigos, CREATOR);
}
```
¡Ostras! Para leer una lista tipada necesito un objeto Parcelable.Creator, ¿qué es eso? Digamos que es un objeto que genera objetos del tipo que le digas a partir de un Parcel (vamos, lo que veníamos haciendo) pero es necesario para recrear los objetos en otros Parcelables. Es muy sencillo, sólo hay que añadir esto:
```
public static final Parcelable.Creator&lt;Estudiante&gt; CREATOR
	= new Parcelable.Creator&lt;Estudiante&gt;() {
		public Estudiante createFromParcel(Parcel in) {
			return new Estudiante(in);
		}

		public Estudiante[] newArray(int size) {
			return new Estudiante[size];
		}
	};
```

Ahora veis como añadir un constructor que recibe un Parcel era buena idea para tener todo limpito. Además, nota importante, cuando leemos del Parcel no hay pares clave-valor, así que hay que **leerlo en el mismo orden en que lo escribimos**.

¡Pues ya tenemos nuestro objeto implementado! Vamos a ver si funciona. Creamos un par de activities, en el primero creamos un par de estudiantes, uno amigo del otro (¡no es un amistad mutua así que sin referencias cruzadas por favor!) y lo metemos en los extras de un intent que viajarán a la segunda activity donde rescatamos nuestro estudiante y escribimos en el LogCat toda la info que hemos recibido de él y de su amigo no correspondido:

**MainActivity.java**
```
Estudiante otroEstudiante = new Estudiante();
otroEstudiante.nombreCompleto = "Perico Palotes";
otroEstudiante.esHijoUnico = false;
otroEstudiante.fechaNacimiento = 1990;
otroEstudiante.notas = new float[]{7.8f, 4.9f, 10.0f};
otroEstudiante.amigos = new ArrayList&lt;Estudiante&gt;();

Estudiante estudiante = new Estudiante();
estudiante.nombreCompleto = "Fernando F. Gallego";
estudiante.esHijoUnico = true;
estudiante.fechaNacimiento = 1983;
estudiante.notas = new float[]{9.5f, 8.6f, 4.6f};
estudiante.amigos = new ArrayList&lt;Estudiante&gt;();

estudiante.amigos.add(otroEstudiante);

Intent intent = new Intent(this, DestActivity.class);
intent.putExtra("estudiante", estudiante);
startActivity(intent);
```

**DestActivity.java**
```
Estudiante estudiante = getIntent().getParcelableExtra("estudiante");

Log.i("estudiante", estudiante.nombreCompleto);
Log.i("estudiante", String.valueOf(estudiante.esHijoUnico));
Log.i("estudiante", String.valueOf(estudiante.fechaNacimiento));
Log.i("estudiante", Arrays.toString(estudiante.notas));
Estudiante amigo = estudiante.amigos.get(0);
Log.i("amigo", amigo.nombreCompleto);
Log.i("amigo", String.valueOf(amigo.esHijoUnico));
Log.i("amigo", String.valueOf(amigo.fechaNacimiento));
Log.i("amigo", Arrays.toString(amigo.notas));</pre> Y esto es lo que veremos en nuestro querido LogCat <pre class="brush: bash;">I/estudiante(6739): Fernando F. Gallego
I/estudiante(6739): true
I/estudiante(6739): 1983
I/estudiante(6739): [9.5, 8.6, 4.6]
I/amigo(6739): Perico Palotes
I/amigo(6739): false
I/amigo(6739): 1990
I/amigo(6739): [7.8, 4.9, 10.0]
```

Puedes descargarte el [código de ejemplo de github](https://github.com/ferdy182/Android-parcelable-example "ferdy182 en GitHub Android parcelable example")
