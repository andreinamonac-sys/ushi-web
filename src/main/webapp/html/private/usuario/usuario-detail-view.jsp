<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="perfilPropio" value="${requestScope.usuario.id eq sessionScope.usuario.id}"/>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ushi - ${perfilPropio ? 'Mi perfil' : 'Detalle de usuario'}</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
	<c:set var="seccionPanel" value="${perfilPropio ? 'perfil' : 'usuarios'}"/>
	<%@ include file="/html/private/panelControl/menu.jsp"%>
	<div class="dashboard-wrap">
		<c:set var="tituloCabecera" value="${perfilPropio ? 'Mi perfil' : 'Usuarios'}"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
		<main>
    <div class="page-title">
        <div>
            <p class="eyebrow">${perfilPropio ? 'Tu cuenta Ushi' : 'Administración'}</p>
            <h1>${perfilPropio ? 'Mi perfil' : 'Detalle de usuario'}</h1>
            <p>Datos personales e información de contacto.</p>
        </div>
    </div>
	<c:if test="${sessionScope.usuario.rolId eq 1}">
		<c:url var="volverUsuariosUrl" value="/html/private/usuario/usuario-search-view.jsp"/>
		<a class="btn secondary" href="<c:out value='${volverUsuariosUrl}'/>">Volver a usuarios</a>
	</c:if>
	<c:if test="${not empty requestScope.usuarioMensaje}">
		<p class="form-message" role="status"><c:out value="${requestScope.usuarioMensaje}"/></p>
	</c:if>
	<c:if test="${not empty requestScope.usuarioError}">
		<p class="form-message form-message-error" role="alert"><c:out value="${requestScope.usuarioError}"/></p>
	</c:if>

    <c:choose>
        <c:when test="${empty requestScope.usuario}">
            <section class="panel padded" aria-labelledby="perfil-vacio">
                <h2 id="perfil-vacio">No se han cargado los datos del perfil</h2>
                <p>Abre tu perfil desde el enlace «Mi perfil» del menú.</p>
            </section>
        </c:when>
        <c:otherwise>
            <div class="detail-grid">
                <section class="panel padded" aria-labelledby="datos-personales">
                    <h2 id="datos-personales">Datos personales</h2>
                    <div class="data-grid">
                        <div><span>Nombre</span>
                            <strong><c:out value="${requestScope.usuario.nombre}" default="No indicado" /></strong>
                        </div>
                        <div><span>Primer apellido</span>
                            <strong><c:out value="${requestScope.usuario.apellido1}" default="No indicado" /></strong>
                        </div>
                        <div><span>Segundo apellido</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${empty requestScope.usuario.apellido2}">No indicado</c:when>
                                    <c:otherwise><c:out value="${requestScope.usuario.apellido2}" /></c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div><span>DNI / NIE</span>
                            <strong><c:out value="${requestScope.usuario.dniNie}" default="No indicado" /></strong>
                        </div>
                        <div><span>Fecha de nacimiento</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${empty requestScope.usuario.fechaNacimiento}">No indicada</c:when>
                                    <c:otherwise><fmt:formatDate value="${requestScope.usuario.fechaNacimiento}" pattern="dd/MM/yyyy" /></c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div><span>Teléfono</span>
                            <strong><c:out value="${requestScope.usuario.telefono}" default="No indicado" /></strong>
                        </div>
                        <div><span>Correo electrónico</span>
                            <strong style="overflow-wrap: anywhere;"><c:out value="${requestScope.usuario.email}" default="No indicado" /></strong>
                        </div>
                        <div><span>Rol</span>
                            <strong><c:out value="${requestScope.usuario.nombreRol}" default="No indicado" /></strong>
                        </div>
                    </div>
                </section>

                <c:if test="${perfilPropio}">
                <section class="panel padded state-card" aria-labelledby="foto-perfil">
                    <h2 id="foto-perfil">Foto de perfil</h2>
                    <c:url var="fotoPerfilUrl" value="/private/usuario">
                        <c:param name="action" value="get-image" />
                    </c:url>
                    <figure style="margin: 28px 0; text-align: center;">
                        <%-- Muestra la foto; si no se puede cargar, utiliza el icono interior. --%>
                        <object data="<c:out value='${fotoPerfilUrl}' />" type="image/jpeg"
                                width="160" height="160" aria-label="Foto de perfil"
                                style="max-width: 100%; border-radius: 50%; background: white;">
                            <%-- Icono alternativo cuando no se puede cargar la foto. --%>
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 24 24" width="160" height="160"
                                 role="img" aria-label="Usuario sin foto de perfil"
                                 fill="none" stroke="currentColor" stroke-width="1.5"
                                 stroke-linecap="round" stroke-linejoin="round"
                                 style="max-width: 100%; color: var(--ushi-ink);">
                                <circle cx="12" cy="12" r="10"/>
                                <circle cx="12" cy="8.5" r="3"/>
                                <path d="M5.5 19a6.8 6.8 0 0 1 13 0"/>
                            </svg>
                        </object>
                        <figcaption style="margin-top: 16px; color: var(--ushi-muted); font-size: 14px;">
                            <c:out value="${requestScope.usuario.nombre}" />
                            <c:out value="${requestScope.usuario.apellido1}" />
                        </figcaption>
                    </figure>

                    <%-- Muestra el resultado de guardar la foto. --%>
                    <c:if test="${not empty requestScope.fotoMensaje}">
                        <p class="form-message" role="status">
                            <c:out value="${requestScope.fotoMensaje}"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty requestScope.fotoError}">
                        <p class="form-message form-message-error" role="alert">
                            <c:out value="${requestScope.fotoError}"/>
                        </p>
                    </c:if>

                    <%-- Envía la foto a la acción de actualizar la imagen. --%>
                    <form action="${pageContext.request.contextPath}/private/usuario"
                          method="post"
                          enctype="multipart/form-data">

                        <input type="hidden" name="action" value="update-image">

                        <label class="field" for="archivo-foto-perfil">
                            <span>Añadir o cambiar foto</span>
                            <input type="file"
                                   id="archivo-foto-perfil"
                                   name="foto-perfil"
                                   accept="image/jpeg"
                                   aria-describedby="foto-ayuda"
                                   required>
                        </label>

                        <p id="foto-ayuda">Formato JPG. Máximo 5 MB.</p>

                        <button class="btn primary" type="submit">Guardar foto</button>
                    </form>
                </section>
                </c:if>
            </div>
            <c:if test="${perfilPropio}">
                <section class="panel padded" aria-labelledby="editar-perfil">
                    <details>
                        <summary id="editar-perfil">Editar mis datos</summary>
                        <c:set var="formularioUsuarioIncluido" value="${true}" scope="request"/>
                        <c:set var="editarUsuario" value="${true}" scope="request"/>
                        <jsp:include page="/html/private/usuario/nuevo-usuario-form.jsp"/>
                        <c:remove var="formularioUsuarioIncluido" scope="request"/>
                        <c:remove var="editarUsuario" scope="request"/>
                    </details>
                </section>
            </c:if>
        </c:otherwise>
    </c:choose>
</main>
		<footer>Ushi © 2026 - Monitorización ganadera en tiempo real</footer>
	</div>


</body>
</html>
