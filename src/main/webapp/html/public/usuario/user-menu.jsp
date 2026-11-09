<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.andreina.ushi.model.*"%>
<%@page import="com.jal.ushi.util.*"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div id="user-menu">
	<c:choose>
		<c:when test="${empty sessionScope.user}">	 <!--  o equivalente: "${sessionScope[AttributeNames.USUARIO]}" !-->
			<a href="${pageContext.request.contextPath}/html/public/usuario/login.jsp">Autenticarse</a>
		</c:when>
		<c:otherwise>		
			<a href="${pageContext.request.contextPath}/usuario?action=logout">Salir</a>
			<a href="${pageContext.request.contextPath}/html/usuario/usuario-detail.jsp">${sessionScope.user.nombre}</a>		
		</c:otherwise>
	</c:choose>		
</div>
