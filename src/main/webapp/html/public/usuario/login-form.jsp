<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form class="access-form" action="${pageContext.request.contextPath}/public/usuario" method="post">
  <input type="hidden" name="action" value="login">
  <c:if test="${not empty sessionScope.registrationMessage}">
    <p class="form-message" role="status"><c:out value="${sessionScope.registrationMessage}" /></p>
    <c:remove var="registrationMessage" scope="session" />
  </c:if>
  <c:if test="${not empty requestScope.loginError}">
    <p class="form-message form-message-error" role="alert"><c:out value="${requestScope.loginError}" /></p>
  </c:if>
  <label for="email">Correo electrónico
    <input type="email" id="email" name="email" autocomplete="username" placeholder="usuario@ushi.com"
      value="<c:out value='${requestScope.loginEmail}' />" required>
  </label>
  <label for="password">Contraseña
    <input type="password" id="password" name="password" autocomplete="current-password" placeholder="••••••••" required>
  </label>
  <button type="submit">Entrar</button>
</form>
