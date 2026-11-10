<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ushi - Mi perfil</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/ushi.css">
</head>
<body class="dashboard-page">
	<%@ include file="/html/private/panelControl/menu.jsp"%>
	<div class="dashboard-wrap">
		<header class="topbar">
			<div class="topbar-left">
				<div>
					<small>Finca A Lagoa</small><strong>Mi perfil</strong>
				</div>
			</div>
			<div class="topbar-right">
				<label class="global-search"><svg viewBox="0 0 24 24">
						<circle cx="11" cy="11" r="7"></circle>
						<path d="m20 20-4-4"></path></svg><input placeholder="Buscar en Ushi..."
					aria-label="Buscar en Ushi" disabled
					title="Búsqueda pendiente de implementar"></label>
				<button class="bell" type="button" aria-label="Notificaciones"
					disabled title="Notificaciones pendientes de implementar">
					<svg viewBox="0 0 24 24">
						<path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 8h18c0-1-3-1-3-8M10 21h4"></path></svg>
					<span></span>
				</button>
				<div class="online">
					<span></span>78 tags online
				</div>
			</div>
		</header>
		<main>
    <div class="page-title">
        <div>
            <p class="eyebrow">Tu cuenta Ushi</p>
            <h1>Mi perfil</h1>
            <p>Consulta tus datos personales y tu información de contacto.</p>
        </div>
    </div>

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

                <section class="panel padded state-card" aria-labelledby="foto-perfil">
                    <h2 id="foto-perfil">Foto de perfil</h2>
                    <c:url var="fotoPerfilUrl" value="/private/usuario">
                        <c:param name="action" value="get-image" />
                        <c:param name="resource-type" value="perfil" />
                    </c:url>
                    <figure style="margin: 28px 0; text-align: center;">
                        <object data="<c:out value='${fotoPerfilUrl}' />" type="image/jpeg"
                                width="160" height="160" aria-label="Foto de perfil"
                                style="max-width: 100%; border-radius: 50%; background: white;">
                            <img src="${pageContext.request.contextPath}/img/ushi-logo.png"
                                 width="120" height="120" alt="Sin foto de perfil disponible"
                                 style="max-width: 100%; object-fit: contain;">
                        </object>
                        <figcaption style="margin-top: 16px; color: var(--ushi-muted); font-size: 14px;">
                            <c:out value="${requestScope.usuario.nombre}" />
                            <c:out value="${requestScope.usuario.apellido1}" />
                        </figcaption>
                    </figure>
                </section>
            </div>
        </c:otherwise>
    </c:choose>
</main>
		<footer>Ushi © 2026 - Monitorización ganadera en tiempo real</footer>
	</div>


</body>
</html>
