<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="registrationPage" value="true" scope="request" />
<%@ include file="/html/public/common/header.jsp"%>

<div class="registration-page">
	<main>
		<section class="registration-hero"
			aria-labelledby="registration-title">
			<article class="login-card registration-card">
				<div class="login-brand registration-brand">
					<img src="${pageContext.request.contextPath}/img/ushi-logo.png"
						alt="">
					<h2>Ushi</h2>
					<p>Tu explotación, siempre conectada.</p>
					<span>Da el primer paso para gestionar tu ganadería desde un
						solo lugar.</span>
				</div>
				<div class="login-form registration-form">
					<header>
						<p class="eyebrow">Bienvenido a Ushi</p>
						<h1 id="registration-title">Crea tu cuenta</h1>
						<p>Crea tu cuenta como propietario de la explotación.</p>
					</header>
					<form action="${pageContext.request.contextPath}/public/usuario"
						method="post" enctype="multipart/form-data">
						<input type="hidden" name="action" value="register">
						<c:if test="${empty initParam['ushi.registration.roleId']}">
							<p class="form-message" role="status">El registro de nuevas
								cuentas todavía no está disponible.</p>
						</c:if>
						<c:if test="${not empty requestScope.registerError}">
							<p class="form-message form-message-error" role="alert">
								<c:out value="${requestScope.registerError}" />
							</p>
						</c:if>
						<fieldset class="registration-grid">
							<legend>Datos de acceso</legend>
							<label for="email">Email <input id="email" name="email"
								type="email" autocomplete="email" placeholder="usuario@ushi.com"
								required=""
								value="<c:out value='${requestScope.registerValues["email"]}' />"
								maxlength="255">
							</label> <label for="password">Contraseña <input id="password"
								name="password" type="password" autocomplete="new-password"
								minlength="8" aria-describedby="password-help"
								placeholder="Crea tu contraseña" required=""> <span
								class="field-help" id="password-help">Mínimo 8
									caracteres.</span>
							</label>
						</fieldset>
						<fieldset class="registration-grid">
							<legend>Datos personales</legend>
							<label for="dni-nie">DNI / NIE <input id="dni-nie"
								name="dni-nie" type="text" maxlength="9"
								autocapitalize="characters" spellcheck="false"
								placeholder="12345678A o X1234567A" required=""
								value="<c:out value='${requestScope.registerValues["dni-nie"]}' />">
							</label> <label for="nombre">Nombre <input id="nombre"
								name="nombre" type="text" autocomplete="given-name"
								placeholder="Tu nombre" required=""
								value="<c:out value='${requestScope.registerValues["nombre"]}' />"
								maxlength="100">
							</label> <label for="apellido1">Primer apellido <input
								id="apellido1" name="apellido1" type="text"
								autocomplete="family-name" placeholder="Tu primer apellido"
								required=""
								value="<c:out value='${requestScope.registerValues["apellido1"]}' />"
								maxlength="100">
							</label> <label for="apellido2">Segundo apellido <span
								class="optional">(opcional)</span> <input id="apellido2"
								name="apellido2" type="text" placeholder="Tu segundo apellido"
								value="<c:out value='${requestScope.registerValues["apellido2"]}' />"
								maxlength="100">
							</label> <label for="fecha-nacimiento">Fecha de nacimiento <input
								id="fecha-nacimiento" name="fecha-nacimiento" type="date"
								autocomplete="bday" required=""
								value="<c:out value='${requestScope.registerValues["fecha-nacimiento"]}' />">
							</label> <label for="telefono">Teléfono <input id="telefono"
								name="telefono" type="tel" autocomplete="tel"
								placeholder="+34 600 000 000" required=""
								value="<c:out value='${requestScope.registerValues["telefono"]}' />"
								maxlength="24">
							</label>
						</fieldset>
						<fieldset class="registration-photo">
							<legend>
								Foto de perfil <span class="optional">(opcional)</span>
							</legend>
							<div class="profile-upload">
								<div class="profile-file">
									<label for="foto-perfil">Selecciona una imagen</label> <input
										id="foto-perfil" name="foto-perfil" type="file"
										accept="image/jpeg,image/png" aria-describedby="photo-help">
									<span id="photo-help" class="field-help">JPG o PNG.
										Máximo 5 MB.</span>
								</div>
							</div>
						</fieldset>
						<button type="submit">Registrarse</button>

					</form>
					<p class="registration-signin">
						¿Ya tienes una cuenta? <a
							href="${pageContext.request.contextPath}/html/public/usuario/login.jsp">Inicia
							sesión</a>
					</p>
					<small>Ushi © 2026</small>
				</div>
			</article>
		</section>
	</main>
</div>
<%@ include file="/html/public/common/footer.jsp"%>
