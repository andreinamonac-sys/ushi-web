<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Animales</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <fmt:setLocale value="es_ES" scope="page"/>
    <c:set var="seccionPanel" value="animales"/>
    <c:set var="rolAnimal" value="${sessionScope.usuario.nombreRol}"/>
    <c:set var="puedeGestionarAnimales" value="${sessionScope.usuario.rolId eq 1 or sessionScope.usuario.rolId eq 3}"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>
    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Animales"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main>
            <div class="page-title">
                <h1>Animales</h1>
                <c:if test="${puedeGestionarAnimales}">
                    <c:url var="nuevoAnimalUrl" value="/html/private/animal/nuevo-animal-form.jsp">
                        <c:param name="action" value="create"/>
                    </c:url>
                    <a class="btn primary evento-nuevo" href="<c:out value='${nuevoAnimalUrl}'/>">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>
                        Nuevo animal
                    </a>
                </c:if>
            </div>

            <%@ include file="/html/private/animal/animal-search.jsp" %>

            <c:if test="${not empty requestScope.animalError}">
                <p role="alert"><c:out value="${requestScope.animalError}"/></p>
            </c:if>
            <c:if test="${requestScope.results ne null}">
                <p>Animales encontrados: <c:out value="${requestScope.results.total}"/></p>
            </c:if>
            <div class="table-shell">
                <div class="table-scroll">
                    <table aria-label="Resultados de animales">
                        <thead>
                            <tr>
                                <th scope="col">Crotal</th>
                                <th scope="col">Tag asociado</th>
                                <th scope="col">Sexo</th>
                                <th scope="col">Nacimiento</th>
                                <th scope="col">Alta</th>
                                <th scope="col">Baja</th>
                                <th scope="col">Madre interna</th>
                                <th scope="col">ID interno</th>
                                <th scope="col">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty requestScope.results.pageResults}">
                                <tr><td colspan="9">
                                    ${requestScope.results eq null ? 'Aún no se ha realizado ninguna búsqueda.' : 'No hay animales que coincidan con los filtros.'}
                                </td></tr>
                            </c:if>
                            <c:forEach var="animal" items="${requestScope.results.pageResults}">
                                <c:url var="detalleAnimalUrl" value="/animal">
                                    <c:param name="action" value="detail"/>
                                    <c:param name="id" value="${animal.id}"/>
                                </c:url>
                                <tr>
                                    <td><a href="<c:out value='${detalleAnimalUrl}'/>"><c:out value="${animal.crotal}"/></a></td>
                                    <td class="mono"><c:out value="${requestScope.tagsPorAnimal[animal.id]}" default="—"/></td>
                                    <td><c:out value="${animal.sexoDescripcion}" default="—"/></td>
                                    <td><c:if test="${empty animal.fechaNacimiento}">—</c:if><fmt:formatDate value="${animal.fechaNacimiento}" pattern="dd/MM/yyyy"/></td>
                                    <td><c:if test="${empty animal.fechaAlta}">—</c:if><fmt:formatDate value="${animal.fechaAlta}" pattern="dd/MM/yyyy"/></td>
                                    <td><c:if test="${empty animal.fechaBaja}">—</c:if><fmt:formatDate value="${animal.fechaBaja}" pattern="dd/MM/yyyy"/></td>
                                    <td><c:out value="${animal.crotalMadreInterna}" default="—"/></td>
                                    <td><c:out value="${animal.id}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${puedeGestionarAnimales}">
                                                <div class="actions">
                                                    <c:url var="editarAnimalUrl" value="/animal">
                                                        <c:param name="action" value="update"/>
                                                        <c:param name="id" value="${animal.id}"/>
                                                    </c:url>
                                                    <a class="icon-btn" href="<c:out value='${editarAnimalUrl}'/>"
                                                       aria-label="Editar animal ${animal.id}" title="Editar">
                                                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m4 20 4.5-1 10-10a2.1 2.1 0 0 0-3-3l-10 10L4 20Z"/><path d="m14 7 3 3"/></svg>
                                                    </a>
                                                    <form method="post" action="<c:out value='${animalBuscarUrl}'/>"
                                                          onsubmit="return confirm('¿Eliminar este animal?')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${animal.id}">
                                                        <button class="icon-btn danger" type="submit"
                                                                aria-label="Eliminar animal ${animal.id}" title="Eliminar">
                                                            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M9 7V4h6v3M7 7l1 14h8l1-14M10 11v6M14 11v6"/></svg>
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
