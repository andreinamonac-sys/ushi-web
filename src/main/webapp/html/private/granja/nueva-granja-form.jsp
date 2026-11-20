<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Nueva granja</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="granjas"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>
    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Granjas"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main class="registration-hero">
            <article class="login-card registration-card formulario-privado granja-formulario">
                <div class="login-form registration-form">
                    <h1>Nueva granja</h1>
                    <c:if test="${not empty requestScope.granjaError}">
                        <p class="form-message form-message-error" role="alert"><c:out value="${requestScope.granjaError}"/></p>
                    </c:if>

                    <c:url var="guardarGranjaUrl" value="/private/granja"/>
                    <c:url var="cancelarGranjaUrl" value="/private/granja">
                        <c:param name="action" value="search"/>
                    </c:url>

                    <form action="<c:out value='${guardarGranjaUrl}'/>" method="post">
                        <input type="hidden" name="action" value="create">
                        <fieldset class="registration-grid">
                            <legend>Identificación</legend>
                            <label for="codigo-rega">Código REGA
                                <input type="text" id="codigo-rega" name="codigo-rega" maxlength="50" required
                                       value="<c:out value="${param['codigo-rega']}"/>">
                            </label>
                            <label for="nif">NIF
                                <input type="text" id="nif" name="nif" maxlength="45" required
                                       value="<c:out value='${param.nif}'/>">
                            </label>
                            <label for="encargado-id">Encargado
                                <select id="encargado-id" name="encargado-id" required>
                                    <option value="">Selecciona un encargado</option>
                                    <c:forEach var="encargado" items="${requestScope.encargados}">
                                        <option value="${encargado.id}" ${param['encargado-id'] eq encargado.id.toString() ? 'selected' : ''}>
                                            <c:out value="${encargado.nombre}"/> <c:out value="${encargado.apellido1}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </label>
                        </fieldset>

                        <fieldset class="registration-grid">
                            <legend>Ubicación</legend>
                            <label class="granja-calle" for="calle">Calle
                                <input type="text" id="calle" name="calle" maxlength="150" required
                                       value="<c:out value='${param.calle}'/>">
                            </label>
                            <label for="numero">Número
                                <input type="number" id="numero" name="numero" min="0" required
                                       value="<c:out value='${param.numero}'/>">
                            </label>
                            <label for="cp">Código postal
                                <input type="text" id="cp" name="cp" inputmode="numeric" pattern="[0-9]{5}" maxlength="5" required
                                       value="<c:out value='${param.cp}'/>">
                            </label>
                            <label for="provincia-id">Provincia
                                <select id="provincia-id" name="provincia-id" required>
                                    <option value="">Selecciona una provincia</option>
                                    <c:forEach var="provincia" items="${requestScope.provincias}">
                                        <option value="${provincia.id}" ${param['provincia-id'] eq provincia.id.toString() ? 'selected' : ''}>
                                            <c:out value="${provincia.nombre}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </label>
                            <label for="localidad">Localidad
                                <input type="text" id="localidad" name="localidad" maxlength="45" required
                                       value="<c:out value='${param.localidad}'/>">
                            </label>
                        </fieldset>

                        <div class="granja-botones">
                            <a class="btn secondary" href="<c:out value='${cancelarGranjaUrl}'/>">Cancelar</a>
                            <button class="btn primary" type="submit">Guardar</button>
                        </div>
                    </form>
                </div>
            </article>
        </main>
    </div>
</body>
</html>
