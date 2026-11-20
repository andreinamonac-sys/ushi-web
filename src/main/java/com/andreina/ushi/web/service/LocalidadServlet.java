package com.andreina.ushi.web.service;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.LocalidadDTO;
import com.andreina.ushi.service.LocalidadService;
import com.andreina.ushi.service.impl.LocalidadServiceImpl;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/localidad")
public class LocalidadServlet extends HttpServlet {

	private LocalidadService localidadService = null;
	private Gson gson = null;
	private static Logger logger = LogManager.getLogger(LocalidadServlet.class);

	public LocalidadServlet() {
		super();
		localidadService = new LocalidadServiceImpl();
		gson = new Gson();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String idProvinciaStr = request.getParameter("id-provincia");
		Long idProvincia = Long.valueOf(idProvinciaStr);
		try {

			List<LocalidadDTO> localidades = localidadService.findLocalidadByProvincia(idProvincia);

			String json = gson.toJson(localidades);
			response.setContentType("application/json");
			OutputStream os = response.getOutputStream();
			os.write(json.getBytes());
			os.flush();

		} catch (ServiceException se) {
			logger.error("Error al listar las localidades por provincia", idProvincia, se);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
