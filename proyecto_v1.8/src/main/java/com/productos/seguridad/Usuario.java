package com.productos.seguridad;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.productos.datos.Conexion;

public class Usuario {
    private int id;
    private int perfil;
    private int estadoCivil;
    private String cedula;
    private String Nombre;
    private String Correo;
    private String clave;

    private static final String CLAVE_DEFAULT = "654321";

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPerfil() {
        return perfil;
    }

    public void setPerfil(int perfil) {
        this.perfil = perfil;
    }

    public int getEstadoCivil() {
        return estadoCivil;
    }

    public void setEstadoCivil(int estadoCivil) {
        this.estadoCivil = estadoCivil;
    }

    public String getCedula() {
        return cedula;
    }

    public void setCedula(String cedula) {
        this.cedula = cedula;
    }

    public String getNombre() {
        return Nombre;
    }

    public void setNombre(String nombre) {
        Nombre = nombre;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getCorreo() {
        return Correo;
    }

    public void setCorreo(String correo) {
        Correo = correo;
    }

    public boolean verificarUsuario(String ncorreo, String nclave) {
        boolean respuesta = false;
        String sentencia = "SELECT id_us, id_per, nombre_us, estado FROM tb_usuario WHERE correo_us = ? AND clave_us = ? AND estado = 1";
        Conexion clsCon = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = clsCon.getConexion().prepareStatement(sentencia);
            ps.setString(1, ncorreo);
            ps.setString(2, nclave);
            rs = ps.executeQuery();
            if (rs.next()) {
                respuesta = true;
                this.setId(rs.getInt("id_us"));
                this.setCorreo(ncorreo);
                this.setClave(nclave);
                this.setPerfil(rs.getInt("id_per"));
                this.setNombre(rs.getString("nombre_us"));
            }
        } catch (SQLException ex) {
            System.out.println("Error en verificarUsuario: " + ex.getMessage());
            respuesta = false;
        } finally {
            Conexion.closeResources(rs, ps);
            clsCon.close();
        }
        return respuesta;
    }

    public String ingresarCliente() {
        String result = "";
        Conexion con = new Conexion();
        PreparedStatement pr = null;
        String sql = "INSERT INTO tb_usuario (id_per, id_est, nombre_us, cedula_us, correo_us, clave_us) VALUES(?,?,?,?,?,?)";
        try {
            pr = con.getConexion().prepareStatement(sql);
            pr.setInt(1, 2); // Perfil Cliente
            pr.setInt(2, this.getEstadoCivil());
            pr.setString(3, this.getNombre());
            pr.setString(4, this.getCedula());
            pr.setString(5, this.getCorreo());
            pr.setString(6, this.getClave());
            if (pr.executeUpdate() == 1) {
                result = "Inserción correcta";
            } else {
                result = "Error en inserción";
            }
        } catch (Exception ex) {
            result = ex.getMessage();
            System.out.println("Error en ingresarCliente: " + ex.getMessage());
        } finally {
            try {
                if (pr != null) pr.close();
                if (con.getConexion() != null) con.getConexion().close();
            } catch (Exception ex) {
                System.out.println("Error al cerrar recursos en ingresarCliente: " + ex.getMessage());
            }
        }
        return result;
    }

    public boolean ingresarEmpleado(int nperfil, int nestado, String ncedula, String nnombre, String ncorreo) {
        Conexion con = new Conexion();
        PreparedStatement ps = null;
        String sql = "INSERT INTO tb_usuario (id_per, id_est, cedula_us, nombre_us, correo_us, clave_us) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            if (con.getConexion() == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            System.out.println("Ejecutando SQL: " + sql);
            System.out.println("Parámetros - nperfil: " + nperfil + ", nestado: " + nestado + ", ncedula: " + ncedula +
                             ", nnombre: " + nnombre + ", ncorreo: " + ncorreo + ", clave: 654321");
            ps = con.getConexion().prepareStatement(sql);
            ps.setInt(1, nperfil);
            ps.setInt(2, nestado); // id_est como estado civil
            ps.setString(3, ncedula);
            ps.setString(4, nnombre);
            ps.setString(5, ncorreo);
            ps.setString(6, "654321");
            int filas = ps.executeUpdate();
            System.out.println("Filas afectadas: " + filas);
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error SQL en ingresarEmpleado: " + e.getMessage());
            return false;
        } finally {
            Conexion.closeResources(null, ps);
            con.close();
        }
    }

    public boolean verificarClave(String aclave, String correo) {
        String sentencia = "SELECT clave_us FROM tb_usuario WHERE correo_us = ?";
        Conexion clsCon = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = clsCon.getConexion().prepareStatement(sentencia);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            if (rs.next()) {
                String claveBD = rs.getString("clave_us");
                return claveBD.equals(aclave);
            }
            return false;
        } catch (SQLException ex) {
            System.out.println("Error en verificarClave: " + ex.getMessage());
            return false;
        } finally {
            Conexion.closeResources(rs, ps);
            clsCon.close();
        }
    }

    public boolean cambiarClave(String ncorreo, String nclave) {
        Conexion con = new Conexion();
        PreparedStatement pr = null;
        String sql = "UPDATE tb_usuario SET clave_us = ? WHERE correo_us = ?";
        try {
            pr = con.getConexion().prepareStatement(sql);
            pr.setString(1, nclave);
            pr.setString(2, ncorreo);
            return pr.executeUpdate() == 1;
        } catch (SQLException ex) {
            System.out.println("Error en cambiarClave: " + ex.getMessage());
            return false;
        } finally {
            try {
                if (pr != null) pr.close();
                if (con.getConexion() != null) con.getConexion().close();
            } catch (Exception ex) {
                System.out.println("Error al cerrar recursos en cambiarClave: " + ex.getMessage());
            }
        }
    }
}