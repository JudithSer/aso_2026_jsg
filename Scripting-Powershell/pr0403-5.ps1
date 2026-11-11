# 21. Detección de usuario Admin

$u = "ADM_Lopez"
$u.StartsWith("ADM")

# 22. Formato de nombre propio

$nombre = "JAVIER"
$nombre.Substring(0,1).ToUpper() + $nombre.Substring(1).ToLower()

# 23. Limpieza de Distinguished Name (AD)

$dn = "CN=Beatriz,OU=Ventas,DC=dominio,DC=local"
$dn.Split(",")[0].Replace("CN=", "")
# $dn.Split(",")[0].Split("=")[1]

# 24. Generador de iniciales

$n = "Fernando"
$a = "Alonso"

$n.Substring(0,1).ToUpper() + "." + $a.Substring(0,1).ToUpper() + "."

# 25. Inversión de fecha

$euDate = "31-12-2023"
$partes = $euDate.Split("-")
$partes[2] + $partes[1] + $partes[0]