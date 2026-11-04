# 1. Comprobando el tipado dinámico

$recurso = 8080
Write-Host "Tipo de dato: $($recurso.GetType().Name)"

$recurso = "Puerto HTTP"
Write-Host "Tipo de dato: $($recurso.GetType().Name)"

# 2. Forzando el tipado estático

[int]$maxConexiones = 100
[bool]$firewallActivo = $true

Write-Host "Maximo de conexiones: $maxConexiones"
Write-Host "Firewall activo: $firewallActivo"

# 3. Números grandes y precisión financiera

[long]$tamanoBackup = 2199023255552L

[decimal]$costeLicencia = 149.95d
[decimal]$iva = 31.49d

$totalFactura = $costeLicencia + $iva

Write-Host "Tamano del backup: $tamanoBackup bytes"
Write-Host "Coste de la licencia: $costeLicencia euros"
Write-Host "IVA: $iva euros"
Write-Host "Total de la factura: $totalFactura euros"

# 4. Cálculo de tiempos de ejecución (DateTime y TimeSpan)

# Guardamos la fecha y hora actual
$fechaActual = Get-Date

# Calculamos cuándo caducará la contraseña (45 días)
$fechaCaducidad = $fechaActual.AddDays(45)

Write-Host "Ano actual: $($fechaActual.Year)"
Write-Host "La contrasena caducara el: $fechaCaducidad"

# Medimos el tiempo de ejecución de una tarea
$inicio = Get-Date

Start-Sleep -Seconds 3

$fin = Get-Date

[TimeSpan]$tiempoTotal = $fin - $inicio

Write-Host "Tiempo total transcurrido: $($tiempoTotal.TotalSeconds) segundos"
