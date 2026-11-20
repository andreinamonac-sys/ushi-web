package com.andreina.ushi.web.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.andreina.ushi.dao.criteria.EventoCriteria;
import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.AnimalDTO;
import com.andreina.ushi.model.Evento;
import com.andreina.ushi.model.EventoDTO;
import com.andreina.ushi.model.Results;
import com.andreina.ushi.model.UsuarioDTO;
import com.andreina.ushi.service.AnimalService;
import com.andreina.ushi.service.EventoService;
import com.andreina.ushi.service.GranjaService;
import com.andreina.ushi.service.TipoEventoService;
import com.andreina.ushi.service.UsuarioService;
import com.andreina.ushi.service.impl.AnimalServiceImpl;
import com.andreina.ushi.service.impl.EventoServiceImpl;
import com.andreina.ushi.service.impl.GranjaServiceImpl;
import com.andreina.ushi.service.impl.TipoEventoServiceImpl;
import com.andreina.ushi.service.impl.UsuarioServiceImpl;
import com.andreina.ushi.utils.RolIds;
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
 * Servlet implementation class HelloWorldServlet
 */
@WebServlet("/evento")
public class EventoServlet extends HttpServlet {

	private static Logger logger = LogManager.getLogger(EventoServlet.class);

	private EventoService eventoService = null;
	private TipoEventoService tipoEventoService = null;
	private UsuarioService usuarioService = null;
	private GranjaService granjaService = null;
	private AnimalService animalService = null;

	public EventoServlet() {
		eventoService = new EventoServiceImpl();
		usuarioService = new UsuarioServiceImpl();
		tipoEventoService = new TipoEventoServiceImpl();
		granjaService = new GranjaServiceImpl();
		animalService = new AnimalServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		UsuarioDTO usuarioAutenticado = (UsuarioDTO) SessionManager.getAttribute(request, AttributeNames.USUARIO);

		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_DETAIL.equalsIgnoreCase(action)) {

			try {
				Long eventoId = Long.valueOf(request.getParameter(PNames.ID));
				EventoDTO evento = eventoService.findById(eventoId);
				if (evento == null) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND, "El evento no existe.");
					return;
				}
				AnimalDTO animal = animalService.findById(evento.getAnimalId());
				Long granjaId = (Long) SessionManager.getAttribute(request, AttributeNames.GRANJA_ACTIVA_ID);
				if (animal == null || granjaId == null || !granjaId.equals(animal.getGranjaId())
						|| !granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes acceso a este evento.");
					return;
				}

