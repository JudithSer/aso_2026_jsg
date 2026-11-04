# 16. Obtener nombre de usuario desde email

$email = "pepe.garcia@empresa.com"
$email.Split("@")[0]

# 17. Obtener dominio desde email

$email = "pepe.garcia@empresa.com"
$email.Split("@")[1]

# 18. Obtener nombre de archivo de una ruta larga

$path = "C:\Users\Admin\Downloads\instaler.msi"
$path.Split("\")[-1]

# 19. Obtener letra de unidad

$path = "D:\Datos\Backups"
$path.Split("\")[0]

# 20. Separar CSV manual

$linea = "Juan;Marketing;Madrid"
$linea.Split(";")[1]