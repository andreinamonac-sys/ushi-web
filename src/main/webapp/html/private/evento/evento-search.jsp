<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url var="eventoSearchUrl" value="/evento"/>
<c:url var="eventoSearchResetUrl" value="/evento">
    <c:param name="action" value="search"/>
</c:url>

<form action="${eventoSearchUrl}" method="get" class="buscador-evento filter-card">
    <input type="hidden" name="action" value="search">
    <div class="filter-grid">
        <label class="field" for="crotal">
            <span>Crotal</span>
            <input type="text" id="crotal" name="crotal" value="<c:out value='${param.crotal}'/>">
        </label>

        <label class="field" for="fecha-desde">
            <span>Desde</span>
            <input type="date" id="fecha-desde" name="fecha-desde"
                   value="<c:out value="${param['fecha-desde']}"/>">
        </label>

        <label class="field" for="fecha-hasta">
            <span>Hasta</span>
            <input type="date" id="fecha-hasta" name="fecha-hasta"
                   value="<c:out value="${param['fecha-hasta']}"/>">
        </label>

        <label class="field" for="tipo-evento-id">
            <span>Tipo de evento</span>
            <select id="tipo-evento-id" name="tipo-evento-id">
                <option value="">Todos los tipos</option>
                <c:forEach var="tipo" items="${requestScope['tipos-eventos']}">
                    <option value="${tipo.id}" ${param['tipo-evento-id'] eq tipo.id.toString() ? 'selected' : ''}>
                        <c:out value="${fn:toUpperCase(fn:substring(tipo.nombre, 0, 1))}${fn:substring(tipo.nombre, 1, fn:length(tipo.nombre))}"/>
                    </option>
                </c:forEach>
            </select>
        </label>

        <label class="field" for="veterinario-id">
            <span>Veterinario</span>
            <select id="veterinario-id" name="veterinario-id">
                <option value="">Todos los veterinarios</option>
                <c:forEach var="vet" items="${requestScope.veterinarios}">
                    <option value="${vet.id}" ${param['veterinario-id'] eq vet.id.toString() ? 'selected' : ''}>
                        <c:out value="${vet.nombre}"/> <c:out value="${vet.apellido1}"/>
                    </option>
                </c:forEach>
            </select>
        </label>
    </div>

    <div class="filter-actions actions">
        <a class="btn secondary" href="${eventoSearchResetUrl}">Limpiar filtros</a>
        <button class="btn primary" type="submit">Buscar eventos</button>
    </div>
</form>
