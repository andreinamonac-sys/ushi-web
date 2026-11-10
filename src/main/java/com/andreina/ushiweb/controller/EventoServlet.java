package com.andreina.ushiweb.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Date;

import com.andreina.ushi.dao.criteria.EventoCriteria;
import com.andreina.ushi.exception.ServiceException;
import com.andreina.ushi.model.EventoDTO;
import com.andreina.ushi.model.Results;
import com.andreina.ushi.service.EventoService;
import com.andreina.ushi.service.impl.EventoServiceImpl;
import com.andreina.ushiweb.utils.AttributeNames;
import com.andreina.ushiweb.utils.PNames;
import com.andreina.ushiweb.utils.PValues;
import com.andreina.ushiweb.view.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/evento")
public class EventoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EventoService eventoService = new EventoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = parameter(request, PNames.ACTION);
        try {
            if (PValues.ACTION_DETAIL.equalsIgnoreCase(action)) {
                Long id = positiveId(parameter(request, PNames.ID));
                if (id == null) {
                    throw new IllegalArgumentException("Indica el ID del evento.");
                }
                EventoDTO evento = eventoService.findById(id);
                if (evento == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Evento no encontrado.");
                    return;
                }
                request.setAttribute(AttributeNames.EVENTO, evento);
                request.getRequestDispatcher(Views.EVENTO_DETAIL).forward(request, response);
                return;
            }
            if (PValues.ACTION_DELETE.equalsIgnoreCase(action)) {
                Long id = positiveId(parameter(request, PNames.ID));
                if (id == null) {
                    throw new IllegalArgumentException("Indica el ID del evento.");
                }
                eventoService.anularEvento(id);
                response.sendRedirect(request.getContextPath() + "/evento?action=search");
                return;
            }
            if (action != null && !PValues.ACTION_SEARCH.equalsIgnoreCase(action)) {
                throw new IllegalArgumentException("Acción de evento no reconocida.");
            }
            EventoCriteria criteria = new EventoCriteria();
            criteria.setId(positiveId(parameter(request, "id")));
            criteria.setTipoEventoNombre(parameter(request, "tipoEventoNombre"));
            criteria.setVeterinarioNombre(parameter(request, "veterinarioNombre"));
            criteria.setFechaDesde(date(parameter(request, "fechaDesde"), false));
            criteria.setFechaHasta(date(parameter(request, "fechaHasta"), true));
            if (criteria.getFechaDesde() != null && criteria.getFechaHasta() != null
                    && criteria.getFechaDesde().after(criteria.getFechaHasta())) {
                throw new IllegalArgumentException("La fecha desde no puede ser posterior a la fecha hasta.");
            }
            Results<EventoDTO> results = eventoService.findByCriteria(criteria, 1, Integer.MAX_VALUE);
            request.setAttribute(AttributeNames.RESULTS, results);
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("eventoError", e.getMessage());
        } catch (ServiceException e) {
            getServletContext().log("Error consultando eventos", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.setAttribute("eventoError", "No se han podido consultar los eventos. Revisa los logs de Tomcat.");
        }
        request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    private static String parameter(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private static Long positiveId(String value) {
        if (value == null) return null;
        try {
            long id = Long.parseLong(value);
            if (id > 0) return id;
        } catch (NumberFormatException e) {
            // Presentar el mismo mensaje para todos los IDs inválidos.
        }
        throw new IllegalArgumentException("El ID debe ser un número entero positivo.");
    }

    private static Date date(String value, boolean endOfDay) {
        if (value == null) return null;
        try {
            LocalDate day = LocalDate.parse(value);
            long millis = Timestamp.valueOf((endOfDay ? day.plusDays(1) : day).atStartOfDay()).getTime();
            return new Date(endOfDay ? millis - 1 : millis);
        } catch (DateTimeParseException | ArithmeticException e) {
            throw new IllegalArgumentException("Introduce una fecha válida con formato AAAA-MM-DD.");
        }
    }
}
