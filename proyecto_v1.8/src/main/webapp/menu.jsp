<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" import="com.productos.seguridad.*, java.util.*" %>
<%
    HttpSession sesion = request.getSession();

    if (sesion.getAttribute("usuario") == null) {
        session.setAttribute("mensaje", "Debe iniciar sesión primero.");
        response.sendRedirect("login.jsp");
        return;
    } else {
        String nombreUsuario = (String) sesion.getAttribute("usuario");
        Integer perfil = (Integer) sesion.getAttribute("perfil");

        Pagina pag = new Pagina();
        String menuHTML = pag.mostrarMenu(perfil);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menú principal</title>
    <link rel="stylesheet" href="css/c1.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="estilos.css">
    <style>
        /* Estilos personalizados para el menú */
        .menu-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 20px 0;
        }
        .menu-btn {
            background-color: #4b1e8e;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-family: 'Orbitron', sans-serif;
            font-size: 1.2rem;
            transition: transform 0.3s, background-color 0.3s;
        }
        .menu-btn:hover {
            transform: scale(1.1);
            background-color: #6b2eb8;
        }
        /* Estilo para los datos de sesión */
        #datos-sesion {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
            margin: 20px auto;
            max-width: 400px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        #datos-sesion p {
            margin: 5px 0;
            color: #333;
        }
        header {
            text-align: center;
            padding: 10px;
            background-color: #4b1e8e;
            color: white;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Bienvenido <%= nombreUsuario %></h1>
    </header>

    <nav class="menu-container">
        <% if (perfil == 2) { // Perfil de cliente %>
            <a href="index.jsp" class="menu-btn">VOLVER AL INICIO</a>
            <a href="productos.jsp" class="menu-btn">Ir a Productos</a>
        <% } else { %>
            <%= menuHTML %>
        <% } %>
    </nav>

    <div id="datos-sesion">
        <h2>Datos de la sesión</h2>
        <%
            Date creacion = new Date(sesion.getCreationTime());
            Date ultimoAcceso = new Date(sesion.getLastAccessedTime());
            String idSesion = sesion.getId();
        %>
        <p><strong>ID de sesión:</strong> <%= idSesion %></p>
        <p><strong>Creación:</strong> <%= creacion %></p>
        <p><strong>Último acceso:</strong> <%= ultimoAcceso %></p>
    </div>

    <footer style="text-align: center; padding: 10px; background-color: #4b1e8e; color: white; border-radius: 8px; margin-top: 20px;">
        <p>© 2025 Paradise Store - Todos los derechos reservados.</p>
    </footer>
</body>
</html>
<%
    }
%>