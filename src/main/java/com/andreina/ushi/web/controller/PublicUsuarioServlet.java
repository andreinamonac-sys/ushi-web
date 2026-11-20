package com.andreina.ushi.web.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.andreina.ushi.exception.ContentException;
import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.ContentData;
import com.andreina.ushi.model.ContentMetadata;
import com.andreina.ushi.model.GranjaDTO;
import com.andreina.ushi.model.UsuarioDTO;
import com.andreina.ushi.service.ContentService;
import com.andreina.ushi.service.GranjaService;
import com.andreina.ushi.service.UsuarioService;
import com.andreina.ushi.service.impl.ContentServiceFileImpl;
import com.andreina.ushi.service.impl.GranjaServiceImpl;
import com.andreina.ushi.service.impl.UsuarioServiceImpl;
import com.andreina.ushi.utils.RolIds;
import com.andreina.ushi.web.utils.AttributeNames;
import com.andreina.ushi.web.utils.PNames;
import com.andreina.ushi.web.utils.PValues;
import com.andreina.ushi.web.utils.SessionManager;
import com.andreina.ushi.web.utils.WebUtils;
import com.andreina.ushi.web.view.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/public/usuario")

@MultipartConfig(maxFileSize = 5L * 1024 * 1024, maxRequestSize = 6L * 1024 * 1024)

public class PublicUsuarioServlet extends HttpServlet {

	private static Logger logger = LogManager.getLogger(PublicUsuarioServlet.class);

	private UsuarioService usuarioService = null;
	private ContentService contentService = null;
	private GranjaService granjaService = null;

	public PublicUsuarioServlet() {
		super();
		usuarioService = new UsuarioServiceImpl();
		contentService = new ContentServiceFileImpl();
		granjaService = new GranjaServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_REGISTER.equalsIgnoreCase(action)) {

			UsuarioDTO nuevoUsuario = new UsuarioDTO();

			nuevoUsuario.setDniNie(request.getParameter(PNames.DNI_NIE));
			nuevoUsuario.setNombre(request.getParameter(PNames.NOMBRE));
			nuevoUsuario.setApellido1(request.getParameter(PNames.PRIMER_APELLIDO));
			nuevoUsuario.setApellido2(request.getParameter(PNames.SEGUNDO_APELLIDO));
			nuevoUsuario.setEmail(request.getParameter(PNames.EMAIL));
			nuevoUsuario.setPassword(request.getParameter(PNames.PASSWORD));
			nuevoUsuario.setTelefono(request.getParameter(PNames.TELEFONO));

			// El rol del registro se establece en el servidor.
			nuevoUsuario.setRolId(RolIds.OPERARIO);

			String fechaNacimiento = request.getParameter(PNames.FECHA_NACIMIENTO);

			// La fecha de nacimiento es obligatoria.
			if (fechaNacimiento == null || fechaNacimiento.trim().isEmpty()) {
				request.setAttribute("registerError", "Introduce tu fecha de nacimiento.");

				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
				return;
			}

			try {
				// Convierte el texto yyyy-MM-dd a java.sql.Date.
				nuevoUsuario.setFechaNacimiento(Date.valueOf(fechaNacimiento.trim()));

			} catch (IllegalArgumentException e) {
				// Si falla la conversión, vuelve al formulario.
				request.setAttribute("registerError", "Revisa la fecha de nacimiento.");

				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
				return;
			}

			Long id = null;
			String mensajeRegistro = "Tu cuenta se ha creado. Ya puedes iniciar sesión.";

			try {
				// Registra al usuario y recupera su ID.
				id = usuarioService.registrar(nuevoUsuario);

				// WebUtils utiliza Part y devuelve null si no se seleccionó foto.
				byte[] foto = WebUtils.getBytes(request, PNames.FOTO_PERFIL);

				if (foto != null) {
					// Asocia la foto al usuario recién registrado.
					ContentMetadata metadata = new ContentMetadata();
					metadata.setEntityType("usuario");
					metadata.setEntityId(id.toString());
					metadata.setResourceType("perfil");

					// Conserva el formato actual del proyecto.
					// Un PNG necesita detectar su formato o convertirlo a JPEG.
					metadata.setFormat("jpeg");

					ContentData contenido = new ContentData();
					contenido.setRaw(foto);
					contenido.setMetadata(metadata);

					contentService.save(contenido);
				}

			} catch (ServiceException e) {
				// Si falla el registro, muestra el error y termina la petición.
				logger.error("Error al registrar el usuario", e);

				request.setAttribute("registerError", "No se ha podido completar el registro. Revisa tus datos.");

				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
				return;

			} catch (ContentException e) {
				// La cuenta ya está creada, pero ha fallado la foto opcional.
				logger.error("Error al leer o guardar la foto del usuario {}", id, e);

				mensajeRegistro = "Tu cuenta se ha creado, pero no se ha podido guardar la foto. "
						+ "Ya puedes iniciar sesión.";
			}

			// La JSP del login muestra el mensaje y lo elimina de la sesión.
			SessionManager.setAttribute(request, "registrationMessage", mensajeRegistro);

			request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
		
	}else if(PValues.ACTION_LOGIN.equalsIgnoreCase(action))

	{

		String email = request.getParameter(PNames.EMAIL);
		String password = request.getParameter(PNames.PASSWORD);

		try {
			UsuarioDTO usuario = usuarioService.login(email, password);

			if (usuario == null) {

				request.setAttribute("loginError", "El correo o la contraseña no son correctos.");
				request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
				return;
			}

			List<GranjaDTO> granjasAccesibles = new ArrayList<>();

			// Reúne todas las granjas a las que puede acceder el usuario.
			for (GranjaDTO granja : granjaService.findAll()) {
				if (granjaService.tieneAccesoAGranja(usuario, granja.getId())) {
					granjasAccesibles.add(granja);
				}
			}

			Long granjaActivaId = null;

			// Selecciona inicialmente la primera granja accesible.
			if (!granjasAccesibles.isEmpty()) {
				granjaActivaId = granjasAccesibles.get(0).getId();
			}

			SessionManager.getSession(request);
			SessionManager.setAttribute(request, AttributeNames.USUARIO, usuario);
			SessionManager.setAttribute(request, AttributeNames.GRANJAS_ACCESIBLES, granjasAccesibles);
			SessionManager.setAttribute(request, AttributeNames.GRANJA_ACTIVA_ID, granjaActivaId);
			request.getRequestDispatcher(Views.PANEL_CONTROL).forward(request, response);

		} catch (ServiceException se) {
			logger.error("Error al iniciar sesión o al cargar la explotación activa", se);

		}
	}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
