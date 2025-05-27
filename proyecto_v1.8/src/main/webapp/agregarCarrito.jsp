<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Agregar al Carrito</title>
</head>
<body>
    <%
        request.setCharacterEncoding("UTF-8");

        // Verificar si el usuario está logeado
        if (session.getAttribute("usuarioLogeado") == null || !(Boolean)session.getAttribute("usuarioLogeado")) {
            session.setAttribute("mensaje", "Debes estar logeado para agregar productos al carrito. Por favor, inicia sesión.");
            response.sendRedirect("login.jsp");
            return;
        }

        // Obtener el idUsuario de la sesión
        int idUsuario = 0;
        if (session.getAttribute("idUsuario") != null) {
            idUsuario = (Integer) session.getAttribute("idUsuario");
        } else {
            session.setAttribute("mensaje", "Error: No se encontró el ID de usuario en la sesión. Por favor, inicia sesión nuevamente.");
            response.sendRedirect("login.jsp");
            return;
        }

        Conexion con = new Conexion();
        PreparedStatement ps = null;
        try {
            int idPr = Integer.parseInt(request.getParameter("id_pr"));
            String nombrePr = java.net.URLDecoder.decode(request.getParameter("nombre_pr"), "UTF-8");
            String origen = request.getParameter("origen");

            String sql = "INSERT INTO tb_carrito (id_usuario, nombre_pr, cantidad, id_estado) VALUES (?, ?, 1, 1)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setString(2, nombrePr);
            ps.executeUpdate();

            // Redirigir según el origen
            if ("productos1.jsp".equals(origen)) {
                response.sendRedirect("productos1.jsp");
            } else {
                response.sendRedirect("productos.jsp");
            }
        } catch (SQLException e) {
            out.println("Error al agregar al carrito: " + e.getMessage());
        } catch (Exception e) {
            out.println("Error de codificación: " + e.getMessage());
        } finally {
            Conexion.closeResources(null, ps);
            con.close();
        }
    %>
</body>
</html>