<aside class="sidebar" id="sidebar">
	<div class="sidebar-brand">
		<a
			href="${pageContext.request.contextPath}/html/private/panelControl/panel-detail-view.jsp"><span><img
				src="${pageContext.request.contextPath}/img/ushi-logo.png" alt=""></span><strong>Ushi</strong><small>GanaderÃ­a
				inteligente</small></a>
	</div>
	<nav>
		<a class="active"
			href="${pageContext.request.contextPath}/html/private/panelControl/panel-detail-view.jsp"><svg
				viewBox="0 0 24 24">
				<rect x="3" y="3" width="7" height="7" rx="2"></rect>
				<rect x="14" y="3" width="7" height="7" rx="2"></rect>
				<rect x="3" y="14" width="7" height="7" rx="2"></rect>
				<rect x="14" y="14" width="7" height="7" rx="2"></rect></svg><span>Panel
				de control</span></a><a class=""
			href="${pageContext.request.contextPath}/animal?action=search"><svg
				viewBox="0 0 24 24">
				<path d="M7 8 4 5v5c0 1.1.9 2 2 2h1M17 8l3-3v5c0 1.1-.9 2-2 2h-1"></path>
				<path d="M7 7c1.7-1.3 8.3-1.3 10 0v8c0 3-2.2 5-5 5s-5-2-5-5V7Z"></path>
				<circle cx="9.5" cy="12" r=".7"></circle>
				<circle cx="14.5" cy="12" r=".7"></circle>
				<path d="M9 16c1.8-1 4.2-1 6 0"></path></svg><span>Animales</span></a><a
			class=""
			href="${pageContext.request.contextPath}/evento?action=search"><svg
				viewBox="0 0 24 24">
				<rect x="3" y="5" width="18" height="16" rx="2"></rect>
				<path d="M8 3v4M16 3v4M3 10h18M8 14h2M14 14h2M8 17h2"></path></svg><span>Eventos</span></a><span
			class="menu-item unavailable"
			title="SecciÃ³n pendiente de implementar" aria-disabled="true"><svg
				viewBox="0 0 24 24">
				<path d="m3 11 9-7 9 7v10H3V11Z"></path>
				<path d="M8 21v-7h8v7M7 9h.01M17 9h.01"></path></svg><span>Granjas</span></span><span
			class="menu-item unavailable"
			title="SecciÃ³n pendiente de implementar" aria-disabled="true"><svg
				viewBox="0 0 24 24">
				<rect x="4" y="3" width="12" height="18" rx="2"></rect>
				<path
					d="M8 17h4M18 7c1.3 1.3 1.3 3.7 0 5M20.5 4.5c2.7 2.7 2.7 7.3 0 10"></path></svg><span>Monitorización</span></span><span
			class="menu-item unavailable"
			title="SecciÃ³n pendiente de implementar" aria-disabled="true"><svg
				viewBox="0 0 24 24">
				<path d="M4 20V10M10 20V4M16 20v-7M22 20H2"></path>
				<path d="m3 8 6-5 6 7 7-6"></path></svg><span>Estadísticas</span></span><a
			class=""
			href="${pageContext.request.contextPath}/html/private/usuario/usuario-searchh-view.jsp"><svg
				viewBox="0 0 24 24">
				<circle cx="9" cy="8" r="4"></circle>
				<path
					d="M2 21c0-4 3-7 7-7s7 3 7 7M16 4.5a4 4 0 0 1 0 7.5M17 15c3 .5 5 2.8 5 6"></path></svg><span>Usuarios</span></a>
	</nav>
	<div class="sidebar-user">
		<div class="user-mini">
			<span>U</span>
			<div>
				<strong><a href="${pageContext.request.contextPath}/private/usuario?action=get-profile" title="Ver mi perfil"><c:out value="${sessionScope.usuario.nombre}" /> <c:out
						value="${sessionScope.usuario.apellido1}" /></a></strong><small>Sesión
					iniciada</small>
			</div>
		</div>
		<form class="sidebar-logout"
			action="${pageContext.request.contextPath}/private/usuario"
			method="post">
			<input type="hidden" name="action" value="logout">
			<button class="logout" type="submit">
				<svg viewBox="0 0 24 24">
					<path d="M10 5H5v14h5M14 8l4 4-4 4M8 12h10"></path></svg>
				<span>Cerrar sesión</span>
			</button>
		</form>
	</div>
</aside>
