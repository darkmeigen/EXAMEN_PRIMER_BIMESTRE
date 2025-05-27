<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.productos.seguridad.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>E-Commerce Paradise Store</title>
    <link rel="stylesheet" href="estilos.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    <style>
        .logged-in {
            color: white;
            font-size: 1rem;
            margin-left: 20px;
            padding: 5px 10px;
            background-color: #4b1e8e;
            border-radius: 5px;
        }
        .nav-container {
            display: flex;
            justify-content: space-around;
            align-items: center;
            padding: 10px 0;
        }
        .nav-container a {
            color: #4b1e8e;
            text-decoration: none;
            font-size: 1.1rem;
            transition: color 0.3s;
        }
        .nav-container a:hover {
            color: #6b2eb8;
        }
        .logout-btn {
            display: inline-block;
            margin-left: 20px;
            margin-top: 5px;
            padding: 5px 10px;
            background-color: #ff4d4d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background-color: #e63939;
        }
        .brillo {
            animation: brillo 1s ease-in-out;
        }
        @keyframes brillo {
            0% { filter: brightness(100%); }
            50% { filter: brightness(150%); }
            100% { filter: brightness(100%); }
        }
    </style>
</head>
<body>
    <!-- TÍTULO COMO LOGO -->
    <h1 class="titulo-logo">E-COMMERCE PARADISE STORE</h1>

    <header>
        <div class="logo">
            <a href="index.jsp" tabindex="0">
                <img src="fotos/e.png" alt="Logo">
            </a>
        </div>

        <nav class="nav-container" role="navigation">
            <a href="productos1.jsp" tabindex="0">CONOCE NUESTROS PRODUCTOS</a>
            <a href="productos.jsp" tabindex="0">BUSCALOS POR CATEGORIA</a>
            <a href="carrito.jsp" tabindex="0">CARRITO</a>
            <% 
                HttpSession sesion = request.getSession();
                if (sesion.getAttribute("usuarioLogeado") != null && (Boolean)sesion.getAttribute("usuarioLogeado")) {
                    String nombreUsuario = (String) sesion.getAttribute("usuario");
            %>
                <div style="display: flex; flex-direction: column; align-items: center;">
                    <span class="logged-in">Logeado como <%= nombreUsuario %></span>
                    <a href="cerrarsesion.jsp" class="logout-btn" tabindex="0">Cerrar sesión</a>
                </div>
            <% } else { %>
                <a href="login.jsp" tabindex="0">INICIAR SESIÓN</a>
            <% } %>
        </nav>
    </header>

    <main>
        <section class="contenido-principal">
            <div class="imagenes">
                <img src="fotos/inicio1.jpeg" alt="Inicio 1">
                <img src="fotos/inicio2.jpeg" alt="Inicio 2">
                <img src="fotos/inicio.jpeg" alt="Inicio 3">
            </div>
            <div class="info-mapa-container">
                <div class="info-box card">
                    <h2>Sobre Nosotros</h2>
                    <div id="salida">
                        <p>
                            Bienvenidos a E-Commerce Paradise Store, tu destino para productos únicos y de calidad. 
                            Nos especializamos en ofrecer una experiencia de compra excepcional con una amplia 
                            gama de productos innovadores. Nuestra pasión es conectar con nuestros clientes 
                            y brindarles lo mejor en tecnología y estilo.
                        </p>
                    </div>
                </div>
                <div class="mapa">
                    <iframe src="https://www.google.com/maps/d/embed?mid=1MRn_qx3U58fLb8hIRJWAJFJpqT8cERE&ehbc=2E312F" width="400" height="300" tabindex="0" aria-label="Mapa de ubicación"></iframe>
                </div>
            </div>
        </section>

        <section class="contacto">
            <div class="contacto-titulo card">
                <p>CONTÁCTANOS</p>
            </div>
            <div class="contacto-info">
                <p>
                    - POMASQUI CDLA SSR DEL ÁRBOL<br>
                    - 0987971770<br>
                    - JFBAEZ05@GMAIL.COM
                </p>
            </div>
            <div class="contacto-quienes">
                <h2><p>¿Qué somos?</p></h2>
                <p>Somos más que una tienda, somos un santuario digital para los amantes del mundo geek, mágico, gamer y fantástico.</p>
                <p>En Paradise Store, la nostalgia se combina con el diseño, y la cultura pop cobra vida en forma de llaveros únicos, hechos para auténticos fanáticos de:</p>
                <p>- Universos mágicos</p>
                <p>- Videojuegos legendarios</p>
                <p>- Series que marcan generaciones</p>
                <p>- Aventuras épicas de todos los rincones del multiverso</p>
                
                <h2><p>¿Qué ofrecemos?</p></h2>
                <p>Una experiencia de compra mágica y personalizada, con productos de calidad que no encontrarás en tiendas comunes. Aquí no vendemos solo accesorios, vendemos fragmentos de mundos que te apasionan.</p>
                <p>Calidad y detalle en cada envío</p>
                <p>Cada producto está hecho con mimo, y cada paquete se prepara como si fuera un cofre de tesoro esperando ser abierto.</p>
                
                <h2><p>Nuestra misión</p></h2>
                <p>Crear una comunidad donde puedas expresar quién eres a través de lo que llevas contigo… incluso si es "solo un llavero". Porque en Paradise Store, los detalles pequeños cuentan historias grandes.</p>
            </div>
        </section>
    </main>

    <footer>
        <a href="https://www.instagram.com/juan._.ferb10/" target="_blank" tabindex="0">
            <img src="iconos/instagram.png" alt="Instagram">
        </a>
        <a href="https://www.linkedin.com/in/darkmeigen-baez-788970328/" target="_blank" tabindex="0">
            <img src="iconos/linkedin1.png" alt="LinkedIn">
        </a>
        <a href="https://www.tiktok.com/@juanferbaez100?_t=ZM-8vV9HiAS4bn&_r=1" target="_blank" tabindex="0">
            <img src="iconos/tiktok.png" alt="TikTok">
        </a>
    </footer>

    <!-- Botón y script para narrador -->
    <button id="hablar" style="position: fixed; bottom: 20px; right: 20px; padding: 10px 20px; background-color: rgb(113, 129, 255); color: white; border: none; border-radius: 5px; cursor: pointer;" tabindex="0">Activar Narrador
    </button>
    <script>
        let oyendo = false;
        let carta = document.querySelector('.info-box'); // Ajusta este selector según el elemento que quieras que brille
        let hablar = document.getElementById("hablar");

        hablar.addEventListener("click", () => {
            if (!oyendo) {
                oyendo = true;
                hablar.style.backgroundColor = "rgb(113, 255, 163)";
                carta.classList.add('brillo');
                setTimeout(() => {
                    carta.classList.remove('brillo');
                }, 1000);

                let texto = document.getElementById("salida").innerText;

                decir(texto);
            } else {
                speechSynthesis.cancel();
                hablar.style.backgroundColor = "rgb(113, 129, 255)";
                oyendo = false;
            }
        });

        function decir(texto) {
            var mensaje = new SpeechSynthesisUtterance(texto);
            const voces = window.speechSynthesis.getVoices();
            mensaje.onend = function () {
                oyendo = false;
                hablar.style.backgroundColor = "rgb(255, 253, 113)";
            };
            mensaje.volume = 1;
            speechSynthesis.speak(mensaje);
        }
    </script>
</body>
</html>