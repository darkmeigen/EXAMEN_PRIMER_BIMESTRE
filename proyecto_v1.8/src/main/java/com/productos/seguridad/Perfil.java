package com.productos.seguridad;

import com.productos.datos.Conexion;
import java.sql.ResultSet;

public class Perfil {
    public String mostrarPerfil() {
        StringBuilder opciones = new StringBuilder();
        String sql = "SELECT id_per, descripcion_per FROM tb_perfil WHERE descripcion_per != 'Cliente'";
        try {
            Conexion con = new Conexion();
            ResultSet rs = con.Consulta(sql);
            if (rs == null) {
                opciones.append("<option value=''>No se encontraron perfiles</option>");
            } else {
                while (rs.next()) {
                    opciones.append("<option value='").append(rs.getInt("id_per")).append("'>")
                            .append(rs.getString("descripcion_per")).append("</option>");
                }
                rs.close();
            }
            con.getConexion().close();
        } catch (Exception e) {
            System.out.println("Error en mostrarPerfil: " + e.getMessage());
            opciones.append("<option value=''>Error al cargar perfiles</option>");
        }
        return opciones.toString();
    }
}
