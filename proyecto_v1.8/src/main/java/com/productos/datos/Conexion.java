package com.productos.datos;

import java.sql.*;

public class Conexion
{
	private Statement St; 
	private String driver;
	private String user;
	private String pwd;
	private String cadena;
	private Connection con;

	String getDriver()
	{
		return this.driver;
	}
	String getUser()
	{
		return this.user;
	}
	String getPwd()
	{
		return this.pwd;
	}
	String getCadena()
	{
		return this.cadena;
	}
	public Connection getConexion()
	{ 
		return this.con; 
	}
	
	public Conexion() {
		
		this.driver ="org.postgresql.Driver";
		this.user="postgres";
		this.pwd="1234";
		this.cadena="jdbc:postgresql://localhost:5432/db_productos";
		this.con=this.crearConexion();
		
	}
	
	Connection crearConexion()
	{
		try {
			Class.forName("org.postgresql.Driver");
			}
			catch (ClassNotFoundException e) {
			
			}
		
		try
		{
			Class.forName(getDriver()).newInstance();
			Connection con=DriverManager.getConnection(getCadena(),getUser(),getPwd());
			return con;
		}
	catch(Exception ee)
	{
		System.out.println("Error: " + ee.getMessage());
		return null;
	}
	}


	public String Ejecutar(String sql)
	{
	String error="";
	try
	{
	St=getConexion().createStatement();
	St.execute(sql);
	error="Datos insertados";
	}
	catch(Exception ex)
	{
	error = ex.getMessage();
	}
	return(error);
	}



	public ResultSet Consulta(String sql)
	{
	String error="";
	ResultSet reg=null;
	
	try
	{
	St=getConexion().createStatement();
	reg=St.executeQuery(sql);
	

	}
	catch(Exception ee)
	{
	error = ee.getMessage();
	}
	return(reg);
	}
	
	public PreparedStatement prepareStatement(String sql) throws SQLException {
        return getConexion().prepareStatement(sql);
    }
    
    public void close() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.out.println("Error al cerrar conexión: " + e.getMessage());
        }
    }
    
    // Método para ejecutar updates (insert, update, delete)
    public int ejecutarActualizacion(String sql) {
        try (Statement st = getConexion().createStatement()) {
            return st.executeUpdate(sql);
        } catch (SQLException e) {
            System.out.println("Error al ejecutar actualización: " + e.getMessage());
            return -1;
        }
    }
    
    // Método para cerrar recursos
    public static void closeResources(ResultSet rs, Statement st) {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}
