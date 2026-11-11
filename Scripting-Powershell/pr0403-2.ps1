# 6. Cambio de separadores de fecha

$fecha = "2023.10.05"
$fecha.Replace(".", "-")

# 7. Actualización de dominio

$web = "www.miempresa.es"
$web.Replace(".es", ".com")

# 8. Censura de datos !!!!!

$tarjeta = "1234-5678-9012-3456"
# $tarjeta.Replace("3456", "XXXX")
$tarjeta.Substring(0, 15) + "XXXX"


# 9. Cambio de barra de rutas

$rutaLinux = "/home/usuario/docs"
$rutaLinux.Replace("/", "\")

# 10. Doble reemplazo

$valor = "(Software)"
$valor.Replace("(", "").Replace(")", "")