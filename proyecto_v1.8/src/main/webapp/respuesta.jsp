<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.productos.seguridad.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Confirmación de Registro - Paradise Store</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
<h1 class="titulo-logo">CONFIRMACIÓN DE REGISTRO</h1>

<div class="logo">
    <a href="index.jsp">
        <img src="fotos/e.png" alt="Logo">
    </a>
</div>

<div class="card" style="max-width: 600px; margin: auto;">
    <h2>Tus datos ingresados son:</h2>
    <%
        // Obtener los datos directamente con getParameter
        String nombre = request.getParameter("txtNombre");
        String cedula = request.getParameter("txtCedula");
        String correo = request.getParameter("txtCorreo");
        String clave = request.getParameter("txtClave"); // Nuevo: obtener la clave
        String estadoCivil = request.getParameter("cmbEstadoCivil");

        // Manejar valores nulos
        nombre = (nombre != null) ? nombre : "";
        cedula = (cedula != null) ? cedula : "";
        correo = (correo != null) ? correo : "";
        clave = (clave != null) ? clave : "";
        estadoCivil = (estadoCivil != null) ? estadoCivil : "";

        // Validar correo
        String correoRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        if (!correo.matches(correoRegex)) {
            session.setAttribute("mensaje", "Error: El correo no es válido.");
            response.sendRedirect("registro.jsp");
            return;
        }

        // Validar que el correo no esté registrado
        Usuario usuario = new Usuario();
        if (usuario.verificarClave("no_existe", correo)) {
            session.setAttribute("mensaje", "Error: El correo ya está registrado. Por favor, usa otro.");
            response.sendRedirect("registro.jsp");
            return;
        }

        // Validar longitud de la clave
        if (clave.length() < 8) {
            session.setAttribute("mensaje", "Error: La contraseña debe tener al menos 8 caracteres.");
            response.sendRedirect("registro.jsp");
            return;
        }

        // Convertir estado civil a número
        int idEstadoCivil = 0;
        switch (estadoCivil) {
            case "Casado":
                idEstadoCivil = 1;
                break;
            case "Soltero":
                idEstadoCivil = 2;
                break;
            case "Divorciado":
                idEstadoCivil = 3;
                break;
            
        }

        // Depuración
        System.out.println("Valores en respuesta.jsp - Nombre: " + nombre + ", Cédula: " + cedula + 
                           ", Correo: " + correo + ", Clave: " + clave + ", Estado Civil: " + estadoCivil);
    %>
    <p><strong>Nombre:</strong> <%= nombre %></p>
    <p><strong>Cédula:</strong> <%= cedula %></p>
    <p><strong>Correo Electrónico:</strong> <%= correo %></p>
    <p><strong>Estado Civil:</strong> <%= estadoCivil %></p>

    <form action="guardarUsuario.jsp" method="post" style="margin-top: 20px;">
        <input type="hidden" name="nombre" value="<%= nombre %>">
        <input type="hidden" name="cedula" value="<%= cedula %>">
        <input type="hidden" name="correo" value="<%= correo %>">
        <input type="hidden" name="clave" value="<%= clave %>"> <!-- Nuevo: enviar la clave -->
        <input type="hidden" name="estadoCivil" value="<%= idEstadoCivil %>">
        <input type="submit" value="Confirmar" class="btn bg-green-500 text-white font-semibold py-2 px-6 rounded-lg cursor-pointer hover:bg-green-600">
        <a href="registro.jsp" class="btn bg-red-500 text-white font-semibold py-2 px-6 rounded-lg cursor-pointer hover:bg-red-600">Rechazar</a>
    </form>
</div>
</body>
</html>