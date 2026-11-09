 <%@ include file="/html/public/common/header.jsp"%>


<img src="${pageContext.request.contextPath}/servlet/private/usuario?action=get-image&id=33&resource-type=perfil"/>
 
<form action="${pageContext.request.contextPath}/servlet/public/usuario" 
		method="post"
		enctype="multipart/form-data">
	<input type="hidden" name="action" value="register"/>
	
	<label for="email">E-mail:</label>
	<input type="email" name="login" placeholder="ex: andreina@gmail.com"/>
	
	
	<label for="password">Password:</label>
	<input type="password" name="password"/>
	
	<label for="dni_nie">DNI/NIE:</label>
	<input type="text" name="dni_nie" placeholder="11111111H"/>
	
	<label for="nombre">nOMBRE:</label>
	<input type="text" name="nombre" placeholder="Andreina"/>
	
	<label for="apellido1">Primer apellido:</label>
	<input type="text" name="apellido1" placeholder="Montro"/>
	
	
	<label for="apellido2">Segundo apellido :</label>
	<input type="text" name="apellido2" placeholder="Montro"/>
	

	<label for="telefono">Telefono:</label>
	<input type="text" name="telefono" placeholder="600000000"/>
	
	<label for="file">Foto de perfil:</label>
	<input type="file" name="foto-perfil" />
	
	
	<input type="submit" value="Entrar">
</form>


	

<%@ include file="/html/public/common/footer.jsp"%>