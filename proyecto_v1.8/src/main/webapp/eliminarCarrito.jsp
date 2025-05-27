<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.productos.datos.Conexion, java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Eliminar del Carrito</title>
</head>
<body>
    <%
        String idCarritoStr = request.getParameter("id_carrito");
        if (idCarritoStr != null) {
            int idCarrito = Integer.parseInt(idCarritoStr);
            Conexion con = new Conexion();
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                conn = con.getConexion();
                if (conn == null) {
                    throw new SQLException("No se pudo conectar a la base de datos.");
                }
                String sql = "DELETE FROM tb_carrito WHERE id_carrito = ? AND id_estado = 1";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idCarrito);
                int filas = ps.executeUpdate();
                if (filas > 0) {
                    session.setAttribute("mensaje", "Producto eliminado del carrito.");
                } else {
                    session.setAttribute("mensaje", "Error: El producto no se encontró o ya fue pagado.");
                }
            } catch (Exception e) {
                session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    session.setAttribute("mensaje", "Error al cerrar recursos: " + e.getMessage());
                }
            }
        } else {
            session.setAttribute("mensaje", "ID de carrito no válido.");
        }
        response.sendRedirect("carrito.jsp");
    %>
</body>
</html>