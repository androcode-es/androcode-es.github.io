---
layout: post
title: ! 'Un ‘stack’ productivo para el desarrollador android #1, Arquitectura'
date: '2015-02-03 11:00:00'
---

Este es el primero de una serie de artículos sobre como configurar un entorno para llevar a cabo un proyecto android escalable, _mantenible_ y t_esteable_, una serie de patrones y librerías usadas de una cierta manera para no volverse loco en el día día de un desarrollador android.

<!--more-->

## <span style="font-size: medium">Escenario</span>

Como ejemplo, me voy a basar en el siguiente proyecto, es una prueba de concepto de un simple catálogo de películas, las cuales se pueden marcar como vistas o pendientes.

[![1](http://androcode.es/wp-content/uploads/2015/02/1_ntqfre.png)](http://androcode.es/wp-content/uploads/2015/02/1_ntqfre.png)

La información sobre las películas es sacada de una API pública llamada: [themoviedb](https://www.themoviedb.org/documentation/api "TheMovieDB"), se puede encontrar buena documentación sobre ésta en su sección de [Apiary](http://docs.themoviedb.apiary.io/# "Apiary").

Este proyecto se apoya en el patrón [Model View Presenter](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter "Model View Presenter"), además implementa varias _guidelines_ de la nueva especificación de diseño: [Material Design](http://www.google.com/design/spec/material-design/introduction.html "Material Design"), como transiciones, estructuras, animaciones, colores etc...

Todo el código está publicado en [Github](https://github.com/saulmm/Material-Movies "Github"), por si queréis echarle un ojo.

## Arquitectura:

Para diseñar la arquitectura, me he basado en el patrón [Model View Presenter](Model View Presenter "http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter"), que es una variación del patrón de arquitectura[ Model View Controller](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).

Este patrón busca abstraer la **lógica de negocio** de la capa de presentación, en android esto es importante, ya que el propio _framework_ facilita el acople de estas dos partes junto a la capa de datos, un claro ejemplo son los _Adapters_.

Esta arquitectura, facilita el intercambio de las vistas sin que sea necesario modificar la lógica de negocio ni la capa de datos, reutilizar la capa de dominio, o variar entre varias fuentes de datos como una base de datos o una API REST.

### Idea general

La estructura se puede dividir en tres grandes capas: **presentación,** **modelo** y **dominio**.

![0B62SZ3WRM2R2eGczcWh3MERkRGc](http://androcode.es/wp-content/uploads/2015/02/0B62SZ3WRM2R2eGczcWh3MERkRGc-e1422883852292_hfs4r6.png)

#### Presentación

La capa de **presentación** es la que se encargará, como su nombre indica de mostrar la interfaz gráfica y proveerla de datos.

#### Modelo

El **modelo**, será el encargado de proveer la información, esta capa no sabrá **nada** del dominio, tampoco de la presentación, podría implementar una conexión e interfaz con una base de datos, con una Api REST, o con cualquier otro medio de persistencia.

En esta capa también se implementarán las entidades de nuestra aplicación, la clase que representa a una película, una categoría, etc...

#### Dominio

La capa de **dominio** es totalmente **independiente** de la capa de presentación, en ella residirá la lógica de negocio de nuestra aplicación.

### Implementación

Las capas de **dominio, presentación** y **modelo** dentro del proyecto, se distribuyen en dos módulos java y otro correspondiente a la aplicación Android (capa de presentación), además, se comparte un módulo común con librerías y utilidades.

[![0B62SZ3WRM2R2elJfT0JiZnlTcE0](http://androcode.es/wp-content/uploads/2015/02/0B62SZ3WRM2R2elJfT0JiZnlTcE01_ospwxi-260x300.png)](http://androcode.es/wp-content/uploads/2015/02/0B62SZ3WRM2R2elJfT0JiZnlTcE01_ospwxi.png)

#### Modulo dominio

El módulo del dominio, albergará los casos de uso y sus implementaciones, es la lógica de negocio de nuestra aplicación.

Este módulo es **totalmente independiente** del _framework_ de Android y sus dependencias son el módulo del modelo y el módulo común.

Un caso de uso podría ser obtener la valoración total de varias categorías de películas para ver que categoría es la más solicitada, para ello el caso de uso necesitaría obtener la información y luego hacer un cálculo sobre ella, esa información es pedida al **modelo**.

_Dependencias del dominio_
<pre class="brush: java; gutter: true; first-line: 1">dependencies {
    compile project (':common')
    compile project (':model')
}</pre>

#### Módulo modelo

El módulo del modelo es el encargado de gestionar la información, solicitarla, guardarla, eliminarla etc... En una primera versión únicamente gestionará las operaciones sobre una API REST de información de películas,

También implementa las entidades, como por ejemplo _TvMovie_, entidad encargada de representar una película.

Sus dependencias únicamente será el módulo común y por ahora, la librería utilizada para gestionar las peticiones a la API REST, en este caso [Retrofit](http://square.github.io/retrofit/) "Retrofit"), de [Square](http://square.github.io/ "Square"):

_Dependencias del modelo_
<pre class="brush: java; gutter: true; first-line: 1">dependencies {
    compile project(':common')
    compile 'com.squareup.retrofit:retrofit:1.9.0'
}</pre>

#### Modulo presentación

Este módulo como bien dice su nombre se encargará de la **presentación**, es la propia **aplicación Android**, con sus recursos, _assets_, etc...

Además, interactuará con el dominio ejecutando los casos de uso, un ejemplo sería listar las películas actuales de un determinado momento, o solicitar datos específicos de una película.

En este módulo tendremos **presentadores** y **vistas**, el término _vista_ en este contexto puede resultar un poco confuso, ya que se podría confundir con tres término diferentes: una referencia a un elemento relativo a la clase de Android: _[View](http://developer.android.com/reference/android/view/View.html "View"),_ elementos visuales de la aplicación, como un _Activity_ o un _Fragment_, o a las propias vistas del patrón: _MVP_, por eso cuando haga alusión a las vistas del _MVP_ me referiré a ellas como: _MVPView_.

Cada _Activity_, _Fragment_, _etc..._ implementará una interfaz correspondiente a una _MVPView_, ésta, especificará operaciones para mostrar pintar información de las que se tiene que encargar la vista.

Por ejemplo, la _MVPView_, _PopularMoviesView_, especificará las operaciones para mostrar la lista de películas actuales, está será implementada por la vista, _MoviesActivity_.
<pre class="brush: java; gutter: true; first-line: 1">public interface PopularMoviesView extends MVPView {

    void showMovies (List&lt;TvMovie&gt; movieList);

    void showLoading ();

    void hideLoading ();

    void showError (String error);

    void hideError ();
}</pre>
El patrón: _MVP_ incide en que las vistas sean **lo más tontas posibles**, es el presentador de cada vista quien decidirá su comportamiento.
<pre class="brush: java; gutter: true; first-line: 1">public class MoviesActivity extends ActionBarActivity implements
PopularMoviesView, ... {
...
    private PopularShowsPresenter popularShowsPresenter;
    private RecyclerView popularMoviesRecycler;
    private ProgressBar loadingProgressBar;
    private MoviesAdapter moviesAdapter;
    private TextView errorTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        ...
        popularShowsPresenter = new PopularShowsPresenterImpl(this);
        popularShowsPresenter.onCreate();
    }

    @Override
    protected void onStop() {

        super.onStop();
        popularShowsPresenter.onStop();
    }

    @Override
    public Context getContext() {

        return this;
    }

    @Override
    public void showMovies(List&lt;TvMovie&gt; movieList) {

        moviesAdapter = new MoviesAdapter(movieList);
        popularMoviesRecycler.setAdapter(moviesAdapter);
    }

    @Override
    public void showLoading() {

        loadingProgressBar.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideLoading() {

        loadingProgressBar.setVisibility(View.GONE);
    }

    @Override
    public void showError(String error) {

        errorTextView.setVisibility(View.VISIBLE);
        errorTextView.setText(error);
    }

    @Override
    public void hideError() {
        errorTextView.setVisibility(View.GONE);
    }
    ...
}</pre>
Los casos de uso serán ejecutados desde los presentadores, estos recibirán la respuesta y gestionarán el comportamiento de las vistas.
<pre class="brush: java; gutter: true; first-line: 1">public class PopularShowsPresenterImpl implements PopularShowsPresenter {

    private final PopularMoviesView popularMoviesView;

    public PopularShowsPresenterImpl(PopularMoviesView popularMoviesView) {
        this.popularMoviesView = popularMoviesView;
    }

    @Override
    public void onCreate() {

        ...
        popularMoviesView.showLoading();
        Usecase getPopularShows = new GetMoviesUsecaseController(GetMoviesUsecase.TV_MOVIES);
        getPopularShows.execute();
    }

    @Override
    public void onStop() {
        ...
    }

    @Override
    public void onPopularMoviesReceived(PopularMoviesApiResponse popularMovies) {
        popularMoviesView.hideLoading();
        popularMoviesView.showMovies(popularMovies.getResults());
    }
}</pre>

### Comunicación

Para este proyecto me he decidido por un sistema de _Message Buses_, este sistema es muy útil para hacer _Broadcast_ de eventos, o para comunicarse entre componentes, este último caso se ajusta a la perfección.

Básicamente se **envían eventos** mediante un **Bus**, quienes estén interesados en recibir un evento determinado, se **suscriben** al Bus.

También se podría haber optado por la programación funcional o reactiva, pero eso lo vamos apartar para otro post :).

Utilizando un sistema de este tipo permitimos que los módulos tengan un **muy bajo acoplamiento**.

Para implementar el sistema de buses, he utilizado la librería [Otto](http://square.github.io/otto/ "Otto") de [Square](http://square.github.io/ "Square"), seguro que para los que nunca la hayan usado esta librería, el diagrama de un poco más arriba les ha llamado la atención :).

Declaramos dos buses, uno para la comunicación de los casos de uso con el cliente API REST (*REST_BUS*) y el otro para mandar eventos hacia la capa de presentación. (*UI_BUS*)

*REST_BUS* utilizará cualquier hilo para gestionar los eventos, mientras que *UI_BUS* mandará los eventos en el hilo por defecto de la librería, el hilo de la interfaz de usuario.
<pre class="brush: java; gutter: true; first-line: 1">public class BusProvider {

    private static final Bus REST_BUS = new Bus(ThreadEnforcer.ANY);
    private static final Bus UI_BUS = new Bus();

    private BusProvider() {};

    public static Bus getRestBusInstance() {
        return REST_BUS;
    }

    public static Bus getUIBusInstance () {
        return UI_BUS;
    }
}</pre>
Esta clase es gestionada por el módulo común, ya que todos los módulos han de tener acceso a ella para interactuar con los buses, este módulo no tendrá más dependencias que la propia librería de buses.
<pre class="brush: java; gutter: true; first-line: 1">dependencies {
    compile 'com.squareup:otto:1.3.5'
}</pre>
Para finalizar, imaginaros el siguiente ejemplo, un usuario abre la aplicación y se muestran las películas más populares.

El presentador, siempre que la vista llame al método _onCreate_ se registra al bus de la interfaz gráfica para poder recibir los eventos. Éste se da de baja cuando se llama al método _onStop()_. Posteriormente, ejecuta el caso de uso _GetMoviesUseCase_.
<pre class="brush: java; gutter: true; first-line: 1">@Override
public void onCreate() {

    BusProvider.getUIBusInstance().register(this);
    Usecase getPopularShows = new GetMoviesUsecaseController(GetMoviesUsecase.TV_MOVIES);
    getPopularShows.execute();
}
...
@Override
public void onStop() {

    BusProvider.getUIBusInstance().unregister(this);
}</pre>
El caso de uso _GetMoviesUsecase_, al recibir las películas envía un evento por el bus de la interfaz gráfica:
<pre class="brush: java; gutter: true; first-line: 1">@Override
public void sendShowsToPresenter() {
...
    BusProvider.getUIBusInstance().post(moviesEvent);
}</pre>
Para que el presentador pueda recibir el evento, tiene que implementar un método que reciba por parámetro el **mismo tipo de dato** que se ha enviado por el Bus, además ha de llevar la anotación _**@Subscribe.**_
<pre class="brush: java; gutter: true; first-line: 1">@Subscribe
@Override
public void onPopularMoviesReceived(PopularMoviesApiResponse popularMovies) {
    popularMoviesView.hideLoading();
    popularMoviesView.showMovies(popularMovies.getResults());
}</pre>

###### Recursos interesantes:

[Architecting Android…The clean way?](http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/) - Fernando Cejas

[Effective Android UI](https://github.com/pedrovgs/EffectiveAndroidUI) - Pedro Vicente Gómez Sanchez

[Reactive programming and message buses for mobile](http://csaba.palfi.me/reactive-and-buses-for-mobile/) - Csaba Palfi

[The clean architecture](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Uncle Bob

[MVP Android](http://antonioleiva.com/mvp-android/) - Antonio Leiva