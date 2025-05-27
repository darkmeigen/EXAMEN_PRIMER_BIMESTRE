<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<%
    Conexion con = new Conexion();
    PreparedStatement ps = null;
    String mensaje = "error";

    try {
        String idPr = request.getParameter("id_pr");
        String nombre = request.getParameter("nombre");
        String idCat = request.getParameter("cmbCategoria");
        String cantidad = request.getParameter("cantidad");
        String precio = request.getParameter("precio");

        // Validaciones básicas
        if (idPr == null || nombre == null || idCat == null || cantidad == null || precio == null ||
            idPr.isEmpty() || nombre.isEmpty() || idCat.isEmpty() || cantidad.isEmpty() || precio.isEmpty()) {
            mensaje = "error";
        } else {
            String sql = "UPDATE tb_producto SET nombre_pr = ?, id_cat = ?, cantidad_pr = ?, precio_pr = ? WHERE id_pr = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setInt(2, Integer.parseInt(idCat));
            ps.setInt(3, Integer.parseInt(cantidad));
            ps.setDouble(4, Double.parseDouble(precio));
            ps.setInt(5, Integer.parseInt(idPr));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                mensaje = "success";
            }
        }
    } catch (SQLException e) {
        System.out.println("Error al actualizar producto: " + e.getMessage());
        mensaje = "error";
    } catch (Exception e) {
        System.out.println("Error inesperado: " + e.getMessage());
        mensaje = "error";
    } finally {
        Conexion.closeResources(null, ps);
        con.close();
    }

    // Redirigir a IngresarProducto.jsp con mensaje
    response.sendRedirect("IngresarProducto.jsp?mensaje=" + mensaje);
%>