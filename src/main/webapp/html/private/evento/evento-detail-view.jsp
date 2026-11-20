<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Detalle del evento</title>
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
            <c:set var="evento" value="${requestScope.evento}"/>
            <article class="panel evento-detalle" aria-labelledby="evento-detalle-titulo">
                <h1 id="evento-detalle-titulo">Detalle del evento</h1>
                <c:choose>
                    <c:when test="${empty evento}">
                        <p>No se ha seleccionado ningún evento.</p>
                    </c:when>
                    <c:otherwise>
                        <dl class="evento-datos">
                            <div><dt>Crotal</dt><dd><c:out value="${evento.crotal}"/></dd></div>
                            <div><dt>Fecha y hora</dt><dd><fmt:formatDate value="${evento.fechaDesde}" pattern="dd/MM/yyyy HH:mm"/></dd></div>
                            <div><dt>Tipo de evento</dt><dd><c:out value="${fn:toUpperCase(fn:substring(evento.nombreTipoEvento, 0, 1))}${fn:substring(evento.nombreTipoEvento, 1, fn:length(evento.nombreTipoEvento))}"/></dd></div>
                            <div><dt>Veterinario</dt><dd><c:choose>
                                <c:when test="${empty evento.veterinarioId}">Sin veterinario registrado</c:when>
                                <c:otherwise><c:out value="${evento.nombreVeterinario}"/> <c:out value="${evento.apellidoVeterinario}"/></c:otherwise>
                            </c:choose></dd></div>
                            <div class="evento-ancho"><dt>Descripción</dt><dd><c:out value="${evento.descripcion}"/></dd></div>
                            <c:if test="${not empty requestScope.especificaciones}">
                                <div class="evento-ancho"><dt>Especificaciones</dt><dd class="evento-texto"><c:out value="${requestScope.especificaciones}"/></dd></div>
                            </c:if>
                            <c:if test="${not empty evento.dosisId}">
                                <div><dt>Tratamiento</dt><dd><c:out value="${evento.nombreTratamieto}"/></dd></div>
                                <div><dt>Dosis</dt><dd><c:out value="${evento.numDosis}"/></dd></div>
                            </c:if>
                            <c:if test="${not empty evento.valorDiagnostico}">
                                <div><dt>Diagnóstico</dt><dd>${evento.valorDiagnostico eq 'P' ? 'Positivo' : 'Negativo'}</dd></div>
                            </c:if>
                        </dl>
                    </c:otherwise>
                </c:choose>
                <div class="evento-botones evento-detalle-botones">
                    <c:url var="eventosUrl" value="/evento"><c:param name="action" value="search"/></c:url>
                    <a class="btn secondary" href="<c:out value='${eventosUrl}'/>">Volver a Eventos</a>
                    <c:if test="${not empty evento and puedeGestionarEventos}">
                        <c:url var="editarUrl" value="/evento">
                            <c:param name="action" value="update"/>
                            <c:param name="id" value="${evento.id}"/>
                        </c:url>
                        <a class="btn primary" href="<c:out value='${editarUrl}'/>">Modificar</a>
                    </c:if>
                </div>
            </article>
        </main>
    </div>
</body>
</html>
