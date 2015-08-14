---
layout: post
title: Añadir datos precargados en tus aplicaciones
date: '2013-01-23 11:00:00'
tags:
- Artículos
---

Hay ocasiones en las que por alguna razón necesitamos incluir una serie de datos precargados en nuestra aplicación android, de forma que cuando el usuario instale la aplicación pueda empezar a disfrutar de contenido sin necesidad de tener que depender de un servicio externo.

En el siguiente artículo os plantearemos una serie de alternativas sobre cómo partir de una base de datos con datos existentes. No existe una opción única o mejor que todas, ya que cada una de las soluciones aquí presentadas se adaptan a distintas situaciones.

<!--more-->

##### Opción 1 - Carga manual al crear la base de datos

Si los datos son pocos y éstos no van a cambiar mucho la forma más sencilla es insertarlos manualmente durante la creación de la base de datos.

Al trabajar con [bases de datos en android](http://developer.android.com/training/basics/data-storage/databases.html), tendremos una clase que extiende de **SQLiteOpenHelper** y que será la encargada de generar la base de datos. El método **onCreate** será el lugar donde podremos insertar los valores, de esta forma nos aseguramos que se hará siempre que se cree la base de datos.

Si estamos trabajando directamente con **SQLiteOpenHelper** (no estamos utilizando una librería externa de gestión de base de datos) nuestro método **onCreate** podría quedar de la siguiente forma:

<pre class="brush: java; gutter: true; first-line: 1">    public void onCreate(SQLiteDatabase db) {
        // Sentencias de creación de base de datos
        // db.execSQL("CREATE TABLE ...");
        db.beginTransaction();
        try {
            ContentValues values = new ContentValues();
            for (int i = 0; i &lt; NOMRES.length; i++) {
                values.put("nombre", NOMBRES[i]);
                values.put("edad", EDADES[i]);
                db.insert("usuarios", null, values);
            }
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }
</pre>
Como vemos el funcionamiento es muy sencillo. Los datos podrían venir de cualquier otra clase de nuestro código en lugar de arrays (en el ejemplo NOMBRES y EDADES). Lo importante aquí empieza en la línea 4, declaramos que vamos a iniciar una transacción, insertamos los datos, declaramos que hemos insertado los datos correctamente y finalizamos la transacción. Se utilizan transacciones para que la inserción de datos se haga de una forma más rápida.

Si estamos utilizando alguna librería de gestión de base de datos siempre tendremos la posibilidad de ejecutar código durante la creación de la base de datos. ORMLite por ejemplo extiende de [OrmLiteSqliteOpenHelper](http://ormlite.com/android/examples/DatabaseHelper.java) que también incluye el método **onCreate**.

##### Opción 2 - Cargar script SQL al crear la base de datos

Una segunda opción y quizás la más recomendable después de la **Opción 4** consiste en crearnos un fichero SQL de inserción, leerlo e importarlo en el **onCreate**. El fichero podemos crearlo en el directorio _assets_ y tendría una sentencia SQL por línea. Por ejemplo:

    INSERT INTO usuarios (nombre, edad) VALUES ('usuario1', 18);
    INSERT INTO usuarios (nombre, edad) VALUES ('usuario2', 48);
    INSERT INTO usuarios (nombre, edad) VALUES ('usuario3', 30);
    INSERT INTO usuarios (nombre, edad) VALUES ('usuario4', 55);
    INSERT INTO usuarios (nombre, edad) VALUES ('usuario5', 16);

Si suponemos que el fichero se ha grabado en el directorio _assets_ con el nombre _import.sql_ nuestro método **onCreate** del **SQLiteOpenHelper** quedaría de la siguiente forma:

<pre class="brush: java; gutter: true; first-line: 1">    public void onCreate(SQLiteDatabase db) {
        // Sentencias de creación de base de datos
        // db.execSQL("CREATE TABLE ...");
        InputStream is = null;
        try {
             is = mContext.getAssets().open("import.sql");
             if (is != null) {
                 db.beginTransaction();
                 BufferedReader reader = new BufferedReader(new InputStreamReader(is));
                 String line = reader.readLine();
                 while (!TextUtils.isEmpty(line)) {
                     db.execSQL(line);
                     line = reader.readLine();
                 }
                 db.setTransactionSuccessful();
             }
        } catch (Exception ex) {
            // Muestra log
        } finally {
            db.endTransaction();
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    // Muestra log
                }
            }
        }
    }
</pre>
Como vemos resulta muy sencillo. La variable **mContext** podemos inicializarla en el constructor del **SQLiteOpenHelper**. Luego sólo tenemos que cargar el fichero, leerlo línea a línea e ir ejecutando las sentencias. Esto mismo podría valernos para el método **onUpgrade**, con un fichero SQL con sentencias de actualización de base de datos.

Esta opción es muy recomendable cuando tenemos un número considerable de datos, pero hay que tener en cuenta que es posible que se ejecute en el hilo principal (por ejemplo porque inicializamos el _helper_ en una activity) llegándolo a bloquear si tarda mucho.

Al igual que antes, la mayoría de los gestores de base de datos proporcionan el método **onCreate** donde podemos realizar esta misma tarea.

##### Opción 3 - Copiar una base de datos creada con anterioridad

Esta opción y la última son las aconsejables cuando el volumen de datos es muy grande. No obstante, aunque la opción 3 pueda llegar a ser la más cómoda es, sin lugar a dudas, la que más problemas y quebraderos de cabeza puede darnos. No es la más recomendable, sin embargo es una solución posible y como tal os la presentamos en el artículo.

La idea se basa en crear una base de datos _SQLite_, insertar datos mediante un programa externo en nuestro ordenador, empaquetarla en el directorio _assets_ de nuestra aplicación y en la creación de la base de datos darle el cambiazo a la recién creada por la nuestra.

Existen multitud de recursos sobre cómo realizar esta tarea, basta con una simple [búsqueda en Google](https://www.google.es/search?q=Using+your+own+SQLite+database+in+Android) para encontrar alguno de los artículos. A continuación vamos a comentar los pasos por encima.

###### Paso 1 - Preparar la base de datos

El primer paso es preparar nuestra base de datos. Podemos utilizar la [herramienta sqlite3](http://developer.android.com/tools/help/sqlite3.html) que incorpora el SDK de android o algún editor gráfico como [SQLite Database Browser](http://sourceforge.net/projects/sqlitebrowser/) o [SQLiteman](http://sqliteman.com/). Lo importante es que nuestra base de datos debe tener una tabla con el nombre **android_metadata** con una única columna de nombre **locale** y con una fila con el valor **en_US**. Podemos crearla con las siguientes dos sentencias SQL:

    CREATE TABLE android_metadata (locale TEXT DEFAULT 'en_US');
    INSERT INTO android_metadata VALUES ('en_US');

Una vez hecho esto creamos las tablas de nuestra aplicación e insertamos los datos necesarios.

###### Paso 2 - Copiar la base de datos en el directorio assets

Este paso, a priori sencillo, puede darnos más de un problema. El motivo es que si nuestra base de datos ocupa más de 1MB, al crear el APK la base de datos estará en el directorio _assets_ pero comprimida y al leerla nos dará un error.

La herramienta _aapt_ ignora para su compresión algunos recursos en base a su extensión, como por ejemplo mp3 o avi, porque se supone que estos ficheros ya están comprimidos. Por tanto, tenemos dos formas de evitar que la herramienta _aapt_ comprima nuestro fichero de base de datos al crear el APK:

*   <span style="line-height: 12px">**Forma fácil**: Le cambiamos la extensión a .mp3</span>
*   **Forma correcta**: Le pasamos el parámetro '-0' (cero) seguido de la extensión 'db' (o la extensión del fichero de nuestra base de datos si es otra) a la herramienta cuando vayamos a crear el APK

###### Paso 3 - Inicializar la base de datos y copiar la nuestra

El último paso consiste en modificar nuestra clase **SQLiteOpenHelper** para que realice los siguientes pasos:

1.  <span style="line-height: 12px">Compruebe si la base de datos está inicializada</span>
2.  Si no lo está, inicialice y la sobrescriba con la base de datos del directorio assets

Como dijimos antes, existen varias páginas que explican cómo realizar esta tarea. A continuación podemos ver una posible implementación del **SQLiteOpenHelper**.

<pre class="brush: java; gutter: true; first-line: 1">import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

public class DBHelper extends SQLiteOpenHelper {

    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "basededatos.db";

    private Context mContext;

    public DBHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        mContext = context;
    }

    public void createDataBase() throws IOException {
        File pathFile = mContext.getDatabasePath(DATABASE_NAME);
        boolean dbExist = checkDataBase(pathFile.getAbsolutePath());
        if(!dbExist) {
            this.getReadableDatabase();
            try {
                copyDataBase(pathFile);
            } catch (IOException e) {
                // Error copying database
            }
        }
    }

    private boolean checkDataBase(String path) {
        SQLiteDatabase checkDB = null;
        try {
            checkDB = SQLiteDatabase.openDatabase(path, null, SQLiteDatabase.OPEN_READONLY);
        } catch(Exception e){
             // Database doesn't exist
        }
        if(checkDB != null) {
            checkDB.close();
        }
        return checkDB != null;
    }

    private void copyDataBase(File pathFile) throws IOException {
        InputStream myInput = mContext.getAssets().open("basededatos.db");
        OutputStream myOutput = new FileOutputStream(pathFile);
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myInput.read(buffer)) &gt; 0) {
            myOutput.write(buffer, 0, length);
        }
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

}
</pre>
Siempre que queramos hacer uso de los métodos **getReadableDatabase()** y **getWritableDatabase()** tendríamos que llamar al método **createDatabase()** que se encarga de crear la base de datos si ésta no existe (si ya existe no hace nada).

**¡Excepciones!**: Si vas a utilizar este código en tu aplicación ten en cuenta las capturas de excepciones, deberás actuar en consecuencia.

##### Opción 3' - Utilizar android-sqlite-asset-helper

La [librería android-sqlite-asset-helper](https://github.com/jgilfelt/android-sqlite-asset-helper) nos facilita la implementación mediante la opción 3 pero con la ventaja de que nos ahorra prácticamente todo el trabajo. Por contra, perderemos el control de qué está ocurriendo.

Para utilizarla debemos seguir los siguientes pasos:

1.  <span style="line-height: 12px">Copiar [android-sqlite-asset-helper.jar](https://github.com/jgilfelt/android-sqlite-asset-helper/blob/master/lib/android-sqlite-asset-helper.jar?raw=true) en nuestro directorio libs</span>
2.  Crear nuestro _helper_ extendiendo de **SQLiteAssetHelper**
3.  Llamar al "super constructor" pasándole el nombre de la base de datos.

Por ejemplo, si invocamos el super constructor de la siguiente forma:

<pre class="brush: java; gutter: true; first-line: 1">super(context, "mibasededatos", null, 1);</pre>
Tendremos que poner nuestra base de datos comprimida en:

    assets/databases/mibasededatos.zip

Simplemente con esto, la librería gestionará la importación de la base de datos en el caso de que no existiera.

##### Opción 4 - Estándar

¿Pero qué ocurre si los datos tardan mucho en cargar?, o ¿y si los leo desde un servicio web externo?, o ¿y si me los pasan en XML o JSON?. Bueno, si estás en una de las situaciones anteriores una solución como esta es la más indicada. Es la opción más visual (de hecho es la única que cuenta con vistas) y podemos verla reflejada en el siguiente boceto:

[![Mockup carga de datos](http://androcode.es/wp-content/uploads/2015/02/1.-Home_pj3dla.png)](http://androcode.es/wp-content/uploads/2015/02/1.-Home_pj3dla.png)

La idea es sencilla, al entrar en nuestra pantalla principal comprobamos si están los datos cargados. Si no lo están cargamos una vista como la del boceto e iniciamos una tarea de carga.

El código aquí no tiene sentido, pues existen muchísimas formas de conseguir este comportamiento y depende, entre otras cosas, de nuestra forma de conectarnos a la base de datos.

Esta forma de resolver la carga inicial está especialmente indicada cuando tenemos un volumen de datos bastante considerable y además los datos estén en un formato no impuesto por nosotros, como por ejemplo XML o fichero de texto.

La idea de esta aproximación es ejecutar la tarea en un segundo plano, por lo que si la importación tarda más de un par se segundos de ejecución esta puede ser una buena opción. Podría implementarse fácilmente con una [AsyncTask](http://developer.android.com/reference/android/os/AsyncTask.html), aunque los detalles ya dependen de vuestro caso.

Las características de esta aproximación son:

1.  Se adapta a cualquier cantidad de datos. Si la importación tarda más de un minuto no es problema, pues no estamos bloqueando el hilo principal de ejecución.
2.  Tendremos que diseñar los layouts, gestionar la carga en segundo plano y actualizar la vista cuando sea necesario.

##### Conclusiones

Como vemos es relativamente sencillo incorporar unos datos precargados a nuestras aplicaciones android.

En ese artículo se han presentado 4 +1 formas de realizar esta tarea. Y vosotros, ¿utilizáis otros mecanismos?, si habéis utilizado alguna de las propuestas, ¿cuál ha sido vuestra experiencia?.
