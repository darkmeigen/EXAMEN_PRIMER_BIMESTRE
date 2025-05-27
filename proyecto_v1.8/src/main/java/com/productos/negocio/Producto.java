package com.productos.negocio;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.productos.datos.Conexion;

public class Producto {

    public String consultarTodo() {
        String sql = "SELECT * FROM tb_producto ORDER BY id_pr";
        Conexion con = new Conexion();
        String tabla = "<table border=2><th>ID</th><th>Producto</th><th>Cantidad</th><th>Precio</th>";
        ResultSet rs = null;
        rs = con.Consulta(sql);
        try {
            while (rs.next()) {
                if (rs != null) {
                    tabla += "<tr><td>" + rs.getInt(1) + "</td>"
                           + "<td>" + rs.getString(3) + "</td>"
                           + "<td>" + rs.getInt(4) + "</td>"
                           + "<td>" + rs.getDouble(5) + "</td>"
                           + "</td></tr>";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.print(e.getMessage());
        }
        tabla += "</table>";
        return tabla;
    }

    public String buscarProductoCategoria(int cat) {
        String sentencia = "SELECT id_pr, nombre_pr, cantidad_pr, precio_pr, foto_pr FROM tb_producto WHERE id_cat = " + cat; // Añadimos foto_pr
        Conexion con = new Conexion();
        ResultSet rs = null;
        String resultado = "<table border=3>";
        try {
            rs = con.Consulta(sentencia);
            while (rs.next()) {
                int id = rs.getInt("id_pr");
                String nombre = rs.getString("nombre_pr");
                int cantidad = rs.getInt("cantidad_pr");
                double precio = rs.getDouble("precio_pr");
                String fotoPr = rs.getString("foto_pr");
                String imagenSrc = (fotoPr != null && !fotoPr.isEmpty()) ? "productos/" + fotoPr : "fotos/no-image.png";
                resultado += "<tr><td>" + id + "</td><td><img src='" + imagenSrc + "' alt='" + nombre + "' style='max-width: 150px; max-height: 150px;'></td><td>" + nombre + "</td><td>" + cantidad + "</td><td>" + precio + "</td></tr>";
            }
            resultado += "</table>";
        } catch (SQLException e) {
            System.out.print(e.getMessage());
        }
        System.out.print(resultado);
        return resultado;
    }
}