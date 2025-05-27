package com.productos.seguridad;

import java.sql.ResultSet;
import java.sql.SQLException;
import com.productos.datos.Conexion;

public class Pagina {
    // Método combinado que incluye el manejo de errores de la primera clase
    // y el atributo accesskey de la segunda
    public String mostrarMenu(Integer nperfil) {
        StringBuilder menu = new StringBuilder();
        String sql = "SELECT pag.id_pag, pag.descripcion_pag, pag.path_pag " +
                     "FROM tb_pagina pag, tb_perfil per, tb_perfilpagina pper " +
                     "WHERE pag.id_pag = pper.id_pag AND pper.id_per = per.id_per " +
                     "AND pper.id_per = " + nperfil;
        Conexion con = new Conexion();
        ResultSet rs = null;
        try {
            rs = con.Consulta(sql);
            if (rs == null) {
                System.out.println("ResultSet es null en mostrarMenu");
                return "<p>No se encontraron páginas para este perfil.</p>";
            }
            int count = 0;
            while (rs.next()) {
                count++;
                int idPag = rs.getInt("id_pag");
                String path = rs.getString("path_pag");
                String descripcion = rs.getString("descripcion_pag");
                // Combinamos: enlace con accesskey como en la segunda clase
                menu.append("<a href='").append(path)
                    .append("' accesskey='").append(idPag).append("'>")
                    .append(descripcion).append("</a> <br/>");
            }
            System.out.println("Páginas encontradas para perfil " + nperfil + ": " + count);
            if (count == 0) {
                menu.append("<p>No hay páginas asignadas a este perfil.</p>");
            }
        } catch (SQLException e) {
            System.out.println("Error en mostrarMenu: " + e.getMessage());
            menu.append("<p>Error al cargar el menú: ").append(e.getMessage()).append("</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (con.getConexion() != null) con.getConexion().close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos en mostrarMenu: " + e.getMessage());
            }
        }
        return menu.toString();
    }
}