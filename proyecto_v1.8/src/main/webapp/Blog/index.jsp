<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html> 
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog sobre el Parque Natural de Sorteny</title>
    <link rel="stylesheet" href="estilos.css">
  
</head>
<body>

    <!-- Barra de navegación -->
    <nav>
        <a href="#inicio">Inicio</a>
        <a href="#mapa">Mapa</a>
        <a href="#datos">Datos</a>
        <a href="#actividades">Actividades</a>
    </nav>

    <!-- Encabezado -->
    <header id="inicio">
        <h1>¡Bienvenidos a mi rincón Andorrano!</h1>
        <section class="saludo">
            <h2>Acerca de mí</h2>
            <p>Saludos, mi nombre es Juan Baez y soy un estudiante en camino del aprendizaje web.<br>
               Quiero decir que es un honor poder compartir conocimientos de un tema que me gusta
               mucho como lo es Andorra.<br>
               Así que sean todos bienvenidos y disfruten de todos los contenidos.</p>
        </section>
        
        <hr>
        <p>Hoy los invito a sumergirse en una aventura por uno de los destinos naturales
        más cautivadores de la región. Acompáñenme en este viaje a través de posts que detallan
        cada aspecto de este paraíso. Les enseñaré mucho de su fauna, flora y datos curiosos que sé
        que serán de su agrado.</p>
    </header>
    
    
    <!-- Control de música -->
<section class="control-musica">
    <h2> presiona para musica </h2>
    <button onclick="toggleMusic()">Iniciar</button>
    <br><br>
    <button onclick="nextSong()">Siguiente </button>
    <br><br>
    <label for="volumeControl">Volumen:</label>
    <input type="range" id="volumeControl" min="0" max="1" step="0.01" value="0.5" onchange="changeVolume(this.value)">
    
    <audio id="player" preload="auto"></audio>
</section>

<script>
    // Lista de canciones
    const canciones = [
        "sonidos/minecraft.mp3",
        "sonidos/moog.mp3"
    ];

    let player = document.getElementById("player");
    let currentSong = 0;
    let isPlaying = false;

    function toggleMusic() {
        if (!isPlaying) {
            player.src = canciones[currentSong];
            player.play();
            isPlaying = true;
        } else {
            player.pause();
            isPlaying = false;
        }
    }

    function nextSong() {
        currentSong = (currentSong + 1) % canciones.length;
        player.src = canciones[currentSong];
        player.play();
        isPlaying = true;
    }

    function changeVolume(volume) {
        player.volume = volume;
    }
