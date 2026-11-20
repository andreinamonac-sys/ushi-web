<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Detalle del animal</title>
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
            <c:url var="animalListadoUrl" value="/html/private/animal/animal-search-view.jsp"/>
            <c:set var="animal" value="${requestScope.animal}"/>
            <article class="panel evento-detalle" aria-labelledby="animal-detalle-titulo">
                <h1 id="animal-detalle-titulo">Detalle del animal</h1>
                <c:choose>
                    <c:when test="${empty animal}">
                        <p>No se ha seleccionado ningún animal.</p>
                    </c:when>
                    <c:otherwise>
                        <dl class="evento-datos">
                            <div><dt>ID interno</dt><dd><c:out value="${animal.id}"/></dd></div>
                            <div><dt>Crotal</dt><dd><c:out value="${animal.crotal}"/></dd></div>
                            <div><dt>Sexo</dt><dd><c:out value="${animal.sexoDescripcion}" default="—"/></dd></div>
                            <div><dt>Tag asociado</dt><dd><c:out value="${requestScope.tagsPorAnimal[animal.id]}" default="—"/></dd></div>
                            <div><dt>ID de granja</dt><dd><c:out value="${animal.granjaId}" default="—"/></dd></div>
                            <div><dt>Nacimiento</dt><dd><c:if test="${empty animal.fechaNacimiento}">—</c:if><fmt:formatDate value="${animal.fechaNacimiento}" pattern="dd/MM/yyyy"/></dd></div>
                            <div><dt>Alta</dt><dd><c:if test="${empty animal.fechaAlta}">—</c:if><fmt:formatDate value="${animal.fechaAlta}" pattern="dd/MM/yyyy"/></dd></div>
                            <div><dt>Baja</dt><dd><c:if test="${empty animal.fechaBaja}">—</c:if><fmt:formatDate value="${animal.fechaBaja}" pattern="dd/MM/yyyy"/></dd></div>
                            <div><dt>Madre interna (crotal)</dt><dd><c:out value="${animal.crotalMadreInterna}" default="—"/></dd></div>
                            <div><dt>ID de madre externa</dt><dd><c:out value="${animal.madreExternaId}" default="—"/></dd></div>
                            <div><dt>ID de padre externo</dt><dd><c:out value="${animal.padreExternoId}" default="—"/></dd></div>
                        </dl>
                    </c:otherwise>
                </c:choose>
                <div class="evento-botones evento-detalle-botones">
                    <a class="btn secondary" href="<c:out value='${animalListadoUrl}'/>">Volver a Animales</a>
                    <c:if test="${not empty animal and puedeGestionarAnimales}">
                        <c:url var="editarAnimalUrl" value="/animal">
                            <c:param name="action" value="update"/>
                            <c:param name="id" value="${animal.id}"/>
                        </c:url>
                        <a class="btn primary" href="<c:out value='${editarAnimalUrl}'/>">Modificar</a>
                    </c:if>
                </div>
            </article>
        </main>
    </div>
</body>
</html>
