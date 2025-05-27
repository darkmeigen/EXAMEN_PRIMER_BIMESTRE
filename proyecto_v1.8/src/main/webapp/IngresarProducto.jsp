<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.Conexion, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ingresar Producto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="EstilosExtra.css">
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
    <h1 class="titulo-logo">E-COMMERCE PARADISE STORE</h1>

    <header>
        <div class="logo">
            <a href="index.jsp"><img src="fotos/e.png" alt="Logo"></a>
        </div>
        <nav class="nav-container">
            <a href="productos1.jsp">CONOCE NUESTROS PRODUCTOS</a>
            <a href="productos.jsp">BUSCALOS POR CATEGORIA</a>
            <a href="carrito.jsp">CARRITO</a>
            <a href="login.jsp">INICIAR SESIÓN</a>
        </nav>
    </header>

    <div class="form-container">
        <h2>Ingresar Producto</h2>
        <%
            String message = request.getParameter("message");
            String success = request.getParameter("success");
            if (message != null) {
                out.println("<div class='alert " + (success.equals("true") ? "alert-success" : "alert-danger") + "'>" + message + "</div>");
            }
        %>
        <form method="POST" action="ProcesarIngresoProducto.jsp">
            <input type="hidden" name="action" value="insert">
            <div class="form-group">
                <label for="nombre">Nombre del Producto:</label>
                <input type="text" id="nombre" name="nombre" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="cmbCategoria">Categoría:</label>
                <select id="cmbCategoria" name="cmbCategoria" class="form-control">
                    <%
                        Conexion conCat = new Conexion();
                        PreparedStatement psCat = null;
                        ResultSet rsCat = null;
                        try {
                            String sqlCat = "SELECT id_cat, descripcion_cat FROM tb_categoria";
                            psCat = conCat.prepareStatement(sqlCat);
                            rsCat = psCat.executeQuery();
                            while (rsCat.next()) {
                    %>
                                <option value="<%= rsCat.getInt("id_cat") %>"><%= rsCat.getString("descripcion_cat") %></option>
                    <%
                            }
                        } catch (SQLException e) {
                            out.println("Error al cargar categorías: " + e.getMessage());
                        } finally {
                            Conexion.closeResources(rsCat, psCat);
                            conCat.close();
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="cantidad">Cantidad:</label>
                <input type="number" id="cantidad" name="cantidad" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="precio">Precio:</label>
                <input type="number" step="0.01" id="precio" name="precio" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Ingresar Producto</button>
        </form>

        <h3>Lista de Productos</h3>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Categoría</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Conexion conProd = new Conexion();
                    PreparedStatement psProd = null;
                    ResultSet rsProd = null;
                    try {
                        String sqlProd = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr " +
                                        "FROM tb_producto p JOIN tb_categoria c ON p.id_cat = c.id_cat";
                        psProd = conProd.prepareStatement(sqlProd);
                        rsProd = psProd.executeQuery();
                        while (rsProd.next()) {
                %>
                            <tr>
                                <td><%= rsProd.getInt("id_pr") %></td>
                                <td><%= rsProd.getString("nombre_pr") %></td>
                                <td><%= rsProd.getString("descripcion_cat") %></td>
                                <td><%= rsProd.getInt("cantidad_pr") %></td>
                                <td><%= rsProd.getDouble("precio_pr") %></td>
                                <td>
                                    <a href="IngresarProducto.jsp?action=edit&id_pr=<%= rsProd.getInt("id_pr") %>" class="btn btn-warning">Modificar</a>
                                    <a href="ProcesarIngresoProducto.jsp?action=delete&id_pr=<%= rsProd.getInt("id_pr") %>" class="btn btn-danger" onclick="return confirm('¿Estás seguro de eliminar este producto?')">Eliminar</a>
                                </td>
                            </tr>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("Error al cargar productos: " + e.getMessage());
                    } finally {
                        Conexion.closeResources(rsProd, psProd);
                        conProd.close();
                    }
                %>
            </tbody>
        </table>

        <%
            if ("edit".equals(request.getParameter("action"))) {
                String idPrEdit = request.getParameter("id_pr");
                Conexion conEdit = new Conexion();
                PreparedStatement psEdit = null;
                ResultSet rsEdit = null;
                try {
                    String sqlEdit = "SELECT * FROM tb_producto WHERE id_pr = ?";
                    psEdit = conEdit.prepareStatement(sqlEdit);
                    psEdit.setInt(1, Integer.parseInt(idPrEdit));
                    rsEdit = psEdit.executeQuery();
                    if (rsEdit.next()) {
        %>
                        <h3>Modificar Producto</h3>
                        <form method="POST" action="ProcesarIngresoProducto.jsp">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id_pr" value="<%= rsEdit.getInt("id_pr") %>">
                            <div class="form-group">
                                <label for="nombre">Nombre del Producto:</label>
                                <input type="text" id="nombre" name="nombre" class="form-control" value="<%= rsEdit.getString("nombre_pr") %>" required>
                            </div>
                            <div class="form-group">
                                <label for="cmbCategoria">Categoría:</label>
                                <select id="cmbCategoria" name="cmbCategoria" class="form-control">
                                    <%
                                        Conexion conCatEdit = new Conexion();
                                        PreparedStatement psCatEdit = null;
                                        ResultSet rsCatEdit = null;
                                        try {
                                            String sqlCatEdit = "SELECT id_cat, descripcion_cat FROM tb_categoria";
                                            psCatEdit = conCatEdit.prepareStatement(sqlCatEdit);
                                            rsCatEdit = psCatEdit.executeQuery();
                                            while (rsCatEdit.next()) {
                                                boolean isSelected = rsCatEdit.getInt("id_cat") == rsEdit.getInt("id_cat");
                                    %>
                                                <option value="<%= rsCatEdit.getInt("id_cat") %>" <%= isSelected ? "selected" : "" %>><%= rsCatEdit.getString("descripcion_cat") %></option>
                                    <%
                                            }
                                        } catch (SQLException e) {
                                            out.println("Error al cargar categorías: " + e.getMessage());
                                        } finally {
                                            Conexion.closeResources(rsCatEdit, psCatEdit);
                                            conCatEdit.close();
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="cantidad">Cantidad:</label>
                                <input type="number" id="cantidad" name="cantidad" class="form-control" value="<%= rsEdit.getInt("cantidad_pr") %>" required>
                            </div>
                            <div class="form-group">
                                <label for="precio">Precio:</label>
                                <input type="number" step="0.01" id="precio" name="precio" class="form-control" value="<%= rsEdit.getDouble("precio_pr") %>" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Actualizar Producto</button>
                            <a href="IngresarProducto.jsp" class="btn btn-secondary">Cancelar</a>
                        </form>
        <%
                    }
                } catch (SQLException e) {
                    out.println("Error al cargar producto para editar: " + e.getMessage());
                } finally {
                    Conexion.closeResources(rsEdit, psEdit);
                    conEdit.close();
                }
            }
        %>
    </div>

    <!-- Código de UserSnap con depuración -->
    <script>
        console.log("Iniciando carga del script de UserSnap...");
        window.onUsersnapLoad = function(api) { 
            console.log("UserSnap cargado correctamente, inicializando widget...");
            api.init(); 
        };
        var script = document.createElement('script');
        script.defer = 1;
        script.src = 'https://widget.usersnap.com/global/load/66480ce5-b480-4aa8-bb0d-06f5441226e9?onload=onUsersnapLoad';
        script.onerror = function() {
            console.error("Error al cargar el script de UserSnap. Verifica el identificador o la conexión.");
        };
        document.getElementsByTagName('head')[0].appendChild(script);
    </script>
</body>
</html>