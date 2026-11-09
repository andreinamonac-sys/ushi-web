<form action="${pageContext.request.contextPath}/animal" method="post">
	<input type="hidden" name="action" value="search" /> <label>Animal</label>
	
	
	<label>Animal</label> 
	<input type="text" name="Animal" placeholder="45669" /> 
	<label>Tag asociado</label> 
	<input type="text" name="Tag asociado" placeholder="TAG-001 " />

	<div>
		<label for="fecha_desde">Fecha nacimiento</label> 
		<input type="text" id="fecha_desde" name="fecha desde" placeholder="Desde" /> 
			<span>/</span>
		<input type="text" id="fecha_hasta" name="fecha hasta" placeholder="Hasta" />
	</div>
	
	<div>
		<label for="fecha_desde">Fecha de alta</label> 
		<input type="text" id="fecha_desde" name="fecha desde" placeholder="Desde" /> 
			<span>/</span>
		<input type="text" id="fecha_hasta" name="fecha hasta" placeholder="Hasta" />
	</div>
	
	<div>
		<label for="fecha_desde">Fecha de baja</label> 
		<input type="text" id="fecha_desde" name="fecha desde" placeholder="Desde" /> 
			<span>/</span>
		<input type="text" id="fecha_hasta" name="fecha hasta" placeholder="Hasta" />
	</div>


	<select id="Tipo" name="Tipo">
		<option value="tipo"></option>
	</select> <input type="submit" value="Buscar">
</form>