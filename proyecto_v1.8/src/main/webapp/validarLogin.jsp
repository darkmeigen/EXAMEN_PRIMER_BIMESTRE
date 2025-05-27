<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" import="com.productos.seguridad.*"%>
<%
    request.setCharacterEncoding("UTF-8");

    Usuario usuario = new Usuario();
    String nlogin = request.getParameter("usuario");
    String nclave = request.getParameter("contrasena");
    HttpSession sesion = request.getSession(); // Se crea la variable de sesión

    boolean respuesta = usuario.verificarUsuario(nlogin, nclave);
    if (respuesta) {
        sesion.setAttribute("usuario", usuario.getNombre()); // Se añade atributo usuario
        sesion.setAttribute("perfil", usuario.getPerfil()); // Se añade atributo perfil
        sesion.setAttribute("usuarioLogeado", true); // Atributo requerido para los filtros
        sesion.setAttribute("idUsuario", usuario.getId()); // Atributo necesario para diferenciar carritos
        response.sendRedirect("menu.jsp"); // Se redirecciona a una página específica
    } else {
        sesion.setAttribute("mensaje", "Datos incorrectos. Vuelva a intentarlo.");
        response.sendRedirect("login.jsp");
    }
%>