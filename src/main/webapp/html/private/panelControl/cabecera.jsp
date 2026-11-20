<%@ page pageEncoding="UTF-8" %>
<c:set var="codigoGranjaActiva" value="Sin explotación seleccionada"/>
	<c:forEach var="granjaPanel" items="${sessionScope['granjas-accesibles']}">
		<c:if test="${granjaPanel.id eq sessionScope['granja-activa-id']}">
			<c:set var="codigoGranjaActiva" value="${granjaPanel.codigoRega}"/>
		</c:if>
	</c:forEach>
<header class="topbar panel-topbar">
			<div class="topbar-left">
				<div>
					<small><c:out value="${codigoGranjaActiva}" default="Sin explotación seleccionada"/></small><strong><c:out value="${tituloCabecera}"/></strong>
				</div>
			</div>
			<div class="topbar-right">
				<c:choose>
				<c:when test="${empty sessionScope['granjas-accesibles']}">
					<p class="granja-selector-vacio">No tienes ninguna explotación asignada.</p>
				</c:when>
				<c:otherwise>
					<%-- Envía el ID de la granja seleccionada al servlet privado. --%>
					<form action="${pageContext.request.contextPath}/private/usuario"
						  method="post" class="granja-selector-cabecera">
						<input type="hidden" name="action" value="select-granja">

						<label class="granja-selector-campo" for="granja-activa">
							<span>Explotación activa</span>
							<select id="granja-activa" name="id" required>
								<c:forEach var="granja" items="${sessionScope['granjas-accesibles']}">
									<option value="${granja.id}"
											${sessionScope['granja-activa-id'] eq granja.id ? 'selected' : ''}>
										<c:out value="${granja.codigoRega}"/>
									</option>
								</c:forEach>
							</select>
						</label>

						<div class="granja-selector-accion">
							<button class="btn primary" type="submit" aria-label="Seleccionar explotación">Seleccionar</button>
						</div>
					</form>
				</c:otherwise>
			</c:choose>
				<button class="bell" type="button" aria-label="Notificaciones"
					disabled title="Notificaciones pendientes de implementar">
					<svg viewBox="0 0 24 24">
						<path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 8h18c0-1-3-1-3-8M10 21h4"></path></svg>
					<span></span>
				</button>
				<div class="online">
					<span></span>78 tags online
				</div>
							<%-- Acceso al perfil con la foto del usuario conectado. --%>
				<a class="usuario-cabecera"
				   href="${pageContext.request.contextPath}/private/usuario?action=get-profile"
				   title="Ver mi perfil">
					<object class="usuario-cabecera-foto"
							data="${pageContext.request.contextPath}/private/usuario?action=get-image"
							type="image/jpeg" width="44" height="44" aria-label="Foto de perfil">
						<svg viewBox="0 0 24 24" role="img" aria-label="Usuario sin foto">
							<circle cx="12" cy="12" r="10"/>
							<circle cx="12" cy="8.5" r="3"/>
							<path d="M5.5 19a6.8 6.8 0 0 1 13 0"/>
						</svg>
					</object>
					<span class="usuario-cabecera-datos">
						<strong><c:out value="${sessionScope.usuario.nombre}"/> <c:out value="${sessionScope.usuario.apellido1}"/></strong>
						<small>Sesión iniciada</small>
					</span>
				</a>
			</div>
		</header>
