<form action="${pageContext.request.contextPath}/evento" method="get" class="buscador-evento">
    <input type="hidden" name="action" value="search">
    <div class="campo">
        <label for="evento-id">ID</label>
        <input type="number" id="evento-id" name="id" min="1" step="1"
               value="<c:out value='${param.id}'/>">
    </div>
    <div class="campo">
        <label for="fecha-desde">Desde</label>
        <input type="date" id="fecha-desde" name="fechaDesde"
               value="<c:out value='${param.fechaDesde}'/>">
        <label for="fecha-hasta">Hasta</label>
        <input type="date" id="fecha-hasta" name="fechaHasta"
               value="<c:out value='${param.fechaHasta}'/>">
    </div>
    <div class="campo">
        <label for="tipo-evento">Tipo de evento</label>
        <input type="text" id="tipo-evento" name="tipoEventoNombre" placeholder="Nombre del tipo"
               value="<c:out value='${param.tipoEventoNombre}'/>">
    </div>
    <div class="campo">
        <label for="veterinario">Veterinario</label>
        <input type="text" id="veterinario" name="veterinarioNombre" placeholder="Nombre o primer apellido"
               value="<c:out value='${param.veterinarioNombre}'/>">
    </div>
    <div class="acciones">
        <button type="submit">Buscar eventos</button>
        <a href="${pageContext.request.contextPath}/evento?action=search">Limpiar filtros</a>
    </div>
</form>
