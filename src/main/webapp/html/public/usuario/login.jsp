<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/html/public/common/header.jsp" %>
<main><section class="login-hero" id="acceso">
        <article class="login-card">
          <div class="login-brand">
            <img src="${pageContext.request.contextPath}/img/ushi-logo.png" alt="">
            <h1>Ushi</h1>
            <p>Monitorización en tiempo real</p>
          </div>
          <div class="login-form">
            <h2>Iniciar sesión</h2>
            <p>Accede con tus credenciales</p>
            <%@ include file="/html/public/usuario/login-form.jsp" %>
            <small>Ushi © 2026</small>
          </div>
        </article>
      </section></main>
<%@ include file="/html/public/common/footer.jsp" %>
