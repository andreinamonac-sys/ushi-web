package com.andreina.ushiweb.controller;

import java.io.IOException;

import java.sql.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.ContentData;
import com.andreina.ushi.model.ContentMetadata;
import com.andreina.ushi.model.UsuarioDTO;
import com.andreina.ushi.service.ContentService;
import com.andreina.ushi.service.UsuarioService;
import com.andreina.ushi.service.impl.ContentServiceFileImpl;
import com.andreina.ushi.service.impl.UsuarioServiceImpl;
import com.andreina.ushiweb.utils.AttributeNames;
import com.andreina.ushiweb.utils.PNames;
import com.andreina.ushiweb.utils.PValues;
import com.andreina.ushiweb.utils.WebUtils;
import com.andreina.ushiweb.view.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UserServlet
 */
@WebServlet("/public/usuario")
public class PublicUsuarioServlet extends HttpServlet {

	private static Logger logger = LogManager.getLogger(PublicUsuarioServlet.class);

	private UsuarioService usuarioService = null;
	private ContentService contentService = null;

	public PublicUsuarioServlet() {
		super();
		usuarioService = new UsuarioServiceImpl();
		contentService = new ContentServiceFileImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_REGISTER.equalsIgnoreCase(action)) {

			// Recoger los parámetros mandados en el POST
			UsuarioDTO nuevoUsuario = new UsuarioDTO();

			nuevoUsuario.setDniNie(request.getParameter(PNames.DNI_NIE));
			nuevoUsuario.setNombre(request.getParameter(PNames.NOMBRE));
			nuevoUsuario.setApellido1(request.getParameter(PNames.PRIMER_APELLIDO));
			nuevoUsuario.setApellido2(request.getParameter(PNames.SEGUNDO_APELLIDO));
			nuevoUsuario.setFechaNacimiento(Date.valueOf(request.getParameter(PNames.FECHA_NACIMIENTO)));
			nuevoUsuario.setEmail(request.getParameter(PNames.EMAIL));
			nuevoUsuario.setPassword(request.getParameter(PNames.PASSWORD));
			nuevoUsuario.setTelefono(Long.valueOf(request.getParameter(PNames.TELEFONO)));
			nuevoUsuario.setRolId(1l);

			try {
				// Llamamos al Servicio y este usa el dao para añadir los datos.
				Long id = usuarioService.registrar(nuevoUsuario);

				// Pasamos la imagen
				ContentData cd = new ContentData();
				cd.setRaw(WebUtils.getBytes(request, action));

				ContentMetadata cm = new ContentMetadata();
				cm.setEntityType("usuario");
				cm.setEntityId(id.toString());
				cm.setResourceType("perfil");
				cm.setFormat("jpeg");

				cd.setMetadata(cm);

				// Llamamos al ContentService para guardar la imagen (método save) y este a su
				// vez al FileUtils para los byte[]
				contentService.save(cd);

				// Redirigir con forward al login
				request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);

			} catch (ServiceException se) {
				logger.error("Registrando usuario: " + request.getParameter(PNames.EMAIL), se);
			}

		} else if (PValues.ACTION_LOGIN.equalsIgnoreCase(action)) {
			String email = request.getParameter(PNames.EMAIL);
			String password = request.getParameter(PNames.PASSWORD);

			try {
				UsuarioDTO usuario = usuarioService.login(email, password);

				if (usuario == null) {
					request.setAttribute("loginError", "El correo o la contraseña no son correctos.");

					request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
					return;
				}

				request.getSession().setAttribute(AttributeNames.USUARIO, usuario);

				request.getRequestDispatcher(Views.PANEL_CONTROL).forward(request, response);
				return;

			} catch (ServiceException se) {
				logger.error("Error al iniciar sesión", se);

			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
