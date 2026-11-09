<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    
<%@page import="com.andreina.ushi.model.*"%>
<%@page import="com.jal.ushi.util.*"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>Ushi</title>
</head>
<body>
<%@ include file="/html/public/common/logo.jsp" %>
<%@ include file="/html/public/usuario/user-menu.jsp" %>
<%@ include file="/html/private/panel/menu.jsp" %>

<!-- Area de contenido -->
<div class="content">