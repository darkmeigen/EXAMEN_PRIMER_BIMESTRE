<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login - Paradise Store</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body class="login-page">
    <header>
        <div class="logo">
            <a href="index.jsp" tabindex="0">
                <img src="fotos/e.png" alt="Logo">
            </a>
        </div>
        <h1 class="titulo-logo">INICIAR SESIÓN</h1>
        <nav class="nav-container" role="navigation">
            <a href="productos.jsp" tabindex="0">NUESTROS PRODUCTOS</a>
            <a href="carrito.jsp" tabindex="0">CARRITO</a>
            <a href="login.jsp" tabindex="0">INICIAR SESIÓN</a>
        </nav>
    </header>

    <%
        // Mostrar mensaje de redirección si existe
        String mensaje = (String) session.getAttribute("mensaje");
        if (mensaje != null) {
    %>
        <p style="color: red; text-align: center;"><%= mensaje %></p>
    <%
            session.removeAttribute("mensaje");
        }
    %>

    <form action="validarLogin.jsp" method="post" class="card">
        <input type="hidden" name="accion" value="login">
        
        <label>Correo electronico:</label>
        <input type="text" name="usuario" required tabindex="0">

        <label>Contraseña:</label>
        <div class="password-container">
            <input type="password" name="contrasena" id="contrasena" required tabindex="0">
            <img src="iconos/ojoCerrado.png" id="ojo" class="eye-icon" onclick="togglePassword()" alt="Mostrar contraseña" tabindex="0">
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <input type="submit" value="Ingresar" tabindex="0">
            <input type="reset" value="Limpiar" tabindex="0">
        </div>
        <p>¿No tienes cuenta? <a href="registro.jsp" tabindex="0">Regístrate aquí</a></p>
        <!-- <p>¿Olvidaste tu contraseña? <a href="CambiarClave.jsp">Cambiala aqui</a></p> -->
    </form>

    <script>
        function togglePassword() {
            const password = document.getElementById("contrasena");
            const eye = document.getElementById("ojo");
            if (password.type === "password") {
                password.type = "text";
                eye.src = "iconos/ojoAbierto.png";
            } else {
                password.type = "password";
                eye.src = "iconos/ojoCerrado.png";
            }
        }
    </script>
    <!-- Al final del <body>, después del formulario -->
<button id="hablar" style="position: fixed; bottom: 20px; right: 20px; padding: 10px 20px; background-color: rgb(113, 129, 255); color: white; border: none; border-radius: 5px; cursor: pointer;" tabindex="0">Narrar</button>
<div id="salida" style="display:none;">
    <p>Por favor, inicia sesión con tu correo electrónico y contraseña. Si no tienes cuenta, regístrate aquí.</p>
</div>
<script>
    let oyendo = false;
    let carta = document.querySelector('.card'); // Ajusta según el contenedor del formulario
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
<style>
    .brillo {
        animation: brillo 1s ease-in-out;
    }
    @keyframes brillo {
        0% { filter: brightness(100%); }
        50% { filter: brightness(150%); }
        100% { filter: brightness(100%); }
    }
</style>
</body>
</html>