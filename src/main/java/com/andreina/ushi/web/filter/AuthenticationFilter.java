package com.andreina.ushi.web.filter;

import java.io.IOException;

import com.andreina.ushi.model.UsuarioDTO;
import com.andreina.ushi.utils.RolIds;
import com.andreina.ushi.web.utils.AttributeNames;
import com.andreina.ushi.web.utils.PNames;
import com.andreina.ushi.web.utils.PValues;
import com.andreina.ushi.web.view.Views;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/html/private/*", "/private/*", "/animal", "/evento"})
public class AuthenticationFilter extends HttpFilter {
    private static final long serialVersionUID = 1L;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute(AttributeNames.USUARIO) == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + Views.USUARIO_LOGIN);
            return;
        }
        httpResponse.setHeader("Cache-Control", "no-store");
        UsuarioDTO usuario = (UsuarioDTO) session.getAttribute(AttributeNames.USUARIO);
        boolean puedeGestionar = RolIds.ADMINISTRADOR.equals(usuario.getRolId())
                || RolIds.ENCARGADO.equals(usuario.getRolId());
        request.setAttribute("puedeGestionarEventos", puedeGestionar);
        request.setAttribute("puedeGestionarAnimales", puedeGestionar);
        request.setAttribute("puedeGestionarGranjas", RolIds.ADMINISTRADOR.equals(usuario.getRolId()));

        String ruta = httpRequest.getServletPath();
        String action = httpRequest.getParameter(PNames.ACTION);
        boolean rutaAnimalesEventos = "/animal".equals(ruta) || "/evento".equals(ruta);
        boolean accionGestion = PValues.ACTION_CREATE.equalsIgnoreCase(action)
                || PValues.ACTION_UPDATE.equalsIgnoreCase(action)
                || PValues.ACTION_DELETE.equalsIgnoreCase(action);
        boolean formularioGestion = ruta.startsWith("/html/private/animal/")
                || ruta.startsWith("/html/private/evento/");
        formularioGestion = formularioGestion && ruta.endsWith("-form.jsp");

        if (!puedeGestionar && ((rutaAnimalesEventos && accionGestion) || formularioGestion)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Solo tienes permiso de consulta.");
            return;
        }

        if (RolIds.OPERARIO.equals(usuario.getRolId())) {
            boolean consulta = PValues.ACTION_SEARCH.equalsIgnoreCase(action)
                    || PValues.ACTION_DETAIL.equalsIgnoreCase(action);
            boolean vistaConsulta = ruta.startsWith("/html/private/panelControl/")
                    || ruta.startsWith("/html/private/animal/")
                    || ruta.startsWith("/html/private/evento/");
            boolean perfilPropio = "/private/usuario".equals(ruta)
                    && (PValues.ACTION_GETPROFILE.equalsIgnoreCase(action)
                        || PValues.ACTION_GETIMAGE.equalsIgnoreCase(action)
                        || PValues.ACTION_DETAIL.equalsIgnoreCase(action)
                        || PValues.ACTION_UPDATE.equalsIgnoreCase(action)
                        || PValues.ACTION_UPDATE_IMAGE.equalsIgnoreCase(action)
                        || PValues.ACTION_SELECT_GRANJA.equalsIgnoreCase(action)
                        || PValues.ACTION_LOGOUT.equalsIgnoreCase(action));

            if (!(vistaConsulta || (rutaAnimalesEventos && consulta) || perfilPropio)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes acceso a esta sección.");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}
