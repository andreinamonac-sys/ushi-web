package com.andreina.ushiweb.filter;

import java.io.IOException;
import com.andreina.ushiweb.utils.AttributeNames;
import com.andreina.ushiweb.view.Views;
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
        chain.doFilter(request, response);
    }
}