				request.setAttribute(AttributeNames.EVENTO, evento);
				request.getRequestDispatcher(Views.EVENTO_DETAIL).forward(request, response);

			} catch (NumberFormatException e) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El identificador del evento no es válido.");
			} catch (ServiceException e) {
				throw new ServletException("Error al visualizar el detalle del evento", e);
			}
		} else if (PValues.ACTION_SEARCH.equalsIgnoreCase(action)) {

			// 1. La granja activa se guarda al iniciar sesión.
			Long granjaId = (Long) SessionManager.getAttribute(request, AttributeNames.GRANJA_ACTIVA_ID);

			if (granjaId == null) {
				request.setAttribute("eventoError", "No hay una explotación asignada");
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);
				return;
			}

			try {
				// 2.Comprueba el acceso antes de consultar datos de la granja.
				if (!granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {
					request.setAttribute("eventoError", "No tienes acceso a esta explotación.");
					request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);
					return;
				}

				// 3.Cargar las listas que utiliza la vista.
				request.setAttribute(AttributeNames.TIPOS_EVENTOS, tipoEventoService.findAll());

				List<UsuarioDTO> veterinarios = usuarioService.findVeterinariosByGranjaId(granjaId);
				request.setAttribute(AttributeNames.VETERINARIOS, veterinarios);

				// 4.Filtros enviados por el buscador.
				EventoCriteria criteria = new EventoCriteria();
				criteria.setGranjaId(granjaId); // La búsqueda se limita a la explotación
				criteria.setCrotal(request.getParameter(PNames.CROTAL));

				String fechaDesde = request.getParameter(PNames.FECHA_DESDE);
				if (fechaDesde != null && !fechaDesde.trim().isEmpty()) {
					criteria.setFechaDesde(Date.valueOf(fechaDesde.trim()));
				}

				String fechaHasta = request.getParameter(PNames.FECHA_HASTA);
				if (fechaHasta != null && !fechaHasta.trim().isEmpty()) {
					criteria.setFechaHasta(Date.valueOf(fechaHasta.trim()));
				}

				String tipoEventoId = request.getParameter(PNames.TIPO_EVENTO_ID);
				if (tipoEventoId != null && !tipoEventoId.trim().isEmpty()) {
					criteria.setTipoEventoId(Long.valueOf(tipoEventoId.trim()));
				}

				String veterinarioId = request.getParameter(PNames.VETERINARIO_ID);
				if (veterinarioId != null && !veterinarioId.trim().isEmpty()) {
					criteria.setVeterinarioId(Long.valueOf(veterinarioId.trim()));
				}

				// 5. Consultar una página de 20 eventos.
				int eventosPorPagina = 20;
				int pagina = 1;
				String paginaStr = request.getParameter(PNames.PAGINA);
				if (paginaStr != null && !paginaStr.trim().isEmpty()) {
					try {
						pagina = Math.max(1, Integer.parseInt(paginaStr.trim()));
					} catch (NumberFormatException e) {
						pagina = 1;
					}
				}

				// El middleware recibe la posición inicial, comenzando por 1.
				long posicionInicial = ((long) pagina - 1) * eventosPorPagina + 1;
				if (posicionInicial > Integer.MAX_VALUE) {
					posicionInicial = Integer.MAX_VALUE;
				}
				Results<EventoDTO> results = eventoService.findByCriteria(criteria, (int) posicionInicial,
						eventosPorPagina);
				int totalPaginas = 1;
				if (results.getTotal() > 0) {
					totalPaginas = (results.getTotal() - 1) / eventosPorPagina + 1;
				}

				// Corregir páginas que hayan quedado fuera del total tras filtrar.
				if (pagina > totalPaginas) {
					pagina = totalPaginas;
					if (results.getTotal() > 0) {
						int desde = (pagina - 1) * eventosPorPagina + 1;
						results = eventoService.findByCriteria(criteria, desde, eventosPorPagina);
					}
				}

				request.setAttribute(AttributeNames.RESULTS, results);
				request.setAttribute("paginaActual", pagina);
				request.setAttribute("totalPaginas", totalPaginas);
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);

			} catch (ServiceException se) {
				logger.error("Error al cargar el buscador de eventos de la granja {}", granjaId, se);
			}
		} else if (PValues.ACTION_DELETE.equalsIgnoreCase(action)) {

			if (usuarioAutenticado == null || (!RolIds.ADMINISTRADOR.equals(usuarioAutenticado.getRolId())
					&& !RolIds.ENCARGADO.equals(usuarioAutenticado.getRolId()))) {

				response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para eliminar eventos.");
				return;
			}

			Long granjaId = (Long) SessionManager.getAttribute(request, AttributeNames.GRANJA_ACTIVA_ID);
			Long eventoId = Long.valueOf(request.getParameter(PNames.ID));
			
			try {

				if (eventoId <= 0) {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El identificador del evento no es válido.");
					return;
				}

				// Buscar el evento.
				EventoDTO evento = eventoService.findById(eventoId);

				if (evento == null) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND, "El evento no existe.");
					return;
				}

				// Comprobar la explotación del animal.
				AnimalDTO animal = animalService.findById(evento.getAnimalId());

				if (animal == null || !granjaId.equals(animal.getGranjaId())
						|| !granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {

					response.sendError(HttpServletResponse.SC_FORBIDDEN,
							"No tienes acceso al evento de esta explotación.");
					return;
				}

				// Eliminar el evento.
				boolean eliminado = eventoService.anularEvento(eventoId);

				if (!eliminado) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND, "El evento ya no está disponible.");
					return;
				}

				// Volver al listado.
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);

			} catch (ServiceException e) {
				logger.error("Error al eliminar el evento {}", eventoId, e);

				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se ha podido eliminar el evento.");
			}
		
	}else if(PValues.ACTION_CREATE.equalsIgnoreCase(action))

	{

		Long granjaId = (Long) SessionManager.getAttribute(request, AttributeNames.GRANJA_ACTIVA_ID);

		if (granjaId == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Selecciona una explotación.");
			return;
		}

		try {
			// Comprobar acceso a la explotación.
			if (!granjaService.tieneAccesoAGranja(usuarioAutenticado, granjaId)) {

				response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes acceso a esta explotación.");
				return;
			}

			// Cargar los desplegables.
			request.setAttribute(AttributeNames.TIPOS_EVENTOS, tipoEventoService.findAll());

			List<UsuarioDTO> veterinarios = usuarioService.findVeterinariosByGranjaId(granjaId);

			request.setAttribute(AttributeNames.VETERINARIOS, veterinarios);

			// Mostrar el formulario al entrar por primera vez.
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				request.getRequestDispatcher(Views.EVENTO_CREATE).forward(request, response);
				return;
			}

			Evento nuevoEvento = new Evento();

			String crotal = request.getParameter(PNames.CROTAL);
			AnimalDTO animal = animalService.findByCrotal(crotal);

			if (animal == null || !granjaId.equals(animal.getGranjaId())) {
				throw new IllegalArgumentException("El animal no pertenece a esta explotación.");
			}

			nuevoEvento.setAnimalId(animal.getId());
			nuevoEvento.setDescripcion(request.getParameter(PNames.DESCRIPCION));
			String fechaHora = request.getParameter(PNames.FECHA_HORA);
			if (fechaHora == null || fechaHora.trim().isEmpty()) {
				throw new IllegalArgumentException("Introduce la fecha y hora.");
			}

			nuevoEvento.setFechaDesde(Timestamp.valueOf(LocalDateTime.parse(fechaHora.trim())));

			Long tipoEventoId = Long.valueOf(request.getParameter(PNames.TIPO_EVENTO_ID));
			nuevoEvento.setTipoEventoId(tipoEventoId);
			// Gestación: recoger el diagnóstico.
			if (tipoEventoId.equals(1L)) {

				String diagnostico = request.getParameter(PNames.DIAGNOSTICO);

				if (!"P".equals(diagnostico) && !"N".equals(diagnostico)) {

					throw new IllegalArgumentException("Selecciona el diagnóstico de gestación.");
				}

				nuevoEvento.setValorDiagnostico(diagnostico);

				// Inseminación: recoger la semilla.
			} else if (tipoEventoId.equals(2L)) {

				Long semillaId = Long.valueOf(request.getParameter(PNames.SEMILLA_ID));

				nuevoEvento.setSemillaId(semillaId);

				// Tratamiento: recoger la dosis.
			} else if (tipoEventoId.equals(3L)) {

				Long dosisId = Long.valueOf(request.getParameter(PNames.DOSIS_ID));

				nuevoEvento.setDosisId(dosisId);

				// Parto: buscar la cría por su crotal.
			} else if (tipoEventoId.equals(4L)) {

				String crotalCria = request.getParameter(PNames.CROTAL_CRIA);

				AnimalDTO cria = animalService.findByCrotal(crotalCria);

				if (cria == null || !granjaId.equals(cria.getGranjaId()) || animal.getId().equals(cria.getId())) {

					throw new IllegalArgumentException("La cría indicada no es válida.");
				}

				nuevoEvento.setCriaId(cria.getId());
			}

			// Veterinario opcional, salvo en Revisión veterinaria.
			String veterinarioId = request.getParameter(PNames.VETERINARIO_ID);

			if (veterinarioId != null && !veterinarioId.trim().isEmpty()) {

				Long idVeterinario = Long.valueOf(veterinarioId);

				boolean tieneAcceso = false;

				for (UsuarioDTO veterinario : veterinarios) {
					if (idVeterinario.equals(veterinario.getId())) {
						tieneAcceso = true;
						break;
					}
				}

				if (!tieneAcceso) {
					throw new IllegalArgumentException("El veterinario no trabaja en esta explotación.");
				}

				nuevoEvento.setVeterinarioId(idVeterinario);
			}

			if (tipoEventoId.equals(5L) && nuevoEvento.getVeterinarioId() == null) {

				throw new IllegalArgumentException("La revisión veterinaria necesita un veterinario.");
			}

			// Guardar mediante el middleware.
			eventoService.create(nuevoEvento);

			response.sendRedirect(request.getContextPath() + "/evento?action=search");
			return;

		} catch (DateTimeParseException e) {
			request.setAttribute("eventoError", "Introduce una fecha y hora válidas.");

		} catch (NumberFormatException e) {
			request.setAttribute("eventoError", "Revisa los identificadores de los campos obligatorios.");

		} catch (IllegalArgumentException e) {
			request.setAttribute("eventoError", e.getMessage());

		} catch (ServiceException e) {
			logger.error("Error al crear el evento", e);

			request.setAttribute("eventoError", "No se ha podido guardar el evento.");
		}

		request.getRequestDispatcher(Views.EVENTO_CREATE).forward(request, response);
	}else if(PValues.ACTION_UPDATE.equalsIgnoreCase(action))
	{

	}else
	{

	}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		doGet(request, response);
	}

}
