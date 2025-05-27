<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cambiar Clave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="EstilosExtra.css">
</head>
<body>
 

    <div class="form-container">
        <h2>Cambiar Clave (Administrador)</h2>
        <%
            // Procesar el formulario (POST)
            String mensaje = null;
            Conexion con = new Conexion();
            try {
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String correo = request.getParameter("correo");
                    String nuevaClave = request.getParameter("nuevaClave");
                    String repetirClave = request.getParameter("repetirClave");

                    System.out.println("Procesando cambio de clave - Correo: " + correo + 
                                      ", Nueva Clave: " + nuevaClave);

                    // Validaciones
                    if (correo == null || nuevaClave == null || repetirClave == null ||
                        correo.isEmpty() || nuevaClave.isEmpty() || repetirClave.isEmpty()) {
                        mensaje = "<p class='error'>Todos los campos son obligatorios.</p>";
                    } else {
                        // Validar si el correo existe
                        PreparedStatement ps = con.getConexion().prepareStatement(
                            "SELECT correo_us FROM tb_usuario WHERE correo_us = ?");
                        ps.setString(1, correo);
                        ResultSet rs = ps.executeQuery();
                        if (!rs.next()) {
                            mensaje = "<p class='error'>El correo no está registrado.</p>";
                        } else if (!nuevaClave.equals(repetirClave)) {
                            mensaje = "<p class='error'>Las nuevas claves no coinciden.</p>";
                        } else {
                            // Actualizar la clave
                            PreparedStatement psUpdate = con.getConexion().prepareStatement(
                                "UPDATE tb_usuario SET clave_us = ? WHERE correo_us = ?");
                            psUpdate.setString(1, nuevaClave);
                            psUpdate.setString(2, correo);
                            int rows = psUpdate.executeUpdate();
                            if (rows > 0) {
                                mensaje = "<p class='success'>Clave actualizada</p>";
                            } else {
                                mensaje = "<p class='error'>Error al actualizar la clave.</p>";
                            }
                            psUpdate.close();
                        }
                        rs.close();
                        ps.close();
                    }
                }
            } catch (SQLException e) {
                mensaje = "<p class='error'>Error en la base de datos: " + e.getMessage() + "</p>";
                System.out.println("Error SQL: " + e.getMessage());
            } catch (Exception e) {
                mensaje = "<p class='error'>Error inesperado: " + e.getMessage() + "</p>";
                System.out.println("Error inesperado: " + e.getMessage());
            } finally {
                try {
                    if (con.getConexion() != null) con.getConexion().close();
                } catch (SQLException e) {
                    System.out.println("Error al cerrar conexión: " + e.getMessage());
                }
            }
        %>

        <% if (mensaje != null) { %>
            <%= mensaje %>
        <% } %>
        <form action="CambiarClave.jsp" method="post">
            <div class="form-group">
                <label for="correo">Correo Electrónico:</label>
                <input type="email" id="correo" name="correo" required>
            </div>
            <div class="form-group">
                <label for="nuevaClave">Nueva Clave:</label>
                <input type="password" id="nuevaClave" name="nuevaClave" required>
            </div>
            <div class="form-group">
                <label for="repetirClave">Repetir Nueva Clave:</label>
                <input type="password" id="repetirClave" name="repetirClave" required>
            </div>
            <div class="form-group button-group">
                <button type="submit">Cambiar Clave</button>
                <button type="reset">Limpiar</button>
            </div>
        </form>
        <div class="change-password-container">
            <a href="registroUsuarios.jsp" class="change-password-btn">Volver a Registro</a>
        </div>
    </div>
</body>
</html>