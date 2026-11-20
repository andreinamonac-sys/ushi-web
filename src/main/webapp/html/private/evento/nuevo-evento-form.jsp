<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ushi - ${requestScope.editar ? 'Modificar evento' : 'Nuevo evento'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ushi.css?v=23904b502e32">
</head>
<body class="dashboard-page">
    <c:set var="seccionPanel" value="eventos"/>
    <%@ include file="/html/private/panelControl/menu.jsp" %>
    <div class="dashboard-wrap">
        <c:set var="tituloCabecera" value="Eventos"/>
        <%@ include file="/html/private/panelControl/cabecera.jsp" %>
        <main class="registration-hero">
            <article class="login-card registration-card formulario-privado evento-formulario">
                <div class="login-form registration-form">
                    <h1>${requestScope.editar ? 'Modificar evento' : 'Nuevo evento'}</h1>
                    <c:if test="${not empty requestScope.eventoError}">
                        <p class="form-message form-message-error" role="alert"><c:out value="${requestScope.eventoError}"/></p>
                    </c:if>

                    <c:set var="evento" value="${requestScope.evento}"/>
                    <c:set var="reenviado" value="${pageContext.request.method eq 'POST'}"/>
                    <c:set var="tipoId" value="${reenviado ? param['tipo-evento-id'] : evento.tipoEventoId}"/>
                    <c:set var="tratamientoId" value="${reenviado ? param['tratamiento-id'] : requestScope.tratamientoActual}"/>
                    <c:set var="dosisId" value="${reenviado ? param['dosis-id'] : evento.dosisId}"/>
                    <c:set var="vetId" value="${reenviado ? param['veterinario-id'] : evento.veterinarioId}"/>
                    <c:set var="semillaId" value="${reenviado ? param['semilla-id'] : evento.semillaId}"/>
                    <c:set var="diagnostico" value="${reenviado ? param.diagnostico : evento.valorDiagnostico}"/>

                    <form action="${pageContext.request.contextPath}/evento" method="post" data-evento-formulario>
                        <input type="hidden" name="action" value="${requestScope.editar ? 'update' : 'create'}">
                        <input type="hidden" name="eventoCsrf" value="<c:out value='${sessionScope.eventoCsrf}'/>">
                        <c:if test="${requestScope.editar}">
                            <input type="hidden" name="id" value="${evento.id}">
                        </c:if>

                        <fieldset class="registration-grid">
                            <legend>Datos del procedimiento</legend>
                            <label for="crotal">Crotal del animal
                                <input type="text" id="crotal" name="crotal" maxlength="20" required
                                       value="<c:out value='${reenviado ? param.crotal : evento.crotal}'/>">
                            </label>
                            <label for="fecha-hora">Fecha y hora del procedimiento
                                <input type="datetime-local" id="fecha-hora" name="fecha-hora" step="1" required
                                       value="<c:out value="${reenviado ? param['fecha-hora'] : requestScope.fechaFormulario}"/>">
                            </label>
                            <label for="tipo-evento-id">Tipo de evento
                                <select id="tipo-evento-id" name="tipo-evento-id" required>
                                    <option value="">Selecciona el tipo</option>
                                    <c:forEach var="tipo" items="${requestScope['tipos-eventos']}">
                                        <option value="${tipo.id}" ${tipoId eq tipo.id ? 'selected' : ''}>
                                            <c:out value="${fn:toUpperCase(fn:substring(tipo.nombre, 0, 1))}${fn:substring(tipo.nombre, 1, fn:length(tipo.nombre))}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </label>
                            <label class="evento-ancho" for="descripcion">Descripción
                                <textarea id="descripcion" name="descripcion" rows="4" maxlength="255" required><c:out value="${reenviado ? param.descripcion : evento.descripcion}"/></textarea>
                            </label>
                            <label data-tipo-evento="1" for="diagnostico">Diagnóstico de gestación
                                <select id="diagnostico" name="diagnostico">
                                    <option value="">Selecciona el diagnóstico</option>
                                    <option value="P" ${diagnostico eq 'P' ? 'selected' : ''}>Positivo</option>
                                    <option value="N" ${diagnostico eq 'N' ? 'selected' : ''}>Negativo</option>
                                </select>
                            </label>
                            <label data-tipo-evento="2" for="semilla-id">Semilla
                                <input type="number" id="semilla-id" name="semilla-id" min="1" step="1"
                                       value="<c:out value='${semillaId}'/>">
                            </label>
                            <label data-tipo-evento="4" for="crotal-cria">Crotal de la cría
                                <input type="text" id="crotal-cria" name="crotal-cria" maxlength="20"
                                       value="<c:out value="${reenviado ? param['crotal-cria'] : requestScope.crotalCria}"/>">
                            </label>
                        </fieldset>

                        <fieldset class="registration-grid">
                            <legend>Tratamiento</legend>
                            <label for="tratamiento-id">Tratamiento <span class="optional">(opcional)</span>
                                <input type="number" id="tratamiento-id" name="tratamiento-id" min="1" step="1"
                                       value="<c:out value='${tratamientoId}'/>">
                            </label>
                            <label for="dosis-id">Dosis
                                <input type="number" id="dosis-id" name="dosis-id" min="1" step="1"
                                       value="<c:out value='${dosisId}'/>">
                            </label>
                        </fieldset>

                        <fieldset class="registration-grid">
                            <legend>Atención veterinaria</legend>
                            <label for="veterinario-id">Veterinario <span class="optional">(si intervino)</span>
                                <select id="veterinario-id" name="veterinario-id">
                                    <option value="">Sin veterinario</option>
                                    <c:forEach var="vet" items="${requestScope.veterinarios}">
                                        <option value="${vet.id}" ${vetId eq vet.id ? 'selected' : ''}>
                                            <c:out value="${vet.nombre}"/> <c:out value="${vet.apellido1}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </label>
                        </fieldset>

                        <div class="evento-botones">
                            <c:url var="cancelarUrl" value="/evento">
                                <c:choose>
                                    <c:when test="${requestScope.editar}">
                                        <c:param name="action" value="detail"/>
                                        <c:param name="id" value="${evento.id}"/>
                                    </c:when>
                                    <c:otherwise><c:param name="action" value="search"/></c:otherwise>
                                </c:choose>
                            </c:url>
                            <a class="btn secondary" href="<c:out value='${cancelarUrl}'/>">Cancelar</a>
                            <button class="btn primary" type="submit">Guardar</button>
                        </div>
                    </form>
                </div>
            </article>
        </main>
    </div>
    <script>
        const tipoEvento = document.getElementById("tipo-evento-id");

        const tratamiento = document.getElementById("tratamiento-id");
        const dosis = document.getElementById("dosis-id");
        const cria = document.getElementById("crotal-cria");
        const semilla = document.getElementById("semilla-id");
        const diagnostico = document.getElementById("diagnostico");
        const veterinario = document.getElementById("veterinario-id");

        function actualizarCampos() {
            const tipo = tipoEvento.value;

            tratamiento.disabled = tipo !== "3";

            dosis.disabled = tipo !== "3";
            dosis.required = tipo === "3";

            cria.disabled = tipo !== "4";
            cria.required = tipo === "4";

            semilla.disabled = tipo !== "2";
            semilla.required = tipo === "2";

            diagnostico.disabled = tipo !== "1";
            diagnostico.required = tipo === "1";

            veterinario.required = tipo === "5";
        }

        tipoEvento.addEventListener("change", actualizarCampos);

        // Aplicar también al abrir el formulario o volver tras un error.
        actualizarCampos();
    </script>
</body>
</html>
