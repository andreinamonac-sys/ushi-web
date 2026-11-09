package com.jal.ushi.filter;

import java.io.IOException;

import com.andreina.ushi.model.Usuario;
import com.jal.ushi.util.AttributeNames;
import com.jal.ushi.view.Views;
import com.jal.ushi.util.*;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Filtro de autenticación para parte privada
 */
@WebFilter("/AuthenticationFilter")
public class AuthenticationFilter extends HttpFilter implements Filter {
       
    
    public AuthenticationFilter() {
        super();
       
    }

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		Usuario usuario  = (Usuario) SessionManager.getAttribute(request,AttributeNames.USUARIO);
		
		if(usuario == null) {
			//usuario autenticado
			chain.doFilter(request, response);
		}else {
			HttpServletResponse httpResponse = (HttpServletResponse) response;
			httpResponse.sendRedirect("/ushi-web/"+Views.USUARIO_LOGIN);
		}
		

	}	
		

	public void destroy() {
		
	}
	public void init(FilterConfig fConfig) throws ServletException {
		
	}

}
