<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.seguridad.Usuario, com.productos.seguridad.EstadoCivil, com.productos.seguridad.Perfil, com.productos.datos.Conexion, java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestionar Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="EstilosExtra.css">
     <link rel="stylesheet" href="estilos.css">
    <style>
        .table-container {
            margin-top: 30px;
        }
        .action-btn {
            margin-right: 5px;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .success {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<header>
 <div class="logo">
        <a href="index.jsp">
            <img src="fotos/e.png" alt="Logo">
        </a>
    </div>
</header>
<body>
    <%!
        private boolean correoExists(String correo, Conexion con) {
            ResultSet rs = null;
            try {
                rs = con.Consulta("SELECT correo_us FROM tb_usuario WHERE correo_us = '" + correo + "'");
                return rs != null && rs.next();
            } catch (Exception e) {
                System.out.println("Error al verificar correo: " + e.getMessage());
                return false;
            } finally {
                try {
                    if (rs != null) rs.close();
                } catch (Exception e) {
                    System.out.println("Error al cerrar ResultSet: " + e.getMessage());
                }
            }
        }
    %>

    <%
        String mensaje = null;
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            Conexion con = new Conexion();
            try {
                String cedula = request.getParameter("cedula");
                String nombre = request.getParameter("nombre");
                String correo = request.getParameter("correo");
                String perfilStr = request.getParameter("perfil");
                String estadoCivilStr = request.getParameter("estadoCivil");

                System.out.println("Procesando registro - Cédula: " + cedula + ", Nombre: " + nombre + 
                                  ", Correo: " + correo + ", Perfil: " + perfilStr + 
                                  ", Estado Civil: " + estadoCivilStr);

                if (cedula == null || nombre == null || correo == null || perfilStr == null || estadoCivilStr == null) {
                    mensaje = "<p class='error'>Faltan parámetros en el formulario.</p>";
                } else if (!cedula.matches("\\d{10}")) {
                    mensaje = "<p class='error'>La cédula debe tener 10 dígitos numéricos.</p>";
                } else if (correoExists(correo, con)) {
                    mensaje = "<p class='error'>El correo ya está registrado.</p>";
                } else {
                    int perfil = Integer.parseInt(perfilStr);
                    int estadoCivil = Integer.parseInt(estadoCivilStr);
                    Usuario usuario = new Usuario();
                    boolean registrado = usuario.ingresarEmpleado(perfil, estadoCivil, cedula, nombre, correo);
                    if (registrado) {
                        mensaje = "<p class='success'>Usuario registrado correctamente.</p>";
                    } else {
                        mensaje = "<p class='error'>Error al registrar usuario. Revise los logs de Tomcat.</p>";
                    }
                }
            } catch (NumberFormatException e) {
                mensaje = "<p class='error'>Error: Los valores de perfil o estado civil no son válidos.</p>";
                System.out.println("Error de formato: " + e.getMessage());
            } catch (Exception e) {
                mensaje = "<p class='error'>Error inesperado: " + e.getMessage() + "</p>";
                System.out.println("Error inesperado: " + e.getMessage());
            } finally {
                try {
                    if (con.getConexion() != null) con.getConexion().close();
                } catch (Exception e) {
                    System.out.println("Error al cerrar conexión: " + e.getMessage());
                }
            }
        }
    %>

    <div class="container mt-5">
        <%
            String mensajeAccion = (String) session.getAttribute("mensaje");
            if (mensajeAccion != null) {
        %>
            <div class="alert <%= mensajeAccion.startsWith("Error") ? "alert-danger" : "alert-success" %> text-center" role="alert">
                <%= mensajeAccion %>
            </div>
        <%
                session.removeAttribute("mensaje");
            }
        %>
        <h2 class="text-center mb-4">Registrar Usuario</h2>
        <% if (mensaje != null) { %>
            <%= mensaje %>
        <% } %>
        <form action="registroUsuarios.jsp" method="post" class="form-container">
            <div class="form-group mb-3">
                <label for="cedula">Cédula:</label>
                <input type="text" id="cedula" name="cedula" class="form-control" required pattern="[0-9]{10}" 
                       title="La cédula debe tener 10 dígitos numéricos">
            </div>
            <div class="form-group mb-3">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" class="form-control" required>
            </div>
            <div class="form-group mb-3">
                <label for="correo">Correo:</label>
                <input type="email" id="correo" name="correo" class="form-control" required>
            </div>
            <div class="form-group mb-3">
                <label for="perfil">Perfil:</label>
                <select id="perfil" name="perfil" class="form-select" required>
                    <%= new Perfil().mostrarPerfil() %>
                </select>
            </div>
            <div class="form-group mb-3">
                <label for="estadoCivil">Estado Civil:</label>
                <select id="estadoCivil" name="estadoCivil" class="form-select" required>
                    <%= new EstadoCivil().mostrarEstadoCivil() %>
                </select>
            </div>
            <div class="form-group button-group text-center">
                <button type="submit" class="btn btn-primary">Registrar</button>
                <button type="reset" class="btn btn-secondary">Limpiar</button>
            </div>
        </form>
        <div class="change-password-container text-center mt-3">
            <a href="CambiarClave.jsp" class="btn btn-info">Cambiar Clave</a>
        </div>

        <!-- Sección de Gestión de Usuarios -->
        <div class="table-container">
            <h2 class="text-center mb-4">Gestionar Usuarios</h2>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Cédula</th>
                        <th>Correo</th>
                        <th>Perfil</th>
                        <th>Estado Civil</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Conexion con = new Conexion();
                        if (con.getConexion() == null) {
                            out.println("<tr><td colspan='8' class='error'>Error: No se pudo conectar a la base de datos.</td></tr>");
                        } else {
                            ResultSet rs = null;
                            try {
                                String sql = "SELECT id_us, nombre_us, cedula_us, correo_us, id_per, id_est, estado " +
                                            "FROM tb_usuario";
                                System.out.println("Ejecutando consulta: " + sql);
                                rs = con.Consulta(sql);
                                if (rs == null) {
                                    out.println("<tr><td colspan='8' class='error'>Error: La consulta devolvió null. Revise los logs de Tomcat.</td></tr>");
                                } else if (!rs.isBeforeFirst()) {
                                    out.println("<tr><td colspan='8' class='text-center'>No hay usuarios registrados.</td></tr>");
                                } else {
                                    while (rs.next()) {
                                        int id = rs.getInt("id_us");
                                        String nombre = rs.getString("nombre_us");
                                        String cedula = rs.getString("cedula_us");
                                        String correo = rs.getString("correo_us");
                                        int idPer = rs.getInt("id_per");
                                        int idEst = rs.getInt("id_est");
                                        int estado = rs.getInt("estado");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= nombre != null ? nombre : "Sin nombre" %></td>
                        <td><%= cedula != null ? cedula : "Sin cédula" %></td>
                        <td><%= correo != null ? correo : "Sin correo" %></td>
                        <td><%= idPer %></td>
                        <td><%= idEst %></td>
                        <td><%= estado == 1 ? "Activo" : "Bloqueado" %></td>
                        <td>
                            <% if (estado == 1) { %>
                                <form action="gestionarUsuario.jsp" method="post" style="display:inline;">
                                    <input type="hidden" name="id_us" value="<%= id %>">
                                    <input type="hidden" name="accion" value="bloquear">
                                    <button type="submit" class="btn btn-danger action-btn">Bloquear</button>
                                </form>
                            <% } else { %>
                                <form action="gestionarUsuario.jsp" method="post" style="display:inline;">
                                    <input type="hidden" name="id_us" value="<%= id %>">
                                    <input type="hidden" name="accion" value="desbloquear">
                                    <button type="submit" class="btn btn-success action-btn">Desbloquear</button>
                                </form>
                            <% } %>
                            <form action="gestionarUsuario.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="id_us" value="<%= id %>">
                                <input type="hidden" name="accion" value="eliminar">
                                <button type="submit" class="btn btn-warning action-btn">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                    <%
                                    }
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='8' class='error'>Error al cargar usuarios: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if (rs != null) rs.close();
                                if (con.getConexion() != null) con.getConexion().close();
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>