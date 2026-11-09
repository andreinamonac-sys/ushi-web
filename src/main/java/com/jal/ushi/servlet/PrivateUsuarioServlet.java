package com.jal.ushi.servlet;

import java.io.IOException;

import com.andreina.ushi.exception.ContentException;
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
import com.jal.ushi.util.SessionManager;
import com.jal.ushi.view.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class PrivateUsuarioServlet
 */
@WebServlet("/servlet/private/usuario")
public class PrivateUsuarioServlet extends HttpServlet {

	private UsuarioService usuarioService = null;
	private ContentService contentService = null;

	public PrivateUsuarioServlet() {
		super();
		usuarioService = new UsuarioServiceImpl();
		contentService = new ContentServiceFileImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		UsuarioDTO usuarioAutenticado = (UsuarioDTO) SessionManager.getAttribute(request,AttributeNames.USUARIO);
		
		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_DETAIL.equalsIgnoreCase(action)) {
			// Action: Ver el detalle de un usuario
			//TO DO: if administrador (OR el usuario autenticado tiene le mimsmo id que el GET
			
			String idStr = request.getParameter(PNames.ID);

			/*try {
				UsuarioCriteria criteria = new UsuarioCriteria( );
				criteria.setId(Long.valueOf(idStr));*/
				UsuarioDTO usuario = null;//usuarioService.findByCriteria(criteria,0,1);

				// Paso de la petición internamente a una JSP: la vista detalle.
				request.setAttribute(AttributeNames.USUARIO, usuario);
				request.getRequestDispatcher(Views.USUARIO_DETAIL).forward(request, response);

				/*
				 * } catch (ServiceException e) { e.printStackTrace(); }
				 */
			
		} else if (PValues.ACTION_UPDATE.equalsIgnoreCase(action)) {
			
			// ..
		} else if (PValues.ACTION_GETIMAGE.equalsIgnoreCase(action)) {
			
			ContentMetadata cm = new ContentMetadata();
			cm.setEntityType("usuario");
			//cm.setEntityId(usuarioAutenticado.getId().toString());
			cm.setEntityId(request.getParameter(PNames.ID)); // SEGURIDAD
			cm.setResourceType(request.getParameter(PNames.RESOURCE_TYPE)); // como parametro
			cm.setFormat("jpeg");
			
			
			try {
				ContentData  image = contentService.get(cm);
				
				// mimetype: Le indica al navegador que la respuesta contiene una imagen.
				response.setContentType("image/jpeg");
				
				//output. <- Provides an output stream for sending binary data to the client.     
				//write()<-Envia los bytes por la "tubería"/flujo de salida. Necesito byte []. -> raw del ContentData
				
				response.getOutputStream().write(image.getRaw());
				response.getOutputStream().flush();
				

			} catch(ContentException cs) {
				cs.printStackTrace();
			}
		} else {
			// TODO: forward a pagina error
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
