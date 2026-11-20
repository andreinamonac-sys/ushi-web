package com.andreina.ushi.web.utils;

import java.io.IOException;
import java.io.InputStream;

import com.andreina.ushi.exception.ContentException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

public class WebUtils {

	// Devuelve los bytes del archivo o null si no se ha adjuntado ninguno.
	public static byte[] getBytes(HttpServletRequest request, String fileParameterName) throws ContentException {

		try {
			// Recupera el archivo por el name del campo del formulario.
			// Por ejemplo: <input type="file" name="foto-perfil">.
			Part foto = request.getPart(fileParameterName);

			if (foto == null || foto.getSubmittedFileName() == null || foto.getSubmittedFileName().trim().isEmpty()
					|| foto.getSize() == 0) {
				return null;
			}

			// Abre el flujo de lectura y lo cierra automáticamente al terminar.
			try (InputStream input = foto.getInputStream()) {

				// Lee el contenido completo del archivo.

				byte[] bytes = input.readAllBytes();

				return bytes;
			}

		} catch (IOException | ServletException | IllegalStateException e) {

			// Conserva el error original como causa de ContentException.
			// Puede ser un error de lectura, de procesamiento multipart
			// o haberse superado el límite de tamaño.
			throw new ContentException(fileParameterName, e);
		}
	}
}