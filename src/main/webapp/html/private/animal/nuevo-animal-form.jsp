<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - Nuevo animal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="animales"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>
    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Animales"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main class="registration-hero">
            <article class="login-card registration-card formulario-privado granja-formulario">
                <div class="login-form registration-form">
                    <h1>Nuevo animal</h1>
                    <c:if test="${not empty requestScope.animalError}">
                        <p class="form-message form-message-error" role="alert"><c:out value="${requestScope.animalError}"/></p>
                    </c:if>
                    <c:url var="animalGuardarUrl" value="/animal"/>
                    <c:url var="animalListadoUrl" value="/html/private/animal/animal-search-view.jsp"/>
                    <form method="post" action="<c:out value='${animalGuardarUrl}'/>">
                        <input type="hidden" name="action" value="create">
                        <fieldset class="registration-grid">
                            <legend>Identificación</legend>
                            <label>Crotal
                                <input type="text" name="crotal" required value="<c:out value="${param['crotal']}"/>">
                            </label>
                            <label>Sexo
                                <select name="sexo-id" required>
                                    <option value="">Selecciona el sexo</option>
                                    <option value="2" ${param['sexo-id'] eq '2' ? 'selected' : ''}>Hembra</option>
                                    <option value="1" ${param['sexo-id'] eq '1' ? 'selected' : ''}>Macho</option>
                                </select>
                            </label>
                            <label>Tag asociado
                                <input type="text" name="tag-asociado" value="<c:out value="${param['tag-asociado']}"/>">
                            </label>
                        </fieldset>

                        <fieldset class="registration-grid">
                            <legend>Fechas</legend>
                            <label>Nacimiento
                                <input type="date" name="fecha-nacimiento" required value="<c:out value="${param['fecha-nacimiento']}"/>">
                            </label>
                            <label>Alta
                                <input type="date" name="fecha-alta" required value="<c:out value="${param['fecha-alta']}"/>">
                            </label>
                        </fieldset>

                        <fieldset class="registration-grid">
                            <legend>Genealogía</legend>
                            <label>Madre interna (crotal)
                                <input type="text" name="crotal-madre-interna" value="<c:out value="${param['crotal-madre-interna']}"/>">
                            </label>
                            <label>ID madre externa
                                <input type="number" name="madre-externa-id" min="1" value="<c:out value="${param['madre-externa-id']}"/>">
                            </label>
                            <label>ID padre externo
                                <input type="number" name="padre-externo-id" min="1" value="<c:out value="${param['padre-externo-id']}"/>">
                            </label>
                        </fieldset>

                        <div class="granja-botones">
                            <a class="btn secondary" href="<c:out value='${animalListadoUrl}'/>">Cancelar</a>
                            <button class="btn primary" type="submit">Guardar</button>
                        </div>
                    </form>
                </div>
            </article>
        </main>
    </div>
</body>
</html>
