<%@ include file="/html/public/common/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="evento" value="${requestScope.evento}"/>
<h1>Detalle del evento</h1>
<c:choose>
    <c:when test="${empty evento}"><p>No se ha seleccionado ning�n evento.</p></c:when>
    <c:otherwise>
        <dl>
            <dt>ID</dt><dd>
            <c:out value="${evento.id}"/></dd>
            <dt>Fecha</dt><dd>
            <fmt:formatDate value="${evento.fechaDesde}" pattern="dd/MM/yyyy HH:mm"/></dd>
            <dt>Tipo</dt>
            <dd><c:out value="${evento.nombreTipoEvento}"/></dd>
            <dt>Animal</dt>
            <dd><c:out value="${evento.animalNumRegistro}"/></dd>
            <dt>Descripci�n</dt>
            <dd><c:out value="${evento.descripcion}"/></dd>
            <dt>Veterinario</dt>
            <dd><c:out value="${evento.nombreVeterinario}"/> <c:out value="${evento.apellidoVeterinario}"/></dd>
        </dl>
    </c:otherwise>
</c:choose>
<a href="${pageContext.request.contextPath}/evento?action=search">Volver a eventos</a>
<%@ include file="/html/public/common/footer.jsp" %>