</script>
    

    <!-- Imagen principal -->
    <section class="imagen-principal">
        <img src="fotos/sorteny.jpg" alt="Parque Natural de Sorteny" class="img-principal">
    </section>

    <!-- Belleza -->
    <section class="informacion">
        <h2>La belleza de Sorteny</h2>
        <div>
            <p>La zona se sitúa en la encantadora parroquia de Ordino,
            en el pequeño pero vibrante país de Andorra. Cuenta con 1080 hectáreas. Llegar es parte del encanto:
            la travesía comienza tomando la carretera CG-3 en dirección a Ordino-Arcalís,
            para luego continuar por la CS-370.</p>
        </div>
        
        <div>
            <p>Este trayecto, repleto de paisajes sorprendentes, es el preludio
            ideal para lo que te espera en el destino. Cuenta con una
            altitud de 2915m. Es una ruta que te
            sumerge en la naturaleza andorrana desde el primer kilómetro,
            preparando tus sentidos para la experiencia única que está a punto
            de comenzar.</p>
        </div>
        
    </section>

    <!-- Reconocimiento -->
    <section class="informacion">
        <h2>Un reconocimiento internacional a la belleza natural</h2>
        <div>
            <p>En octubre de 2020 se dio un paso histórico: la zona fue
            declarada Reserva de la Biosfera por la UNESCO, en honor a su
            asombrosa riqueza ecológica.<br>
            Este reconocimiento resalta la
            importancia de preservar este tesoro natural.</p>
        </div>
        <div>
            <p>Aunque el anuncio se dio en
            2020, la proclamación del destino ya se respira en el ambiente,
            haciendo de cada excursión una experiencia enmarcada por la
            protección y el respeto a la naturaleza.</p>
        </div>
    </section>

    <!-- Mapa -->
    <section class="mapa" id="mapa">
        <h2>Ubicación del Parque Natural de Sorteny</h2>
        <div class="mapa-contenedor">
            <iframe src="https://www.google.com/maps/d/embed?mid=1s8tp6k21e7iG08wMSEUHol9h8Ar_onI&ehbc=2E312F&noprof=1"
                    width="540"
                    height="180"
                    style="border:0;"
                    allowfullscreen=""
                    loading="lazy"
                    referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </section>

    <!-- Flora y fauna -->
    <section class="informacion">
        <h2>Flora y Fauna</h2>
        <div>
            <p>Si eres un amante de la naturaleza, este destino es un
            auténtico paraíso botánico y faunístico. Con más de 700 especies
            de plantas, entre las cuáles destacan más de 50 especies endémicas
            de los Pirineos, el entorno es un mosaico de colores, aromas y
            texturas.</p>
        </div>
        <div>
            <p>Pero la magia no termina en la vegetación: la zona es
            también el hogar de animales tan singulares como gamuzas,
            marmotas, martas, corzos y jabalíes.</p>
        </div>
    </section>

    <!-- Imágenes -->
    <section class="imagenes">
        <div class="imagen-box">
            <img src="fotos/floraSorteny.jpg" alt="Flora" class="img-box">
            <p><strong>Flora</strong></p>
        </div>
        <div class="imagen-box">
            <img src="fotos/SenderoSorteny.jpg" alt="Sendero" class="img-box">
            <p><strong>Sendero</strong></p>
        </div>
        <div class="imagen-box">
            <img src="fotos/MontañasSorteny.jpg" alt="Montaña" class="img-box">
            <p><strong>Montaña</strong></p>
        </div>
    </section>

    <!-- Rutas y senderismo -->
    <section class="informacion">
        <h2>Rutas y Senderismo</h2>
        <div>
            <p>Con sus rutas perfectamente señalizadas, Sorteny ofrece experiencias de senderismo
            para todos los niveles. Cada recorrido regala postales naturales inolvidables.</p>
        </div>
    </section>

    <!-- Tabla de datos -->
    <section class="tabla-info" id="datos">
        <h2>Datos rápidos sobre Sorteny</h2>
        <table>
            <thead>
                <tr>
                    <th>Característica</th>
                    <th>Descripción</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Ubicación</td>
                    <td>Ordino, Andorra</td>
                </tr>
                <tr>
                    <td>Superficie</td>
                    <td>1.080 hectáreas</td>
                </tr>
                <tr>
                    <td>Altitud máxima</td>
                    <td>2.915 metros</td>
                </tr>
                <tr>
                    <td>Especies de fauna</td>
                    <td>Aprox. 700</td>
                </tr>
            </tbody>
        </table>
    </section>

    <hr>

    <!-- Lista de actividades -->
    <section class="lista-actividades" id="actividades">
        <h2>Actividades recomendadas</h2>
        <ol>
            <li>Senderismo entre praderas alpinas</li>
            <li>Observación de flora y fauna</li>
            <li>Fotografía de paisajes</li>
            <li>Relax en la naturaleza</li>
            <li>Visitas guiadas educativas</li>
        </ol>
    </section>

    <hr>

    <!-- Video -->
    <section class="video">
        <h3>Explora más sobre el Parque Natural de Sorteny</h3>
        <video controls>
            <source src="videos/sorteny.mp4" type="video/mp4">
        </video>
    </section>

    <!-- Botón a más info -->
    <section class="boton-experiencia">
        <a href="https://visitandorra.com/es/" target="_blank">
            <button>Mas info de andorra  <br>¡Dale click aquí! :D</button>
        </a>
    </section>
        <!-- Botón a más info -->
    <section class="boton-experiencia">
        <a href="https://www.ordinoarcalis.com/es/experiencias/parque-natural-valle-sorteny" target="_blank">
            <button>Si deseas más información acerca del parque <br>¡Dale click aquí! :D</button>
        </a>
    </section>
    
        <!-- Botón a más info -->
    <section class="boton-experiencia">
        <a href="https://es.wikipedia.org/wiki/Andorra" target="_blank">
            <button>Historia de Andorra <br>¡Dale click aquí! :D</button>
        </a>
    </section>
    

    <!-- Botón para formulario -->
    <section class="boton-formulario">
        <p>Ingresa a este formulario para demostrar tus conocimientos :D</p>
        <a href="formulario.jsp"><button>¡Demuestra lo aprendido!</button></a>
    </section>

    <hr>

</body>
</html>
