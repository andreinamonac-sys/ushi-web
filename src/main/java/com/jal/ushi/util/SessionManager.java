package com.jal.ushi.util;

import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionManager {

	
	public static final HttpSession getSession(ServletRequest request) {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		// TODO: Cuando no crear la sesion
		HttpSession session = httpRequest.getSession();
		return session;
	}
	
	public static final Object getAttribute(ServletRequest request, String attributeName) {
		HttpSession session = getSession(request);
		return session.getAttribute(attributeName);
	}

	
	public static final void setAttribute(ServletRequest request, String attributeName, Object value) {
		HttpSession session = getSession(request);
		session.setAttribute(attributeName, value);
	}

}
