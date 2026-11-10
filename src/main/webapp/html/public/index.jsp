<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/html/public/common/header.jsp" %>
<main>
      <section class="login-hero" id="acceso">
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
      </section>
      <section class="services" id="servicios">
        <div class="section-head">
          <p>Lo que ofrecemos</p>
          <h2>Tecnología al servicio del ganadero moderno</h2>
          <span>Ushi integra sensores IoT, inteligencia artificial y una interfaz
            simple para gestionar tu explotación desde cualquier lugar.</span>
        </div>
        <div class="service-grid">
          <article>
            <span>📡</span>
            <h3>Monitorización GPS</h3>
            <p>Localización en tiempo real de cada animal del rebaño.</p>
          </article>
          <article>
            <span>🔔</span>
            <h3>Alertas inteligentes</h3>
            <p>Detección automática de anomalías de salud y comportamiento.</p>
          </article>
          <article>
            <span>📊</span>
            <h3>Análisis de datos</h3>
            <p>Informes de producción, crecimiento y estado sanitario.</p>
          </article>
          <article>
            <span>🐄</span>
            <h3>Gestión del rebaño</h3>
            <p>Fichas individuales, lotes e historial médico.</p>
          </article>
          <article>
            <span>🌿</span>
            <h3>Control de alimentación</h3>
            <p>Seguimiento de consumo de pienso, agua y dietas.</p>
          </article>
          <article>
            <span>☁️</span>
            <h3>Sincronización en la nube</h3>
            <p>Datos seguros y disponibles desde cualquier dispositivo.</p>
          </article>
        </div>
      </section>
      <section class="contact" id="contacto">
        <div>
          <p class="eyebrow">Contacto</p>
          <h2>¿Tienes alguna pregunta?</h2>
          <p>
            Nuestro equipo esta disponible de lunes a viernes de 8:00 a 18:00.
            También ofrecemos demostraciones gratuitas.
          </p>
          <ul>
            <li><strong>Dirección</strong>Calle del Prado 14, 28014 Madrid</li>
            <li><strong>Email</strong>hola@ushi.com</li>
            <li><strong>Teléfono</strong>+34 91 234 56 78</li>
          </ul>
        </div>
        <div class="contact-form">
          <h3>Escríbenos</h3>
          <label>Nombre<input placeholder="Tu nombre"></label><label>Correo electrónico<input type="email" placeholder="tu@email.com"></label><label>Mensaje<textarea rows="4" placeholder="¿En que podemos ayudarte?"></textarea></label><button type="button" disabled>Enviar mensaje</button>
        <p class="form-message" role="status">El envío de mensajes estará disponible próximamente.</p></div>
      </section>
    </main>
<%@ include file="/html/public/common/footer.jsp" %>
