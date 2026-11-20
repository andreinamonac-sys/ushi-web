<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Usuarios</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="usuarios"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>
    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Usuarios"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main>
            <div class="page-title">
                <div><p class="eyebrow">Administración</p><h1>Usuarios</h1><p>Gestiona el acceso y los permisos del equipo.</p></div>
                <c:if test="${sessionScope.usuario.rolId eq 1}">
                    <c:url var="nuevoUsuarioUrl" value="/html/private/usuario/nuevo-usuario-form.jsp"/>
                    <a class="btn primary" href="<c:out value='${nuevoUsuarioUrl}'/>">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>Nuevo usuario
                    </a>
                </c:if>
            </div>
            <c:choose>
                <c:when test="${sessionScope.usuario.rolId ne 1}">
                    <p role="alert">La gestión de usuarios está disponible para el administrador.</p>
                </c:when>
                <c:otherwise>
                    <%@ include file="/html/private/usuario/usuario-search.jsp" %>
                    <c:if test="${not empty requestScope.usuarioError}">
                        <p class="form-message form-message-error" role="alert"><c:out value="${requestScope.usuarioError}"/></p>
                    </c:if>
                    <c:if test="${not empty requestScope.usuarioMensaje}">
                        <p class="form-message" role="status"><c:out value="${requestScope.usuarioMensaje}"/></p>
                    </c:if>
                    <%-- UsuarioService.findByCriteria devuelve una List<UsuarioDTO>. --%>
                    <c:set var="usuariosListado" value="${requestScope.usuarios ne null ? requestScope.usuarios : requestScope.results}"/>
                    <c:choose>
                        <c:when test="${usuariosListado eq null}">
                            <p>Utiliza el buscador para consultar los usuarios.</p>
                        </c:when>
                        <c:when test="${empty usuariosListado}">
                            <p>No hay usuarios que coincidan con los filtros.</p>
                        </c:when>
                        <c:otherwise>
                            <section class="table-shell" aria-label="Usuarios encontrados">
                                <div class="table-scroll">
                                    <table>
                                        <thead><tr><th>DNI / NIE</th><th>Nombre</th><th>Apellidos</th><th>Email</th><th>Teléfono</th><th>Rol</th><th>Acciones</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="u" items="${usuariosListado}">
                                                <tr>
                                                    <td class="mono"><c:out value="${u.dniNie}"/></td>
                                                    <td><strong><c:out value="${u.nombre}"/></strong></td>
                                                    <td><c:out value="${u.apellido1}"/> <c:out value="${u.apellido2}"/></td>
                                                    <td><c:out value="${u.email}"/></td>
                                                    <td><c:out value="${u.telefono}" default="—"/></td>
                                                    <td><span class="badge ${u.rolId eq 1 ? 'green' : 'blue'}"><c:out value="${u.nombreRol}"/></span></td>
                                                    <td>
                                                        <div class="actions">
                                                            <c:url var="detalleUsuarioUrl" value="/private/usuario">
                                                                <c:param name="action" value="detail"/><c:param name="id" value="${u.id}"/>
                                                            </c:url>
                                                            <a class="icon-btn" href="<c:out value='${detalleUsuarioUrl}'/>" aria-label="Ver detalle del usuario ${u.id}" title="Ver detalle">
                                                                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="2.5"/></svg>
                                                            </a>
                                                            <form method="post" action="${pageContext.request.contextPath}/private/usuario" onsubmit="return confirm('¿Eliminar este usuario?')">
                                                                <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${u.id}">
                                                                <button class="icon-btn danger" type="submit" aria-label="Eliminar usuario ${u.id}" title="Eliminar">
                                                                    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M9 7V4h6v3M7 7l1 14h8l1-14M10 11v6M14 11v6"/></svg>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="pagination"><span>Mostrando <c:out value="${fn:length(usuariosListado)}"/> usuarios.</span></div>
                            </section>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </main>
        <footer>Ushi © 2026 - Monitorización ganadera en tiempo real</footer>
    </div>
</body>
</html>
