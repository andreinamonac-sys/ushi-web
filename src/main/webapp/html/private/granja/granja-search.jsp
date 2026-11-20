<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url var="granjaBuscarUrl" value="/private/granja"/>
<c:url var="granjaLimpiarUrl" value="/private/granja">
    <c:param name="action" value="search"/>
</c:url>

<form id="granja-buscador" class="filter-card" action="<c:out value='${granjaBuscarUrl}'/>" method="get">
    <input type="hidden" name="action" value="search">

    <div class="filter-grid">
        <label class="field">
            <span>Código REGA</span>
            <input type="text" name="codigo-rega" value="<c:out value="${param['codigo-rega']}"/>">
        </label>
        <label class="field">
            <span>Provincia</span>
            <select id="granja-provincia" name="provincia-id">
                <option value="">Todas las provincias</option>
                <c:forEach var="provincia" items="${requestScope.provincias}">
                    <option value="${provincia.id}" ${param['provincia-id'] eq provincia.id.toString() ? 'selected' : ''}>
                        <c:out value="${provincia.nombre}"/>
                    </option>
                </c:forEach>
            </select>
        </label>
        <label class="field">
            <span>Localidad</span>
            <select id="granja-localidad" name="localidad" ${empty param['provincia-id'] ? 'disabled' : ''}>
                <option value="">${empty param['provincia-id'] ? 'Selecciona una provincia' : 'Todas las localidades'}</option>
                <c:forEach var="nombre" items="${requestScope.nombresLocalidades}">
                    <option value="<c:out value='${nombre}'/>" ${param.localidad eq nombre ? 'selected' : ''}>
                        <c:out value="${nombre}"/>
                    </option>
                </c:forEach>
            </select>
        </label>
        <label class="field">
            <span>Encargado</span>
            <select name="encargado-id">
                <option value="">Todos los encargados</option>
                <c:forEach var="encargado" items="${requestScope.encargados}">
                    <option value="${encargado.id}" ${param['encargado-id'] eq encargado.id.toString() ? 'selected' : ''}>
                        <c:out value="${encargado.nombre}"/> <c:out value="${encargado.apellido1}"/>
                    </option>
                </c:forEach>
            </select>
        </label>
        <label class="field">
            <span>ID interno</span>
            <input type="number" name="id" min="1" value="<c:out value='${param.id}'/>">
        </label>
        <label class="field">
            <span>Calle</span>
            <input type="text" name="calle" maxlength="150" value="<c:out value='${param.calle}'/>">
        </label>
        <label class="field">
            <span>N&uacute;mero</span>
            <input type="number" name="numero" min="0" value="<c:out value='${param.numero}'/>">
        </label>
        <label class="field">
            <span>CP</span>
            <input type="text" name="cp" inputmode="numeric" pattern="[0-9]{5}" maxlength="5" value="<c:out value='${param.cp}'/>">
        </label>
    </div>

    <div class="filter-actions actions">
        <a class="btn secondary" href="<c:out value='${granjaLimpiarUrl}'/>">Limpiar filtros</a>
        <button class="btn primary" type="submit">Buscar granjas</button>
    </div>
</form>

<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script>
$(document).ready(function () {

    $("#granja-provincia").on("change", function () {
        let idProvincia = $(this).val();

        // Limpiamos el select de localidades
        $("#granja-localidad")
            .empty()
            .append($("<option>", {
                value: "",
                text: idProvincia === ""
                    ? "Selecciona una provincia"
                    : "Todas las localidades"
            }))
            .prop("disabled", true);

        // Si no hay provincia seleccionada, no hacemos AJAX
        if (idProvincia === "") {
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/localidad?id-provincia="
                + encodeURIComponent(idProvincia),
            type: "GET",
            dataType: "json",
            success: function (localidades) {
                // Añadimos las localidades recibidas
                $.each(localidades, function (index, localidad) {
                    $("#granja-localidad").append(
                        $("<option>", {
                            value: localidad.id,
                            text: localidad.nombre
                        })
                    );
                });

                $("#granja-localidad").prop("disabled", false);
            },

            error: function (xhr, status, error) {
                console.error("Error AJAX:", status, error);
                alert("No se pudieron cargar las localidades");
            }
        });
    });
});
</script>