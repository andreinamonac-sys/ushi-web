package com.jal.ushi.servlet;

import java.io.IOException;
import java.util.List;

import org.apache.commons.fileupload2.core.DiskFileItem;
import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.jakarta.servlet5.JakartaServletDiskFileUpload;
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
import com.jal.ushi.util.AttributeNames;
import com.jal.ushi.util.PNames;
import com.jal.ushi.util.PValues;
import com.jal.ushi.util.WebUtils;
import com.jal.ushi.view.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UserServlet
 */
@WebServlet("/servlet/public/usuario")
public class PublicUsuarioServlet extends HttpServlet {

	private static Logger logger = LogManager.getLogger(PublicUsuarioServlet.class);
	
	private UsuarioService usuarioService = null;
	private ContentService contentService=null;

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
			nuevoUsuario.setEmail(request.getParameter("login"));
			nuevoUsuario.setPassword(request.getParameter(PNames.PASSWORD));
			nuevoUsuario.setTelefono(Long.valueOf(request.getParameter(PNames.TELEFONO)));
			//String fechaNacimientoStr = request.getParameter("fechaNacimiento");
			
			nuevoUsuario.setRolId(1l);
		
			try {
				// Llamamos al Servicio y este usa el dao para añadir los datos.
				Long id = usuarioService.registrar(nuevoUsuario);
				
				
				
				//Pasamos la imagen
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
				logger.error("Registrando usuario: "+request.getParameter(PNames.EMAIL), se);
			}
			
		} else if (PValues.ACTION_LOGIN.equalsIgnoreCase(action)) {
			String email = request.getParameter(PNames.EMAIL);
			String password = request.getParameter(PNames.PASSWORD);
			try {
				UsuarioDTO usuario = usuarioService.login(email, password);
				request.getSession().setAttribute(AttributeNames.USUARIO, usuario);
				request.getRequestDispatcher(password);

			} catch (Exception se) {
				se.printStackTrace();
			}

		} else if (PValues.ACTION_LOGOUT.equalsIgnoreCase(action)) {
			HttpSession session = request.getSession();
			session.setAttribute(AttributeNames.USUARIO, null);
		}
	

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
