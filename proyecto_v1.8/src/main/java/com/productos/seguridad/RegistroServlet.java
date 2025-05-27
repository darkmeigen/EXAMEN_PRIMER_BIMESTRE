package com.productos.seguridad;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegistroServlet")
@MultipartConfig
public class RegistroServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener los parámetros del formulario
        String nombre = request.getParameter("txtNombre");
        String cedula = request.getParameter("txtCedula");
        String correo = request.getParameter("txtCorreo");
        String estadoCivil = request.getParameter("cmbEstadoCivil");

        // Manejar valores nulos
        nombre = (nombre != null) ? nombre : "";
        cedula = (cedula != null) ? cedula : "";
        correo = (correo != null) ? correo : "";
        estadoCivil = (estadoCivil != null) ? estadoCivil : "";

        // Depuración: Imprimir valores en la consola del servidor
        System.out.println("Valores recibidos en RegistroServlet - Nombre: " + nombre + ", Cédula: " + cedula + 
                           ", Correo: " + correo + ", Estado Civil: " + estadoCivil);

        // Pasar los datos a respuesta.jsp
        request.setAttribute("nombre", nombre);
        request.setAttribute("cedula", cedula);
        request.setAttribute("correo", correo);
        request.setAttribute("estadoCivil", estadoCivil);

        // Redirigir a respuesta.jsp
        request.getRequestDispatcher("respuesta.jsp").forward(request, response);
    }
}