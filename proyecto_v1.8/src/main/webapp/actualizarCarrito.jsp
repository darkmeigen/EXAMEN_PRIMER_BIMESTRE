<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Actualizar Carrito</title>
</head>
<body>
    <%
        Conexion con = new Conexion();
        PreparedStatement ps = null;
        try {
            int idCarrito = Integer.parseInt(request.getParameter("id_carrito"));
            String accion = request.getParameter("accion");

            String sql = "";
            if ("aumentar".equals(accion)) {
                sql = "UPDATE tb_carrito SET cantidad = cantidad + 1 WHERE id_carrito = ?";
            } else if ("disminuir".equals(accion)) {
                sql = "UPDATE tb_carrito SET cantidad = GREATEST(cantidad - 1, 1) WHERE id_carrito = ?"; // No permite menos de 1
            } else if ("eliminar".equals(accion)) {
                sql = "DELETE FROM tb_carrito WHERE id_carrito = ?";
            }

            ps = con.prepareStatement(sql);
            ps.setInt(1, idCarrito);
            ps.executeUpdate();
        } catch (SQLException e) {
            out.println("Error al actualizar el carrito: " + e.getMessage());
        } finally {
            Conexion.closeResources(null, ps);
            con.close();
        }
        response.sendRedirect("carrito.jsp");
    %>
</body>
</html>