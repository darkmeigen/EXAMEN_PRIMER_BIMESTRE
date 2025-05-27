package com.productos.seguridad;
import com.productos.datos.Conexion;
import java.sql.ResultSet;

public class EstadoCivil {
    public String mostrarEstadoCivil() {
        StringBuilder opciones = new StringBuilder();
        String sql = "SELECT id_est, descripcion_est FROM tb_estadocivil";
        Conexion con = null;
        ResultSet rs = null;
        try {
            con = new Conexion();
            rs = con.Consulta(sql);
            if (rs == null) {
                System.out.println("ResultSet es null en mostrarEstadoCivil");
                opciones.append("<option value=''>No se encontraron estados civiles</option>");
            } else {
                int count = 0;
                while (rs.next()) {
                    count++;
                    opciones.append("<option value='").append(rs.getInt("id_est")).append("'>")
                            .append(rs.getString("descripcion_est")).append("</option>");
                }
                System.out.println("Estados civiles encontrados: " + count);
                if (count == 0) {
                    opciones.append("<option value=''>No hay estados civiles en la base de datos</option>");
                }
            }
        } catch (Exception e) {
            System.out.println("Error en mostrarEstadoCivil: " + e.getMessage());
            opciones.append("<option value=''>Error al cargar estados civiles: " + e.getMessage() + "</option>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (con != null) con.getConexion().close();
            } catch (Exception e) {
                System.out.println("Error al cerrar recursos en mostrarEstadoCivil: " + e.getMessage());
            }
        }
        return opciones.toString();
    }
}