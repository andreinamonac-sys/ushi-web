<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="formularioIncluido" value="${requestScope.formularioUsuarioIncluido eq true}"/>
<c:set var="editarUsuario" value="${requestScope.editarUsuario eq true}"/>
<c:set var="usuarioFormulario" value="${editarUsuario ? requestScope.usuario : null}"/>
<c:set var="reenviadoUsuario" value="${pageContext.request.method eq 'POST' and (param.action eq 'create' or param.action eq 'update')}"/>
<c:if test="${not formularioIncluido}">
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - ${editarUsuario ? 'Editar usuario' : 'Nuevo usuario'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="usuarios"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>
    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Usuarios"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main><article class="panel padded">
            <h1>${editarUsuario ? 'Editar usuario' : 'Nuevo usuario'}</h1>
</c:if>
<c:choose>
    <c:when test="${(editarUsuario and usuarioFormulario.id eq sessionScope.usuario.id) or (not editarUsuario and sessionScope.usuario.rolId eq 1)}">
        <c:if test="${not empty requestScope.usuarioError}">
            <p class="form-message form-message-error" role="alert"><c:out value="${requestScope.usuarioError}"/></p>
        </c:if>
        <fmt:formatDate var="fechaNacimientoFormulario" value="${usuarioFormulario.fechaNacimiento}" pattern="yyyy-MM-dd"/>
        <form action="${pageContext.request.contextPath}/private/usuario" method="post" class="registration-form">
            <input type="hidden" name="action" value="${editarUsuario ? 'update' : 'create'}">
            <c:if test="${editarUsuario}"><input type="hidden" name="id" value="${usuarioFormulario.id}"></c:if>
            <fieldset class="registration-grid">
                <legend>Datos del usuario</legend>
                <label for="form-usuario-dni">DNI / NIE
                    <input id="form-usuario-dni" name="dni-nie" required maxlength="45" value="<c:out value="${reenviadoUsuario ? param['dni-nie'] : usuarioFormulario.dniNie}"/>">
                </label>
                <label for="form-usuario-nombre">Nombre
                    <input id="form-usuario-nombre" name="nombre" required maxlength="100" value="<c:out value='${reenviadoUsuario ? param.nombre : usuarioFormulario.nombre}'/>">
                </label>
                <label for="form-usuario-apellido1">Primer apellido
                    <input id="form-usuario-apellido1" name="apellido1" required maxlength="100" value="<c:out value='${reenviadoUsuario ? param.apellido1 : usuarioFormulario.apellido1}'/>">
                </label>
                <label for="form-usuario-apellido2">Segundo apellido <span class="optional">(opcional)</span>
                    <input id="form-usuario-apellido2" name="apellido2" maxlength="100" value="<c:out value='${reenviadoUsuario ? param.apellido2 : usuarioFormulario.apellido2}'/>">
                </label>
                <label for="form-usuario-nacimiento">Fecha de nacimiento
                    <input type="date" id="form-usuario-nacimiento" name="fecha-nacimiento" required value="<c:out value="${reenviadoUsuario ? param['fecha-nacimiento'] : fechaNacimientoFormulario}"/>">
                </label>
                <label for="form-usuario-telefono">Teléfono <span class="optional">(opcional)</span>
                    <input type="tel" id="form-usuario-telefono" name="telefono" maxlength="20" value="<c:out value='${reenviadoUsuario ? param.telefono : usuarioFormulario.telefono}'/>">
                </label>
                <label for="form-usuario-email">Email
                    <input type="email" id="form-usuario-email" name="email" required maxlength="255" value="<c:out value='${reenviadoUsuario ? param.email : usuarioFormulario.email}'/>">
                </label>
                <c:if test="${not editarUsuario}">
                    <label for="form-usuario-password">Contraseña
                        <input type="password" id="form-usuario-password" name="password" required autocomplete="new-password">
                    </label>
                    <label for="form-usuario-rol">Rol
                        <select id="form-usuario-rol" name="rol-id" required>
                            <option value="">Selecciona el rol</option>
                            <option value="1" ${param['rol-id'] eq '1' ? 'selected' : ''}>Administrador</option>
                            <option value="2" ${param['rol-id'] eq '2' ? 'selected' : ''}>Veterinario</option>
                            <option value="3" ${param['rol-id'] eq '3' ? 'selected' : ''}>Encargado</option>
                            <option value="4" ${param['rol-id'] eq '4' ? 'selected' : ''}>Operario</option>
                        </select>
                    </label>
                </c:if>
            </fieldset>
            <div class="actions filter-actions">
                <c:if test="${not formularioIncluido}">
                    <c:url var="cancelarUsuarioUrl" value="/html/private/usuario/usuario-search-view.jsp"/>
                    <a class="btn secondary" href="<c:out value='${cancelarUsuarioUrl}'/>">Cancelar</a>
                </c:if>
                <button class="btn primary" type="submit">${editarUsuario ? 'Guardar cambios' : 'Crear usuario'}</button>
            </div>
        </form>
    </c:when>
    <c:otherwise><p role="alert">No tienes permiso para gestionar este usuario.</p></c:otherwise>
</c:choose>
<c:if test="${not formularioIncluido}">
        </article></main>
        <footer>Ushi © 2026 - Monitorización ganadera en tiempo real</footer>
    </div>
</body>
</html>
</c:if>
