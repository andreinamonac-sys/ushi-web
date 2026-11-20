<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Granjas</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="granjas"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>

    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Granjas"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main>
            <c:set var="puedeGestionarGranjas"
                   value="${requestScope.puedeGestionarGranjas ne null
                            ? requestScope.puedeGestionarGranjas
                            : sessionScope.usuario.rolId eq 1}"/>
            <c:url var="nuevaGranjaUrl" value="/private/granja">
                <c:param name="action" value="create"/>
            </c:url>
            <div class="page-title">
                <h1>Granjas</h1>
                <c:if test="${puedeGestionarGranjas}">
                    <a class="btn primary evento-nuevo" href="<c:out value='${nuevaGranjaUrl}'/>">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>
                        Nueva granja
                    </a>
                </c:if>
            </div>

            <%@ include file="/html/private/granja/granja-search.jsp" %>

            <c:if test="${not empty requestScope.granjaError}">
                <p role="alert"><c:out value="${requestScope.granjaError}"/></p>
            </c:if>
            <c:if test="${requestScope.granjas ne null}">
                <c:choose>
                    <c:when test="${empty requestScope.granjas}">
                        <p>No hay granjas que coincidan con los filtros.</p>
                    </c:when>
                    <c:otherwise>
                        <section class="farm-grid" aria-label="Resultados de granjas">
                            <c:forEach var="granja" items="${requestScope.granjas}">
                                <article class="farm-card">
                                    <div>
                                        <span aria-hidden="true">
                                            <svg viewBox="0 0 24 24"><path d="m3 11 9-7 9 7v10H3V11Z"/><path d="M8 21v-7h8v7"/></svg>
                                        </span>
                                        <c:if test="${puedeGestionarGranjas}">
                                            <div class="actions granja-acciones">
                                                <c:url var="editarGranjaUrl" value="/private/granja">
                                                    <c:param name="action" value="update"/>
                                                    <c:param name="id" value="${granja.id}"/>
                                                </c:url>
                                                <a class="icon-btn" href="<c:out value='${editarGranjaUrl}'/>"
                                                   aria-label="Editar granja ${granja.id}" title="Editar">
                                                    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m4 20 4.5-1 10-10a2.1 2.1 0 0 0-3-3l-10 10L4 20Z"/><path d="m14 7 3 3"/></svg>
                                                </a>
                                                <form method="post" action="<c:out value='${granjaBuscarUrl}'/>"
                                                      onsubmit="return confirm('¿Eliminar esta granja?')">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${granja.id}">
                                                    <button class="icon-btn danger" type="submit"
                                                            aria-label="Eliminar granja ${granja.id}" title="Eliminar">
                                                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M9 7V4h6v3M7 7l1 14h8l1-14M10 11v6M14 11v6"/></svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                    <h2><c:out value="${granja.codigoRega}"/></h2>
                                    <small>NIF <c:out value="${granja.nif}"/> · ID <c:out value="${granja.id}"/></small>
                                    <p><span>Dirección</span><strong>
                                        <c:out value="${granja.calle}"/> <c:out value="${granja.numero}"/>,
                                        <c:out value="${granja.cp}"/>
                                    </strong></p>
                                    <p><span>Encargado</span><strong><c:out value="${granja.usuarioNombre}" default="—"/></strong></p>
                                    <c:if test="${requestScope.censoPorGranja[granja.id] ne null}">
                                        <p><span>Animales</span><b><c:out value="${requestScope.censoPorGranja[granja.id]}"/></b></p>
                                    </c:if>
                                </article>
                            </c:forEach>
                        </section>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </main>
    </div>
</body>
</html>
