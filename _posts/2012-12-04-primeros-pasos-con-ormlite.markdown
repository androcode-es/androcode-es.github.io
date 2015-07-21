---
layout: post
title: Primeros pasos con ORMLite
date: '2012-12-04 11:00:00'
---

![](http://androcode.es/wp-content/uploads/2015/02/orm_cz4tqf.png)
  
En este blog ya os hemos hablado de cómo facilitar el trabajo con bases de datos [SQLite](http://androcode.es/tag/sqlite/). En concreto hemos visto cómo trabajar con [Android DataFramework](http://androcode.es/tag/android-dataframework/) y [ADA Framework](http://androcode.es/tag/ada-framework/). Hoy os traemos una pequeña joya, una librería que en mis proyectos se ha convertido en una fija, ya no sólo por su facilidad de uso sino también por su potencia. Os estoy hablando de [ORMLite](http://ormlite.com/).   ORMLite es de esas librerías que al principio pueden resultar poco vistosas con una página poco cuidada y una documentación difícil de leer. Pero cuando trabajas con ella descubres lo fiable que es y la cantidad de posibilidades que ofrece. Sobra decir que ORMLite es una librería ORM clásica que nos permite mapear clases Java con tablas en la base de datos. En esta entrada veremos qué nos hace falta en nuestro proyecto para empezar a utilizar la librería, cómo modelar las clases, cómo crear nuestro _helper_ y por último algunos ejemplos sencillos.  

#### Elementos necesarios

Lo primero que tenemos que tener es un proyecto android. ORMLite se distribuye a partir de dos librerías JAR que debemos incluir en el directorio libs de nuestro proyecto: ormlite-core: Núcleo de la librería ormlite-android: Clases específicas de android Debemos incluir ambas en nuestro proyecto y para descargarlas tenemos varias opciones:

- [Repositorio local](http://ormlite.com/releases/)
- [Repositorio de maven](http://repo1.maven.org/maven2/com/j256/ormlite/)
- [Sourceforge](https://sourceforge.net/projects/ormlite/files/releases/com/j256/ormlite/)

#### Modelar las clases

El siguiente paso es elegir las clases del modelo que queremos mapear a tablas en nuestra base de datos. Cada clase será una tabla en nuestra base de datos y lo indicaremos a través de anotaciones sobre la clase. Lo mejor es verlo a través de un ejemplo, para ello supongamos que tenemos dos clases, Usuario y Grupo, que representan a usuarios y grupos respectivamente. Un usuario sólo puede estar en un grupo y el grupo puede tener más de un usuario. La clase Usuario tendría la siguiente forma:

```
package es.androcode.androcode_ormlite;

import java.util.Date;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable
public class Usuario {

    public static final String ID = "_id";
    public static final String NOMBRE = "nombre";
    public static final String FECHA_NACIMIENTO = "fecha_nacimiento";
    public static final String GRUPO = "grupo";

    @DatabaseField(generatedId = true, columnName = ID)
    private int id;
    @DatabaseField(columnName = NOMBRE)
    private String nombre;
    @DatabaseField(columnName = FECHA_NACIMIENTO)
    private Date fechaNacimiento;    
    @DatabaseField(foreign = true, columnName = GRUPO)
    private Grupo grupo;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public Grupo getGrupo() {
        return grupo;
    }

    public void setGrupo(Grupo grupo) {
        this.grupo = grupo;
    }

}
```

Vamos a ir desgranando las principales partes importantes de este código. 

**Línea 8 - Anotación DatabaseTable:** 
Mediante esta anotación estamos indicando que esta clase tendrá su correspondiente tabla en la base de datos. Esta anotación acepta el atributo tableName que permite indicar un nombre concreto de la tabla.

**Líneas 11 a 14:**
Constantes para especificar los nombres de las columnas. Esta es una práctica que suelo utilizar a menudo y que recomiendo encarecidamente. Esto suele resultar muy útil porque más adelante necesitaremos el nombre de la columna para ordenar o realizar consultas y no es aconsejable poner las cadenas en cada uso.

**Línea 16 - DatabaseField(generatedId = true, columnName = ID):**
Esta anotación se sitúa sobre el campo que hace de clave primaria. El campo puede ser de cualquier tipo, pero se aconseja que sea de tipo int o tipo long. Hemos usado **generatedId** para indicar que el id se genere automáticamente al crear objetos. Podríamos haber puesto **generateIdSequence** para que se autogenere mediante secuencia de base de datos o **id**, si quisiéramos indicar nosotros el id. El segundo parámetro es columnName que indica el nombre de la columna. Otra recomendación es utilizar como nombre de columna para el id "_id", ya que es lo recomendado por android y nos facilitará compatibilidades con los CursorAdapter por ejemplo.

**Líneas 18 a 21:**
Definición del resto de propiedades y columnas.

**Línea 22 - @DatabaseField(foreign = true, columnName = GRUPO):**
Definimos la relación con la entidad Grupo, indicado mediante el atributo foreign. A través de este valor, estamos diciéndole al motor de ORMLite que la propiedad grupo hace referencia a otra entidad con su correspondiente id. La entidad Grupo es muy simple, ya que para este ejemplo no vamos a guardar relación con Usuario.  
```
package es.androcode.androcode_ormlite;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable
public class Grupo {

    public static final String ID = "_id";
    public static final String NOMBRE = "nombre";

    @DatabaseField(generatedId = true, columnName = ID)
    private int id;
    @DatabaseField(columnName = NOMBRE)
    private String nombre;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

}
```

#### Creando el helper

Siempre que queramos trabajar con SQLite en Android tendremos que crear un _helper_. Una clase helper se encarga de crear, actualizar y proporcionar acceso a la base de datos. En ORMLite tendremos que extender de **OrmLiteSqliteOpenHelper**. También le añadiremos el acceso a los DAO para que podamos utilizarlos desde otras partes del código. Vamos a ver cómo quedaría nuestra clase _helper_ y luego explicaremos las partes más importantes.

```
package es.androcode.androcode_ormlite;

import java.sql.SQLException;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import com.j256.ormlite.android.apptools.OrmLiteSqliteOpenHelper;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;

public class DBHelper extends OrmLiteSqliteOpenHelper {

    private static final String DATABASE_NAME = "androcode_ormlite.db";
    private static final int DATABASE_VERSION = 1;

    private Dao<Usuario, Integer> usuarioDao;
    private Dao<Grupo, Integer> grupoDao;

    public DBHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db, ConnectionSource connectionSource) {
        try {
            TableUtils.createTable(connectionSource, Usuario.class);
            TableUtils.createTable(connectionSource, Grupo.class);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, ConnectionSource connectionSource, int oldVersion, int newVersion) {
        onCreate(db, connectionSource);
    }

    public Dao<Usuario, Integer> getUsuarioDao() throws SQLException {
        if (usuarioDao == null) {
            usuarioDao = getDao(Usuario.class);
        }
        return usuarioDao;
    }

    public Dao<Grupo, Integer> getGrupoDao() throws SQLException {
        if (grupoDao == null) {
            grupoDao = getDao(Grupo.class);
        }
        return grupoDao;
    }

    @Override
    public void close() {
        super.close();
        usuarioDao = null;
        grupoDao = null;
    }

}
```

**Líneas 18 y 19:**
Declaramos los DAO. A través de estos objetos realizaremos todas las operaciones de la base de datos. Cada objeto del modelo tiene su propio DAO asociado.

**Líneas 21 a 23:**
El constructor recibe la versión de la base de datos y el nombre de la base de datos. Esta parte es común al resto de _helpers_. Existen formas de acelerar el proceso de creación de las tablas, pero es algo que veremos más adelante.

**Líneas 25 a 33:**
Es el método onCreate que se encarga de crear las tablas. En este caso hacemos del método TableUtils.createTable de la API de ORMLite. Recibe como parámetro la conexión y la clase del modelo para la que crear la tabla. Como vemos esto resulta muy cómodo, mucho más si lo comparamos con tener que crear las tablas a mano. 

**Líneas 35 a 38:**
Método onUpgrade. En este caso al ser la primera versión de la base de datos no necesitamos actualizarla. Aquí tendríamos que poner el código encargado de actualizar la base de datos de una versión a otra tal y como lo hacemos con los helpers de android. 

**Líneas 40 a 52:**
Son los métodos a través de los que podemos recuperar los DAO. Estos métodos crearán el DAO si no está inicializado o lo devolverán si ya está creado.

**Línea 54 a 59:**
Método close que se encarga de liberar los recursos.  


#### Ejemplo de uso

Lo primero que tenemos que plantearnos es, ¿cómo recupero el _helper_?. Los _helpers_ suelen estar en el ámbito de las actividades, de forma que los fragments pueden tener acceso a través de la actividad que lo ha creado. También pueden utilizarse en servicios u otros elementos. La forma de crear el _helper_ es la siguiente:

```
DBHelper helper = OpenHelperManager.getHelper(context, DBHelper.class);
```

Llamamos al método **OpenHelperManager.getHelper** pasándole como argumentos el contexto y la clase antes definida. Es importante liberar recursos una vez que no vayamos a hacer operaciones con la base de datos. En el caso de las actividades podemos realizar esto en el método **onDestroy**. En las actividades en las que vayamos a necesitar acceso al helper suelo utilizar el siguiente trozo de código (puedes moverlo a una clase abstracta y extender de ella si tienes más de una actividad con acceso a base de datos).  

```
private DBHelper mDBHelper;

    private DBHelper getHelper() {
        if (mDBHelper == null) {
            mDBHelper = OpenHelperManager.getHelper(this, DBHelper.class);
        }
        return mDBHelper;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mDBHelper != null) {
            OpenHelperManager.releaseHelper();
            mDBHelper = null;
        }
    }
```

Resumiendo, creamos una propiedad para almacenar la referencia a DBHelper y nos creamos un método de acceso para inicializar la clase sólo cuando haga falta. Observa que si nunca accedemos a dicho método, nunca inicializaremos la clase DBHelper. Por último se añade al método **onDestroy** la liberación de recursos. Ahora vamos a ver algunos ejemplos sencillos de cómo interactuar con la base de datos. Como veremos a continuación, los métodos de los DAO pueden lanzar SQLException. ORMLite siempre nos ofrece mucha flexibilidad y en este caso no iba a ser menos. Si nos sentimos incómodos capturando en cada trozo de código en el que hagamos operaciones con base de datos simplemente cambiamos el uso de la clase Dao por RuntimeExceptionDao. Las excepciones que lanza RuntimeExceptionDao son de tipo _runtime_, por lo que no es necesario capturarlas. De todas formas no os aconsejo esto último, porque si falla una operación en la base de datos tendréis que actuar en consecuencia y no simplemente dejar que la aplicación de un _force close_ al usuario.

**Crear un objeto**  
```
Dao dao;
try {
    dao = getHelper().getUsuarioDao();
    Usuario usuario = new Usuario();
    usuario.setFechaNacimiento(new Date());
    usuario.setNombre("Fede");
    dao.create(usuario);
} catch (SQLException e) {
    Log.e(TAG, "Error creando usuario");
}
```

**Recuperar objetos**  
```
Dao dao;
try {
    dao = getHelper().getUsuarioDao();
    Usuario usuario = dao.queryForId(1);
    if (usuario == null) {
        Log.d(TAG, "Ningún usuario con id = 1");                
    } else {
        Log.d(TAG, "Recuperado usuario con id = 1: " + usuario.getNombre());
    }
    List usuarios = dao.queryForEq(Usuario.NOMBRE, "Fede");
    if (usuarios.isEmpty()) {
        Log.d(TAG, "No se encontraron usuarios con nombre = Fede");                
    } else {
        Log.d(TAG, "Recuperado usuarios con nombre = Fede " + usuarios);                
    }
} catch (SQLException e) {
    Log.e(TAG, "Error creando usuario");
}
```

El objeto DAO permite realizar consultas simples. Para consultas más complejas tendremos utilizar un QueryBuilder. A continuación podemos ver un ejemplo sencillo. En una próxima entrada veremos usos más avanzados de consultas.  

```
Dao dao;
try {
    dao = getHelper().getUsuarioDao();
    QueryBuilder queryBuilder = dao.queryBuilder();
    queryBuilder.setWhere(queryBuilder.where().eq(Usuario.NOMBRE, "Fede"));
    List usuarios = dao.query(queryBuilder.prepare());
    if (usuarios.isEmpty()) {
        Log.d(TAG, "No se encontraron usuarios con nombre = Fede");                
    } else {
        Log.d(TAG, "Recuperado usuarios con nombre = Fede " + usuarios);                
    }
} catch (SQLException e) {
    Log.e(TAG, "Error creando usuario");
}
```

**Actualizar y eliminar objetos**  
```
Dao dao;
try {
    dao = getHelper().getUsuarioDao();
    usuario.setNombre("Pedro");
    dao.update(usuario);
    Log.d(TAG, "Usuario modificado: " + usuario.getNombre());
    dao.delete(usuario);
} catch (SQLException e) {
    Log.e(TAG, "Error creando usuario");
}
```

#### Conclusiones

Como podéis ver ORMLite es muy sencillo e intuitivo. En próximas entradas intentaremos profundizar en su uso. También os recomendaría que os dierais una vuelta por la [documentación oficial](http://ormlite.com/javadoc/ormlite-core/doc-files/ormlite.html) y por supuesto a las preguntas y respuestas sobre esta librería en [stackoverflow](http://stackoverflow.com/questions/tagged/ormlite).