<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<%
    String action = request.getParameter("action");
    String idPr = request.getParameter("id_pr");
    String nombre = request.getParameter("nombre");
    String categoriaId = request.getParameter("cmbCategoria");
    String cantidad = request.getParameter("cantidad");
    String precio = request.getParameter("precio");
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) usuario = "Invitado";
    // Sanitizar el usuario para evitar inyecciones SQL
    usuario = usuario.replace("'", "''").replace(";", "");
    String message = "";
    boolean success = false;

    if ("POST".equalsIgnoreCase(request.getMethod()) || "GET".equalsIgnoreCase(request.getMethod())) {
        Conexion con = new Conexion();
        Connection conn = null;
        Statement stmt = null;
        PreparedStatement ps = null;
        try {
            // Obtener la conexión subyacente
            conn = con.getConexion();
            if (conn == null) {
                throw new SQLException("No se pudo obtener la conexión");
            }

            // Establecer el usuario de la sesión en la conexión
            stmt = conn.createStatement();
            String setUserSql = "SET custom.app_usuario = '" + usuario + "'";
            stmt.execute(setUserSql);
            stmt.close();

            // Proceder con la operación
            if (action == null || action.equals("insert")) {
                String sql = "INSERT INTO tb_producto (id_cat, nombre_pr, cantidad_pr, precio_pr) VALUES (?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(categoriaId));
                ps.setString(2, nombre);
                ps.setInt(3, Integer.parseInt(cantidad));
                ps.setDouble(4, Double.parseDouble(precio));
                ps.executeUpdate();
                message = "Producto ingresado con éxito";
                success = true;
            } else if (action.equals("update")) {
                String sql = "UPDATE tb_producto SET id_cat = ?, nombre_pr = ?, cantidad_pr = ?, precio_pr = ? WHERE id_pr = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(categoriaId));
                ps.setString(2, nombre);
                ps.setInt(3, Integer.parseInt(cantidad));
                ps.setDouble(4, Double.parseDouble(precio));
                ps.setInt(5, Integer.parseInt(idPr));
                ps.executeUpdate();
                message = "Producto actualizado con éxito";
                success = true;
            } else if (action.equals("delete")) {
                String sql = "DELETE FROM tb_producto WHERE id_pr = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idPr));
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Producto eliminado con éxito";
                    success = true;
                } else {
                    message = "No se encontró el producto con ID " + idPr;
                    success = false;
                }
            }
        } catch (SQLException e) {
            message = "Error al procesar producto: " + e.getMessage();
            success = false;
        } catch (NumberFormatException e) {
            message = "Error en datos numéricos: " + e.getMessage();
            success = false;
        } catch (Exception e) {
            message = "Error inesperado: " + e.getMessage();
            success = false;
        } finally {
            Conexion.closeResources(null, ps);
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            con.close();
        }
        response.sendRedirect("IngresarProducto.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8") + "&success=" + success);
    }
%>