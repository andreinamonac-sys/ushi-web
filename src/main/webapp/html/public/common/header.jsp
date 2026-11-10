<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ushi · Monitorización ganadera</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css">
  
</head>
<body class="landing-page">
  <nav class="landing-nav" aria-label="Navegación principal">
    <%@ include file="/html/public/common/logo.jsp" %>
    <div>
      <a href="${pageContext.request.contextPath}/html/public/index.jsp#servicios">Servicios</a>
      <a href="${pageContext.request.contextPath}/html/public/index.jsp#contacto">Contacto</a>
      <%@ include file="/html/public/usuario/user-menu.jsp" %>
    </div>
  </nav>
  <div class="content">
