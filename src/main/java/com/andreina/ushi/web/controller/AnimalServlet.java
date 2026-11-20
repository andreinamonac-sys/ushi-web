package com.andreina.ushi.web.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.andreina.ushi.dao.criteria.AnimalCriteria;
import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.AnimalDTO;
import com.andreina.ushi.model.Results;
import com.andreina.ushi.model.UsuarioDTO;
import com.andreina.ushi.service.AnimalService;
import com.andreina.ushi.service.GranjaService;
import com.andreina.ushi.service.impl.AnimalServiceImpl;
import com.andreina.ushi.service.impl.GranjaServiceImpl;
import com.andreina.ushi.utils.RolIds;
import com.andreina.ushi.web.service.LocalidadServlet;
import com.andreina.ushi.web.utils.AttributeNames;
import com.andreina.ushi.web.utils.PNames;
import com.andreina.ushi.web.utils.PValues;
import com.andreina.ushi.web.utils.SessionManager;
import com.andreina.ushi.web.view.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AnimalServlet
 */
@WebServlet("/animal")
public class AnimalServlet extends HttpServlet {

	private AnimalService animalService = null;
	private GranjaService granjaService = null;
	private static Logger logger = LogManager.getLogger(AnimalServlet .class);

	public AnimalServlet() {
		animalService = new AnimalServiceImpl();
		granjaService = new GranjaServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		UsuarioDTO usuarioAutenticado = (UsuarioDTO) SessionManager.getAttribute(request, AttributeNames.USUARIO);
		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_DETAIL.equalsIgnoreCase(action)) {

			try {
				Long animalId = Long.valueOf(request.getParameter(PNames.ID));
				AnimalDTO animal = animalService.findById(animalId);
				if (animal == null) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND, "El animal no existe.");
					return;
				}
				Long granjaId = (Long) SessionManager.getAttribute(request, AttributeNames.GRANJA_ACTIVA_ID);
				if (granjaId == null || !granjaId.equals(animal.getGranjaId())
						|| !granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes acceso a este animal.");
					return;
				}

				request.setAttribute(AttributeNames.ANIMAL, animal);
				request.getRequestDispatcher(Views.ANIMAL_DETAIL).forward(request, response);

			} catch (NumberFormatException e) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El identificador del animal no es válido.");
			} catch (ServiceException se) {
				throw new ServletException("Error al mostrar el detalle del animal", se);
			}
		} else if (PValues.ACTION_SEARCH.equalsIgnoreCase(action)) {
			Long granjaId = (Long) SessionManager.getAttribute(request, AttributeNames.GRANJA_ACTIVA_ID);
			if (granjaId == null) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Selecciona una explotación.");
				return;
			}
			try {
				if (!granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes acceso a esta explotación.");
					return;
				}
				AnimalCriteria criteria = new AnimalCriteria();
				criteria.setGranjaId(granjaId);
				criteria.setCrotal(request.getParameter(PNames.CROTAL));
				criteria.setTagAsociado(request.getParameter(PNames.TAG_ASOCIADO));
				criteria.setCrotalMadreInterna(request.getParameter(PNames.CROTAL_MADRE_INTERNA));

				String animalId = request.getParameter(PNames.ID);
				if (animalId != null && !animalId.trim().isEmpty()) {
					criteria.setId(Long.valueOf(animalId.trim()));
				}
				String sexoId = request.getParameter("sexo-id");
				if (sexoId != null && !sexoId.trim().isEmpty()) {
					criteria.setSexoId(Long.valueOf(sexoId.trim()));
				}
				String padreId = request.getParameter(PNames.PADRE_EXTERNO_ID);
				if (padreId != null && !padreId.trim().isEmpty()) {
					criteria.setPadreExternoId(Long.valueOf(padreId.trim()));
				}
				String madreId = request.getParameter(PNames.MADRE_EXTERNA_ID);
				if (madreId != null && !madreId.trim().isEmpty()) {
					criteria.setMadreExternaId(Long.valueOf(madreId.trim()));
				}

			String fechaNacimientoDesde = request.getParameter(PNames.FECHA_NACIMIENTO_DESDE);
		    if (fechaNacimientoDesde != null && !fechaNacimientoDesde.trim().isEmpty()) {
		        criteria.setFechaNacimientoDesde(Date.valueOf(fechaNacimientoDesde.trim()));
		    }

		    String fechaNacimientoHasta = request.getParameter(PNames.FECHA_NACIMIENTO_HASTA);
		    if (fechaNacimientoHasta != null && !fechaNacimientoHasta.trim().isEmpty()) {
		        criteria.setFechaNacimientoHasta(Date.valueOf(fechaNacimientoHasta.trim()));
		    }
		    
		    String fechaAltaDesde = request.getParameter(PNames.FECHA_ALTA_DESDE);
		    if (fechaAltaDesde != null && !fechaAltaDesde.trim().isEmpty()) {
		        criteria.setFechaAltaDesde(Date.valueOf(fechaAltaDesde.trim()));
		    }

		    String fechaAltaHasta = request.getParameter(PNames.FECHA_ALTA_HASTA);
		    if (fechaAltaHasta != null && !fechaAltaHasta.trim().isEmpty()) {
		        criteria.setFechaAltaHasta(Date.valueOf(fechaAltaHasta.trim()));
		    }
		    
		    String fechaBajaDesde = request.getParameter(PNames.FECHA_BAJA_DESDE);
		    if (fechaBajaDesde != null && !fechaBajaDesde.trim().isEmpty()) {
		        criteria.setFechaBajaDesde(Date.valueOf(fechaBajaDesde.trim()));
		    }

		    String fechaBajaHasta = request.getParameter(PNames.FECHA_BAJA_HASTA);
		    if (fechaBajaHasta != null && !fechaBajaHasta.trim().isEmpty()) {
		        criteria.setFechaBajaHasta(Date.valueOf(fechaBajaHasta.trim()));
		    }
				Results<AnimalDTO> results = animalService.findByCriteria(criteria, 1, Integer.MAX_VALUE);
				request.setAttribute(AttributeNames.RESULTS, results);
			} catch (IllegalArgumentException e) {
				request.setAttribute("animalError", "Revisa los identificadores y las fechas de los filtros.");
			} catch (ServiceException se) {
				logger.error("Error al buscar animales de la explotación {}", granjaId, se);
				request.setAttribute("animalError", "No se han podido consultar los animales.");
			}
			request.getRequestDispatcher(Views.ANIMAL_SEARCH).forward(request, response);
		} else if(PValues.ACTION_UPDATE.equalsIgnoreCase(action)) {
			
			
			
		} else if (PValues.ACTION_DELETE.equalsIgnoreCase(action)) {
			String idStr = request.getParameter(PNames.ID);
			try {
				animalService.delete(Long.valueOf(idStr));
			} catch (ServiceException se) {
				se.printStackTrace();
				
			}
		} else {
			// Niguna action	
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
