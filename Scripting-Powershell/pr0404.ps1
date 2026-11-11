# 1. Datos de entrada (Here-String)
$logCrudo = @"
[INFO] ID:8842 :: 2023/11/01_10:00 :: User:admin_01 :: Action:Login_Success
[ERROR] ID:9921 :: 2023/11/01_10:05 :: User:guest_user :: Action:Auth_Fail (Pass)
[WARN] ID:8843 :: 2023-11-01 10:15 :: User:dev_team :: Action:Upload_Limit_Exceeded
[CRITICAL] ID:1001 :: 01-11-2023_10:20 :: User:ROOT :: Action:Service_Stop
"@

write-host "Comenzamos"

$lineas = $logCrudo.split("`n")

$reporte = foreach ($linea in $lineas) {
    # Ignorar líneas en blanco si las hubiera
    write-host "Procesando linea " $linea
    if ($linea -eq "") { continue }

    if ($linea.startsWith("[INFO]")) { continue }

    $partes = $linea -split "::"
    $campo_id = $partes[0]
    $campo_fecha = $partes[1]
    $campo_user = $partes[2]
    $campo_action = $partes[3]

    # Primer campo
    Write-Host "Procesando: " $campo_id
    $severity = $campo_id.split(']')[0].substring(1)
    $eventId = $campo_id.split(':')[1].trim()
    Write-Host "severity: " $severity
    write-host "EventID" $eventId
    
    # Fechas con formatos mixtos
    Write-Host "Procesando: " $campo_fecha
    $fechaLimpia = $campo_fecha.replace('/', '-').replace('_', ' ').trim()
    
    $fecha_completa = $fechaLimpia.split(" ")[0]
    $hora_completa = $fechaLimpia.split(" ")[1]

    $hora = $hora_completa.split(':')[0]
    $minuto = $hora_completa.split(':')[1]
    $listaFecha = $fecha_completa.split("-")
    if ($fecha_completa[2] -eq '-') {   # Está primero el día
        $dia = $listaFecha[0]
        $mes = $listaFecha[1]
        $anio = $listaFecha[2]
    } else {
        $anio = $listaFecha[0]
        $mes = $listaFecha[1]
        $dia = $listaFecha[2]
    }
    $fechaLimpia = Get-Date -Year $anio -Month $mes -Day $dia -Hour $hora -Minute $minuto

    # Campo de usuario
    Write-Host "Procesando: " $campo_user
    $user = $campo_user.split(':')[1].Trim().ToLower()
    if ($user -eq "root") {
        $user = "administrator"
    }

    # Campo Acción
    Write-Host "Procesando: " $campo_action
    $action = $campo_action.split(':')[1].Trim()

    # Guardamos los datos en un objeto personalizado para poder exportarlos luego a CSV
    [PSCustomObject]@{
        TimeStamp = $fechaLimpia
        Severity  = $severity
        User      = $user
        EventID   = $eventId
        Action    = $action
    }
}

# 4. Exportamos la colección de objetos a CSV 
$reporte | Export-Csv -Path "reporte_seguridad.csv" -Encoding UTF8 -NoTypeInformation