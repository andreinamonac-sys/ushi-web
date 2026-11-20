<c:url var="animalBuscarUrl" value="/animal"/>
<c:url var="animalListadoUrl" value="/html/private/animal/animal-search-view.jsp"/>
<form id="animal-buscador" class="filter-card" action="<c:out value='${animalBuscarUrl}'/>" method="get">
    <input type="hidden" name="action" value="search">
    <div class="filter-grid" style="grid-template-columns: repeat(auto-fit, minmax(min(100%, 14rem), 1fr));">
        <label class="field">
            <span>Crotal</span>
            <input type="text" name="crotal" placeholder="ES001100000040" value="<c:out value="${param['crotal']}"/>">
        </label>
        <label class="field">
            <span>Tag asociado</span>
            <input type="text" name="tag-asociado" placeholder="TAG-001" value="<c:out value="${param['tag-asociado']}"/>">
        </label>
        <label class="field">
            <span>Sexo</span>
            <select name="sexo-id">
                <option value="">Todos</option>
                <option value="2" ${param['sexo-id'] eq '2' ? 'selected' : ''}>Hembra</option>
                <option value="1" ${param['sexo-id'] eq '1' ? 'selected' : ''}>Macho</option>
            </select>
        </label>
    </div>

    <div class="filter-grid" style="margin-top: 1rem; grid-template-columns: repeat(auto-fit, minmax(min(100%, 17rem), 1fr));">
        <fieldset style="min-width: 0; margin: 0; border: 1px solid var(--line); border-radius: 8px;">
            <legend>Fecha de nacimiento</legend>
            <div class="filter-grid" style="grid-template-columns: repeat(auto-fit, minmax(min(100%, 8rem), 1fr));">
                <label class="field">
                    <span>Desde</span>
                    <input type="date" name="fecha-nacimiento-desde" value="<c:out value="${param['fecha-nacimiento-desde']}"/>">
                </label>
                <label class="field">
                    <span>Hasta</span>
                    <input type="date" name="fecha-nacimiento-hasta" value="<c:out value="${param['fecha-nacimiento-hasta']}"/>">
                </label>
            </div>
        </fieldset>
        <fieldset style="min-width: 0; margin: 0; border: 1px solid var(--line); border-radius: 8px;">
            <legend>Fecha de alta</legend>
            <div class="filter-grid" style="grid-template-columns: repeat(auto-fit, minmax(min(100%, 8rem), 1fr));">
                <label class="field">
                    <span>Desde</span>
                    <input type="date" name="fecha-alta-desde" value="<c:out value="${param['fecha-alta-desde']}"/>">
                </label>
                <label class="field">
                    <span>Hasta</span>
                    <input type="date" name="fecha-alta-hasta" value="<c:out value="${param['fecha-alta-hasta']}"/>">
                </label>
            </div>
        </fieldset>
        <fieldset style="min-width: 0; margin: 0; border: 1px solid var(--line); border-radius: 8px;">
            <legend>Fecha de baja</legend>
            <div class="filter-grid" style="grid-template-columns: repeat(auto-fit, minmax(min(100%, 8rem), 1fr));">
                <label class="field">
                    <span>Desde</span>
                    <input type="date" name="fecha-baja-desde" value="<c:out value="${param['fecha-baja-desde']}"/>">
                </label>
                <label class="field">
                    <span>Hasta</span>
                    <input type="date" name="fecha-baja-hasta" value="<c:out value="${param['fecha-baja-hasta']}"/>">
                </label>
            </div>
        </fieldset>
    </div>

    <details style="margin-top: 1rem;" ${not empty param['crotal-madre-interna'] or not empty param['madre-externa-id']
             or not empty param['padre-externo-id'] or not empty param.id ? 'open' : ''}>
        <summary>Filtros avanzados</summary>
        <div class="filter-grid" style="margin-top: 0.75rem;">
            <label class="field">
                <span>Madre interna (crotal)</span>
                <input type="text" name="crotal-madre-interna" value="<c:out value="${param['crotal-madre-interna']}"/>">
            </label>
            <label class="field">
                <span>ID madre externa</span>
                <input type="number" name="madre-externa-id" min="1" value="<c:out value="${param['madre-externa-id']}"/>">
            </label>
            <label class="field">
                <span>ID padre externo</span>
                <input type="number" name="padre-externo-id" min="1" value="<c:out value="${param['padre-externo-id']}"/>">
            </label>
            <label class="field">
                <span>ID interno</span>
                <input type="number" name="id" min="1" value="<c:out value="${param['id']}"/>">
            </label>
        </div>
    </details>
    <div class="filter-actions actions">
        <a class="btn secondary" href="<c:out value='${animalListadoUrl}'/>">Limpiar filtros</a>
        <button class="btn primary" type="submit">Buscar animal</button>
    </div>
</form>
