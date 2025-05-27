<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.productos.seguridad.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultado del Registro - Paradise Store</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
<h1 class="titulo-logo">RESULTADO DEL REGISTRO</h1>

<div class="logo">
    <a href="index.jsp">
        <img src="fotos/e.png" alt="Logo">
    </a>
</div>

<div class="card" style="max-width: 600px; margin: auto;">
    <%
        // Obtener los parámetros
        String nombre = request.getParameter("nombre");
        String cedula = request.getParameter("cedula");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        int estadoCivil = Integer.parseInt(request.getParameter("estadoCivil"));

        // Validar que los datos no sean nulos
        if (nombre == null || cedula == null || correo == null || clave == null) {
            session.setAttribute("mensaje", "Error: Datos incompletos.");
            response.sendRedirect("registro.jsp");
            return;
        }

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

        // Depuración
        System.out.println("Valores en guardarUsuario.jsp - Nombre: " + nombre + ", Cédula: " + cedula + 
                           ", Correo: " + correo + ", Clave: " + clave + ", Estado Civil (id): " + estadoCivil);

        // Crear instancia de la clase Usuario
        usuario.setNombre(nombre);
        usuario.setCedula(cedula);
        usuario.setCorreo(correo);
        usuario.setEstadoCivil(estadoCivil);
        usuario.setClave(clave); // Usar la clave proporcionada por el usuario

        // Guardar en la base de datos
        String resultado = usuario.ingresarCliente();

        if (resultado.equals("Inserción correcta")) {
    %>
    <h2>Registro Exitoso</h2>
    <p>Usuario registrado correctamente.</p>
    <a href="index.jsp" class="btn bg-blue-500 text-white font-semibold py-2 px-6 rounded-lg cursor-pointer hover:bg-blue-600">Volver al Inicio</a>
    <%
        } else {
    %>
    <h2>Error en el Registro</h2>
    <p>Error al registrar el usuario: <%= resultado %></p>
    <a href="registro.jsp" class="btn bg-red-500 text-white font-semibold py-2 px-6 rounded-lg cursor-pointer hover:bg-red-600">Intentar de Nuevo</a>
    <%
        }
    %>
</div>
</body>
</html>