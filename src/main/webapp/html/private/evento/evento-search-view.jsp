<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Eventos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="eventos"/>
    <c:set var="rolEvento" value="${sessionScope.usuario.nombreRol}"/>
    <c:set var="puedeGestionarEventos"
           value="${requestScope.puedeGestionarEventos ne null
                    ? requestScope.puedeGestionarEventos
                    : (sessionScope.usuario.rolId eq 1 or sessionScope.usuario.rolId eq 3)}"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>

    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Eventos"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>

        <main>
            <div class="page-title">
                <h1>Eventos</h1>
                <c:if test="${puedeGestionarEventos}">
                    <c:url var="nuevoEventoUrl" value="/evento">
                        <c:param name="action" value="create"/>
                    </c:url>
                    <a class="btn primary evento-nuevo" href="<c:out value='${nuevoEventoUrl}'/>">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>
                        Nuevo evento
                    </a>
                </c:if>
            </div>
            <%@ include file="/html/private/evento/evento-search.jsp" %>

            <c:if test="${not empty requestScope.eventoError}">
                <p role="alert"><c:out value="${requestScope.eventoError}"/></p>
            </c:if>

            <c:set var="results" value="${requestScope.results}"/>
            <c:if test="${not empty results}">
                <p>Encontrados <c:out value="${results.total}"/> eventos.</p>
                <c:choose>
                    <c:when test="${empty results.pageResults}">
                        <p>No hay eventos que coincidan con los filtros.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="table-shell">
                            <div class="table-scroll">
                                <table aria-label="Resultados de eventos">
                                    <thead>
                                        <tr>
                                            <th scope="col">Crotal</th>
                                            <th scope="col">Fecha</th>
                                            <th scope="col">Tipo de evento</th>
                                            <th scope="col">Descripción</th>
                                            <th scope="col">Veterinario</th>
                                            <th scope="col" class="eventos-columna-acciones">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="e" items="${results.pageResults}">
                                            <tr>
                                                <td><c:out value="${e.crotal}"/></td>
                                                <td><fmt:formatDate value="${e.fechaDesde}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td><c:out value="${fn:toUpperCase(fn:substring(e.nombreTipoEvento, 0, 1))}${fn:substring(e.nombreTipoEvento, 1, fn:length(e.nombreTipoEvento))}"/></td>
                                                <td><c:out value="${e.descripcion}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${empty e.veterinarioId}">—</c:when>
                                                        <c:otherwise><c:out value="${e.nombreVeterinario}"/> <c:out value="${e.apellidoVeterinario}"/></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="actions eventos-acciones">
                                                        <c:url var="detalleEventoUrl" value="/evento">
                                                            <c:param name="action" value="detail"/>
                                                            <c:param name="id" value="${e.id}"/>
                                                        </c:url>
                                                        <a class="icon-btn" href="<c:out value='${detalleEventoUrl}'/>"
                                                           aria-label="Ver detalle del evento ${e.id}" title="Ver detalle">
                                                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                                                <path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/>
                                                                <circle cx="12" cy="12" r="2.5"/>
                                                            </svg>
                                                        </a>
                                                        <c:if test="${puedeGestionarEventos}">
                                                            <form method="post" action="${pageContext.request.contextPath}/evento"
                                                                  data-confirmar-borrado>
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="id" value="${e.id}">
                                                                <input type="hidden" name="eventoCsrf" value="<c:out value='${sessionScope.eventoCsrf}'/>">
                                                                <button class="icon-btn danger" type="submit"
                                                                        aria-label="Eliminar evento ${e.id}" title="Eliminar">
                                                                    <svg viewBox="0 0 24 24" aria-hidden="true">
                                                                        <path d="M4 7h16M9 7V4h6v3m3 0-1 13H7L6 7m4 4v5m4-5v5"/>
                                                                    </svg>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <c:if test="${requestScope.totalPaginas gt 1}">
                            <c:url var="paginacionUrl" value="/evento">
                                <c:param name="action" value="search"/>
                                <c:param name="crotal" value="${param.crotal}"/>
                                <c:param name="fecha-desde" value="${param['fecha-desde']}"/>
                                <c:param name="fecha-hasta" value="${param['fecha-hasta']}"/>
                                <c:param name="tipo-evento-id" value="${param['tipo-evento-id']}"/>
                                <c:param name="veterinario-id" value="${param['veterinario-id']}"/>
                            </c:url>
                            <nav class="pagination" aria-label="Paginación de eventos">
                                <c:choose>
                                    <c:when test="${requestScope.paginaActual gt 1}">
                                        <a class="btn secondary" rel="prev"
                                           href="<c:out value='${paginacionUrl}'/>&amp;pagina=${requestScope.paginaActual - 1}">Anterior</a>
                                    </c:when>
                                    <c:otherwise><span aria-disabled="true">Anterior</span></c:otherwise>
                                </c:choose>
                                <span>Página ${requestScope.paginaActual} de ${requestScope.totalPaginas}</span>
                                <c:choose>
                                    <c:when test="${requestScope.paginaActual lt requestScope.totalPaginas}">
                                        <a class="btn secondary" rel="next"
                                           href="<c:out value='${paginacionUrl}'/>&amp;pagina=${requestScope.paginaActual + 1}">Siguiente</a>
                                    </c:when>
                                    <c:otherwise><span aria-disabled="true">Siguiente</span></c:otherwise>
                                </c:choose>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </main>
    </div>
</body>
</html>
