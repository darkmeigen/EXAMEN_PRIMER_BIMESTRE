<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<%
    String idAud = request.getParameter("id_aud");
    String message = "";
    boolean success = false;

    if (idAud != null && !idAud.isEmpty()) {
        Conexion con = new Conexion();
        PreparedStatement ps = null;
        try {
            String sql = "DELETE FROM auditoria.tb_auditoria WHERE id_aud = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idAud));
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                message = "Registro eliminado con éxito";
                success = true;
            } else {
                message = "No se encontró el registro con ID " + idAud;
                success = false;
            }
        } catch (SQLException e) {
            message = "Error al eliminar registro: " + e.getMessage();
            success = false;
        } catch (NumberFormatException e) {
            message = "ID inválido: " + e.getMessage();
            success = false;
        } finally {
            Conexion.closeResources(null, ps);
            con.close();
        }
    } else {
        message = "ID de registro no proporcionado";
        success = false;
    }

    response.sendRedirect("bitacora.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8") + "&success=" + success);
%>