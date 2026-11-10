<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ushi - Panel de control</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/ushi.css">
</head>
<body class="dashboard-page">
	<%@ include file="/html/private/panelControl/menu.jsp"%>
	<div class="dashboard-wrap">
		<header class="topbar">
			<div class="topbar-left">
				<div>
					<small>Finca A Lagoa</small><strong>Panel de control</strong>
				</div>
			</div>
			<div class="topbar-right">
				<label class="global-search"><svg viewBox="0 0 24 24">
						<circle cx="11" cy="11" r="7"></circle>
						<path d="m20 20-4-4"></path></svg><input placeholder="Buscar en Ushi..."
					aria-label="Buscar en Ushi" disabled
					title="Búsqueda pendiente de implementar"></label>
				<button class="bell" type="button" aria-label="Notificaciones"
					disabled title="Notificaciones pendientes de implementar">
					<svg viewBox="0 0 24 24">
						<path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 8h18c0-1-3-1-3-8M10 21h4"></path></svg>
					<span></span>
				</button>
				<div class="online">
					<span></span>78 tags online
				</div>
			</div>
		</header>
		<main>
			<div class="page-title">
				<div>
					<p class="eyebrow">Resumen de hoy</p>
					<h1>Panel de control</h1>
					<p>Estado general de Finca A Lagoa y de los dispositivos
						conectados.</p>
				</div>
				<a class="btn primary"
					href="${pageContext.request.contextPath}/animal?action=search">Ver
					animales</a>
			</div>
			<p class="prototype-note">Vista de demostración: métricas y
				alertas de ejemplo.</p>
			<section class="metric-grid">
				<article class="metric">
					<div>
						<span>Animales activos</span><i class=""></i>
					</div>
					<strong>86</strong>
					<p>+4 este mes</p>
				</article>
				<article class="metric">
					<div>
						<span>Tags conectados</span><i class=""></i>
					</div>
					<strong>78</strong>
					<p>91% del rebaño</p>
				</article>
				<article class="metric">
					<div>
						<span>Alertas abiertas</span><i class="warn"></i>
					</div>
					<strong>3</strong>
					<p>1 requiere atención</p>
				</article>
				<article class="metric">
					<div>
						<span>Salud óptima</span><i class=""></i>
					</div>
					<strong>94%</strong>
					<p>+2,4% esta semana</p>
				</article>
			</section>
			<section class="dashboard-grid">
				<article class="panel">
					<header>
						<div>
							<h2>Alertas recientes</h2>
							<p>Incidencias detectadas en las ultimas 24 horas</p>
						</div>
						<span class="badge amber">3 abiertas</span>
					</header>
					<div class="alert-list">
						<div>
							<span class="red"></span>
							<p>
								<strong>Batería baja</strong><small>TAG-008 -
									AN-041-2023</small>
							</p>
							<em>Hace 18 min</em>
						</div>
						<div>
							<span class="amber"></span>
							<p>
								<strong>Actividad fuera de rango</strong><small>TAG-001
									- AN-032-2022</small>
							</p>
							<em>Hace 42 min</em>
						</div>
						<div>
							<span class="blue"></span>
							<p>
								<strong>Firmware disponible</strong><small>TAG-003 -
									AN-025-2021</small>
							</p>
							<em>Hace 2 h</em>
						</div>
					</div>
				</article>
				<article class="panel health">
					<h2>Parámetros de salud</h2>
					<p>Lecturas de las ultimas 24 horas</p>
					<div class="donut">
						<div>
							<strong>1.284</strong><span>lecturas</span>
						</div>
					</div>
					<div class="legend">
						<span>Normal <b>76%</b></span><span>Revisar <b>15%</b></span><span>Sin
							datos <b>9%</b>
						</span>
					</div>
				</article>
			</section>
		</main>
		<footer>Ushi © 2026 - Monitorización ganadera en tiempo real</footer>
	</div>


</body>
</html>
