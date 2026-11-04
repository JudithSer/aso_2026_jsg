# 1. Normalizar a mayúsculas

$sys = "Windows Server"
$sys.ToUpper()

# 2. Normalizar a minúsculas

$user = "ADMINISTRATOR"
$user.ToLower()

# 3. Limpieza de espacios extremos

$ip = " 192.168.1.10 "
$ip.Trim()

# 4. Eliminación total de espacios

$mac = "00 AA 11 BB 22 CC"
$mac.Replace(" ", "")

# 5. Longitud de la cadena

$pass = "P@ssw0rd123"
$pass.Length

