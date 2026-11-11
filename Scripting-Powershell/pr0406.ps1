$inventarioCrudo = @"
DEV-01 | MAC:00-1A-2B-3C-4D-5E | RAM:512MB | SN:a1b2 | STATUS:ACTIVE
switch_core_02 | MAC:001a.2b3c.4d5f | RAM:2GB | SN:X9Y8Z | STATUS:MAINTENANCE
router-edge-03 | MAC:00-1A-2B-3C-4D-60 | RAM:1024MB | SN:f4e3d2 | STATUS:ACTIVE
core_switch_04 | MAC:00:1a:2b:3c:4d:61 | RAM:4GB | SN:7m8n | STATUS:RETIRED
"@

# Separamos las líneas del inventario
$lineas = $inventarioCrudo.Split("`n")

#Write-Host "Numero de dispositivos:" $lineas.Count

# Creamos una colección vacía para almacenar los resultados
$resultados = @()

# Recorremos cada línea del inventario
foreach ($linea in $lineas) {
    $linea = $linea.trim()

    #write-host "Procesando linea: $linea"

    # separamos los campos de la línea usando el delimitador "/|" porque estan divididas con | 

    $partes = $linea.Split('|')
    #Write-Host "Campo 0:" $partes[0]
    #Write-Host "Campo 1:" $partes[1]
    #Write-Host "Campo 2:" $partes[2]
    #Write-Host "Campo 3:" $partes[3]
    #Write-Host "Campo 4:" $partes[4]

    # cambiamos a minusculas
    $nombre = $partes[0].Trim().ToLower()
    #write-host "Nombre del dispositivo: $nombre"

    # cambiamos _ por - en el nombre del dispositivo
    $nombre = $nombre.Replace("_", "-")
    #write-host "Nombre del dispositivo modificado: $nombre"

    # obtenemos la MAC y la limpiamos de caracteres no deseados
    # primero elegimos la parte de la MAC y la pasamos a mayusculas, despues quitamos mac: de delante
    $mac = $partes[1].Trim().ToUpper().replace("MAC:", "")
    #write-host "MAC del dispositivo: $mac"
    # ahora quitamos todos los signos que separan, para tener solo la mac, y poder separarla por caracteres
    $mac = $mac.Replace("-", "").Replace(".", "").Replace(":", "")
    #write-host "MAC del dispositivo modificada: $mac"
    # ahora vamos a separar cada dos caracteres con dos puntos
    $mac = $mac.Substring(0, 2) + ":" + $mac.Substring(2, 2) + ":" + $mac.Substring(4, 2) + ":" + $mac.Substring(6, 2) + ":" + $mac.Substring(8, 2) + ":" + $mac.Substring(10, 2)
    #write-host "MAC del dispositivo final: $mac"

    #ahora vamos a la ram y quitamos ram: de delante
    $ram = $partes[2].Trim().replace("RAM:", "")
    #write-host "RAM del dispositivo: $ram"

    #ahora hacemos lo mismo con el serial number y quitamos sn: de delante
    $sn = $partes[3].Trim().replace("SN:", "").ToUpper()
    #write-host "Serial number del dispositivo: $sn"

    #ahora intentamos que sn tenga 6 caracterer, o sea 0 por delante de lo que no lleguen
    $sn = $sn.PadLeft(6, "0")
    #write-host "Serial number del dispositivo modificado: $sn"

    #ahora quitamos status
    $status = $partes[4].Trim().replace("STATUS:", "")
    #write-host "Status del dispositivo: $status"

    #ahora retiramos cualquiera con status retired
    if ($status -eq "RETIRED") {
    continue
    }

    #creamos un objeto con los datos del dispositivo
    $objeto = [PSCustomObject]@{
        Device = $nombre
        MAC = $mac
        RAM = $ram
        SerialNumber = $sn
        Status = $status
    }

    #guardamos el objeto 
    $resultados += $objeto
}

# Exportamos la colección de objetos a CSV
$resultados | Export-Csv -Append -NoTypeInformation "resultados.csv"