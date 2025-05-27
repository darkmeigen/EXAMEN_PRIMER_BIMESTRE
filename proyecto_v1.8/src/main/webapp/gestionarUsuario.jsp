<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Procesar Acción de Usuario</title>
</head>
<body>
    <%
        Conexion con = new Conexion();
        String mensaje = null;
        try {
            String idStr = request.getParameter("id_us");
            String accion = request.getParameter("accion");

            if (idStr == null || accion == null) {
                mensaje = "Parámetros inválidos.";
            } else {
                int id = Integer.parseInt(idStr);
                String sql = "";

                switch (accion) {
                    case "bloquear":
                        sql = "UPDATE tb_usuario SET estado = 0 WHERE id_us = " + id;
                        break;
                    case "desbloquear":
                        sql = "UPDATE tb_usuario SET estado = 1 WHERE id_us = " + id;
                        break;
                    case "eliminar":
                        sql = "DELETE FROM tb_usuario WHERE id_us = " + id;
                        break;
                    default:
                        mensaje = "Acción no válida.";
                }

                if (sql != null && !sql.isEmpty()) {
                    int filas = con.ejecutarActualizacion(sql);
                    if (filas > 0) {
                        mensaje = "Acción realizada con éxito.";
                    } else {
                        mensaje = "No se pudo realizar la acción.";
                    }
                }
            }
        } catch (Exception e) {
            mensaje = "Error: " + e.getMessage();
        } finally {
            if (con.getConexion() != null) con.getConexion().close();
        }

        // Guardar el mensaje en la sesión y redirigir
        session.setAttribute("mensaje", mensaje);
        response.sendRedirect("registroUsuarios.jsp");
    %>
</body>
</html>