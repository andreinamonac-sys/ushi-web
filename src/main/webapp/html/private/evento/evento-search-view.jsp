<%@ include file="/html/public/common/header.jsp"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<h1>Eventos</h1>
<%@ include file="/html/private/evento/evento-search.jsp"%>

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
            <table>
                <thead><tr>
                    <th scope="col">ID</th><th scope="col">Fecha</th>
                    <th scope="col">Tipo</th><th scope="col">Animal</th>
                    <th scope="col">Descripción</th><th scope="col">Veterinario</th>
                    <th scope="col">Detalle</th>
                </tr></thead>
                <tbody>
                    <c:forEach var="e" items="${results.pageResults}">
                        <c:url var="detalleUrl" value="/evento">
                            <c:param name="action" value="detail"/>
                            <c:param name="id" value="${e.id}"/>
                        </c:url>
                        <tr>
                            <td><c:out value="${e.id}"/></td>
                            <td><fmt:formatDate value="${e.fechaDesde}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td><c:out value="${e.nombreTipoEvento}"/></td>
                            <td><c:out value="${e.animalNumRegistro}"/></td>
                            <td><c:out value="${e.descripcion}"/></td>
                            <td><c:out value="${e.nombreVeterinario}"/> <c:out value="${e.apellidoVeterinario}"/></td>
                            <td><a href="<c:out value='${detalleUrl}'/>">Ver detalle</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</c:if>
<%@ include file="/html/public/common/footer.jsp"%>
