package com.andreina.ushi.web.controller;

import java.io.IOException;
import java.sql.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.andreina.ushi.dao.criteria.UsuarioCriteria;
import com.andreina.ushi.exception.ContentException;
import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.ContentData;
import com.andreina.ushi.model.ContentMetadata;
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
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class PrivateUsuarioServlet
 */
@WebServlet("/private/usuario")

@MultipartConfig(maxFileSize = 5L * 1024 * 1024, maxRequestSize = 6L * 1024 * 1024)

public class PrivateUsuarioServlet extends HttpServlet {

	private static Logger logger = LogManager.getLogger(PrivateUsuarioServlet.class);

	private UsuarioService usuarioService = null;
	private ContentService contentService = null;
	private GranjaService granjaService = null;

	public PrivateUsuarioServlet() {
		super();
		usuarioService = new UsuarioServiceImpl();
		contentService = new ContentServiceFileImpl();
		granjaService = new GranjaServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		UsuarioDTO usuarioAutenticado = (UsuarioDTO) SessionManager.getAttribute(request, AttributeNames.USUARIO);

		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_DETAIL.equalsIgnoreCase(action)) {

			Long usuarioId = Long.valueOf(request.getParameter(PNames.ID));

			if (!RolIds.ADMINISTRADOR.equals(usuarioAutenticado.getRolId())
					&& !usuarioAutenticado.getId().equals(usuarioId)) {
				
				//Error 403: Acceso prohibido
				response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado.");
				return;
			}

			try {
				 UsuarioDTO usuario = usuarioService.findById(usuarioId);

				request.setAttribute(AttributeNames.USUARIO, usuario);
				request.getRequestDispatcher(Views.USUARIO_DETAIL).forward(request, response);

			} catch (Exception e) {
				logger.error("Error al mostrar la vista detalle del usuario", usuarioAutenticado.getId(), e);

			}

		} else if (PValues.ACTION_SELECT_GRANJA.equalsIgnoreCase(action)) {

			// El formulario cambia la selección mediante POST.
			if (!"POST".equalsIgnoreCase(request.getMethod())) {
				response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
				return;
			}

			try {
				// Recupera el ID enviado por el desplegable.
				Long granjaId = Long.valueOf(request.getParameter(PNames.ID));

				// Comprueba el acceso antes de cambiar la granja activa.
				if (!granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN,
							"No tienes acceso a esta explotación.");
					return;
				}

				SessionManager.setAttribute(request, AttributeNames.GRANJA_ACTIVA_ID, granjaId);

				// Vuelve al panel con la nueva selección.
				response.sendRedirect(request.getContextPath() + Views.PANEL_CONTROL);
				return;

			} catch (NumberFormatException e) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST,
						"Selecciona una explotación válida.");
				return;

			} catch (ServiceException e) {
				logger.error("Error al seleccionar la explotación del usuario {}",
						usuarioAutenticado.getId(), e);

				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
						"No se ha podido seleccionar la explotación.");
				return;
			}

		} else if (PValues.ACTION_GETIMAGE.equalsIgnoreCase(action)) {

			ContentMetadata cm = new ContentMetadata();
			cm.setEntityType(AttributeNames.USUARIO);
			cm.setEntityId(usuarioAutenticado.getId().toString());
			cm.setResourceType(AttributeNames.PERFIL);
			cm.setFormat("jpeg");

			try {
				ContentData image = contentService.get(cm);

				if (image == null || image.getRaw() == null) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND);
					return;
				}

				response.setContentType("image/jpeg");
				response.getOutputStream().write(image.getRaw());
				response.getOutputStream().flush();

			} catch (ContentException cs) {
				logger.error("Error obteniendo la imagen del usuario {}", usuarioAutenticado.getId(), cs);

				// Si falla el servicio, devuelve HTTP 500.
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				return;
			}

		} else if (PValues.ACTION_GETPROFILE.equalsIgnoreCase(action)) {

			request.setAttribute(AttributeNames.USUARIO, usuarioAutenticado);
			request.getRequestDispatcher(Views.USUARIO_DETAIL).forward(request, response);

		} else if (PValues.ACTION_UPDATE.equalsIgnoreCase(action)) {

			// Los cambios deben enviarse mediante POST.
			if (!"POST".equalsIgnoreCase(request.getMethod())) {
				response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
				return;
			}

			// Permite mostrar el perfil si se produce un error.
			request.setAttribute(AttributeNames.USUARIO, usuarioAutenticado);

			try {
				UsuarioDTO usuarioActualizado = usuarioService.findById(usuarioAutenticado.getId());

				if (usuarioActualizado == null) {
					request.setAttribute("usuarioError", "No se ha encontrado tu cuenta.");

				} else {
					usuarioActualizado.setDniNie(request.getParameter(PNames.DNI_NIE));
					usuarioActualizado.setNombre(request.getParameter(PNames.NOMBRE));
					usuarioActualizado.setApellido1(request.getParameter(PNames.PRIMER_APELLIDO));
					usuarioActualizado.setApellido2(request.getParameter(PNames.SEGUNDO_APELLIDO));
					usuarioActualizado.setEmail(request.getParameter(PNames.EMAIL));
					usuarioActualizado.setTelefono(request.getParameter(PNames.TELEFONO));
					usuarioActualizado.setFechaNacimiento(Date.valueOf(request.getParameter(PNames.FECHA_NACIMIENTO)));

					boolean actualizado = usuarioService.update(usuarioActualizado);

					if (actualizado) {
						// Renueva los datos de la sesión después de guardar.
						SessionManager.setAttribute(request, AttributeNames.USUARIO, usuarioActualizado);

						// La vista consulta el usuario desde requestScope.
						request.setAttribute(AttributeNames.USUARIO, usuarioActualizado);

						request.setAttribute("usuarioMensaje", "Tus datos se han actualizado correctamente.");

					} else {
						request.setAttribute("usuarioError", "No se han podido actualizar tus datos.");
					}
				}

			} catch (IllegalArgumentException e) {
				// Incluye una fecha vacía o con un formato incorrecto.
				request.setAttribute("usuarioError", "Revisa la fecha de nacimiento.");

			} catch (ServiceException e) {
				logger.error("Error al actualizar el usuario {}", usuarioAutenticado.getId(), e);

				request.setAttribute("usuarioError", "No se han podido actualizar tus datos. Inténtalo de nuevo.");
			}

			// Vuelve al perfil con los datos y el resultado.
			request.getRequestDispatcher(Views.USUARIO_DETAIL).forward(request, response);

		} else if (PValues.ACTION_UPDATE_IMAGE.equalsIgnoreCase(action)) {

			request.setAttribute(AttributeNames.USUARIO, usuarioAutenticado);

			try {
				byte[] foto = WebUtils.getBytes(request, PNames.FOTO_PERFIL);

				if (foto == null) {
					request.setAttribute("fotoError", "Selecciona una foto JPG para guardarla.");

				} else {
					ContentMetadata metadata = new ContentMetadata();
					metadata.setEntityType("usuario");
					metadata.setEntityId(usuarioAutenticado.getId().toString());
					metadata.setResourceType("perfil");
					metadata.setFormat("jpeg");

					ContentData contenido = new ContentData();
					contenido.setRaw(foto);
					contenido.setMetadata(metadata);

					contentService.save(contenido);

					request.setAttribute("fotoMensaje", "La foto de perfil se ha guardado correctamente.");
				}

			} catch (ContentException e) {
				logger.error("Error al guardar la foto del usuario {}", usuarioAutenticado.getId(), e);

				request.setAttribute("fotoError", "No se ha podido guardar la foto. Inténtalo de nuevo.");
			}

			request.getRequestDispatcher(Views.USUARIO_DETAIL).forward(request, response);

		} else if (PValues.ACTION_LOGOUT.equalsIgnoreCase(action))

		{
			HttpSession session = request.getSession();
			session.setAttribute(AttributeNames.USUARIO, null);

			request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
		} else {

		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
