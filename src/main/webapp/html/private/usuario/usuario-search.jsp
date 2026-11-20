<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url var="usuarioBuscarUrl" value="/private/usuario"/>
<c:url var="usuarioLimpiarUrl" value="/html/private/usuario/usuario-search-view.jsp"/>
<form action="<c:out value='${usuarioBuscarUrl}'/>" method="get" class="filter-card">
    <input type="hidden" name="action" value="search">
    <div class="filter-grid">
        <label class="field" for="usuario-dni">
            <span>DNI / NIE</span>
            <input id="usuario-dni" name="dni-nie" maxlength="45" value="<c:out value="${param['dni-nie']}"/>">
        </label>
        <label class="field" for="usuario-nombre">
            <span>Nombre</span>
            <input id="usuario-nombre" name="nombre" maxlength="100" value="<c:out value='${param.nombre}'/>">
        </label>
        <label class="field" for="usuario-email">
            <span>Email</span>
            <input id="usuario-email" name="email" maxlength="255" value="<c:out value='${param.email}'/>">
        </label>
        <label class="field" for="usuario-rol">
            <span>Rol</span>
            <select id="usuario-rol" name="rol-nombre">
                <option value="">Todos los roles</option>
                <option value="Administrador" ${param['rol-nombre'] eq 'Administrador' ? 'selected' : ''}>Administrador</option>
                <option value="Veterinario" ${param['rol-nombre'] eq 'Veterinario' ? 'selected' : ''}>Veterinario</option>
                <option value="Encargado" ${param['rol-nombre'] eq 'Encargado' ? 'selected' : ''}>Encargado</option>
                <option value="Operario" ${param['rol-nombre'] eq 'Operario' ? 'selected' : ''}>Operario</option>
            </select>
        </label>
    </div>
    <div class="filter-actions actions">
        <a class="btn secondary" href="<c:out value='${usuarioLimpiarUrl}'/>">Limpiar filtros</a>
        <button class="btn primary" type="submit">Buscar usuarios</button>
    </div>
</form>
