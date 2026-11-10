package com.andreina.ushiweb.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.andreina.ushi.dao.criteria.AnimalCriteria;
import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.AnimalDTO;
import com.andreina.ushi.model.Results;
import com.andreina.ushi.service.AnimalService;
import com.andreina.ushi.service.impl.AnimalServiceImpl;
import com.andreina.ushiweb.utils.AttributeNames;
import com.andreina.ushiweb.utils.PNames;
import com.andreina.ushiweb.utils.PValues;
import com.andreina.ushiweb.view.Views;

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

	public AnimalServlet() {
		animalService = new AnimalServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		PrintWriter writer = response.getWriter();


		String action = request.getParameter(PNames.ACTION);

		if (PValues.ACTION_DETAIL.equalsIgnoreCase(action)) {

			// Action: Ver el detalle de un evento
			String idStr = request.getParameter(PNames.ID);

			try {
				AnimalDTO animal = animalService.findById(Long.valueOf(idStr));

				//Paso de la petición internamente a una JSP: la vista detalle.
				request.setAttribute(AttributeNames.ANIMAL, animal);
				request.getRequestDispatcher(Views.ANIMAL_DETAIL).forward(request, response);


			} catch (ServiceException e) {
				e.printStackTrace();
			}
		} else if (PValues.ACTION_SEARCH.equalsIgnoreCase(action)) {

			// Action: Buscar eventos
			String animal= request.getParameter(PNames.ANIMAL);

			AnimalCriteria criteria = new AnimalCriteria();
			criteria.setId(null);

			try {
				Results<AnimalDTO> results = animalService.findByCriteria(criteria, 1, Integer.MAX_VALUE);

				//Paso de la petición internamente a una JSP: buscador.
				request.setAttribute(AttributeNames.RESULTS, results);				
				request.getRequestDispatcher(Views.ANIMAL_SEARCH).forward(request, response);

			} catch (ServiceException se) {
				se.printStackTrace();
			}
		} else if(PValues.ACTION_UPDATE.equalsIgnoreCase(action)) {
			
			
			
		} else if (PValues.ACTION_DELETE.equalsIgnoreCase(action)) {
			// Action: Eliminar un evento
			String idStr = request.getParameter(PNames.ID);
			try {
				animalService.delete(Long.valueOf(idStr));
			} catch (ServiceException se) {
				se.printStackTrace();
				writer.append("<i>No ha podido borrarse el anmimal. Por favor contacte con su administrador</i>");
			}
		} else {
			// Niguna action	
		}
		writer.append("</html>");

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}