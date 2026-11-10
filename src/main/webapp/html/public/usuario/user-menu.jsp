<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:choose>
	<c:when test="${empty sessionScope.usuario}">
		<c:choose>
			<c:when test="${requestScope.registrationPage}">
				<a class="access"
					href="${pageContext.request.contextPath}/html/public/usuario/login.jsp">Iniciar
					sesión</a>
			</c:when>
			<c:otherwise>
				<a class="access"
					href="${pageContext.request.contextPath}/html/public/usuario/register.jsp">Registrarse</a>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<a href="${pageContext.request.contextPath}/private/usuario?action=get-profile">Mi perfil</a>
		<a class="access"
			href="${pageContext.request.contextPath}/html/private/panelControl/panel-detail-view.jsp">Mi
			panel</a>
		<form class="session-logout"
			action="${pageContext.request.contextPath}/public/usuario"
			method="post">
			<input type="hidden" name="action" value="logout">
			<button type="submit">Cerrar sesión</button>
		</form>
	</c:otherwise>
</c:choose>
