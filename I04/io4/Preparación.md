# Plantilla de Administración en PowerShell para el examen

Guía de referencia rápida y plantilla modular de PowerShell para administración de sistemas y saneamiento de datos. Diseñada con un menú interactivo recurrente, pipeline de objetos, filtrado dinámico, manejo de excepciones con `try/catch` y exportación a formatos estructurados (CSV y HTML).

```powershell
<#
.SYNOPSIS
    Script integral de administración del sistema, auditoría de procesos y saneamiento de datos.
#>

# ------------------------------------------------------------------------------
# 1. Bucle principal del menú interactivo (do - while)
# Mantiene la ejecución activa hasta que el valor introducido en $opcion sea "5".
# ------------------------------------------------------------------------------
do {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "         CONSOLA DE GESTIÓN DEL SISTEMA   " -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "1. Monitorizar procesos (Top CPU)"
    Write-Host "2. Buscar proceso por coincidencia de nombre"
    Write-Host "3. Detener proceso por ID con control de error"
    Write-Host "4. Parsear registros/inventario y exportar a CSV"
    Write-Host "5. Salir"
    Write-Host "------------------------------------------"
    
    # Solicitamos la opción al usuario por consola
    $opcion = Read-Host "Seleccione una opción (1-5)"

    # Evaluamos la opción elegida mediante switch
    switch ($opcion) {
        "1" {
            Write-Host "`n--- TOP 5 PROCESOS CON MAYOR CONSUMO DE CPU ---" -ForegroundColor Yellow
            
            # Obtenemos procesos, los ordenamos descendentemente por la propiedad CPU,
            # seleccionamos solo los 5 primeros y proyectamos las columnas deseadas.
            Get-Process | 
                Sort-Object -Property CPU -Descending | 
                Select-Object -First 5 -Property Name, Id, CPU | 
                Format-Table -AutoSize
        }

        "2" {
            $busqueda = Read-Host "`nIntroduzca el nombre (o parte del nombre) del proceso"
            
            # Filtramos con Where-Object usando el operador -like junto con comodines (*)
            $resultados = Get-Process | Where-Object { $_.Name -like "*$busqueda*" }

            # Comprobamos si la variable contiene algún resultado
            if ($resultados) {
                Write-Host "`nProcesos coincidentes:" -ForegroundColor Green
                $resultados | Select-Object -Property Name, Id, CPU, WS | Format-Table -AutoSize
            } else {
                Write-Host "No se encontraron procesos activos cuyo nombre contenga '$busqueda'." -ForegroundColor Red
            }
        }

        "3" {
            $pidMatar = Read-Host "`nIntroduzca el ID (PID) del proceso a finalizar"
            
            # Usamos un bloque try/catch para controlar errores si el PID no existe.
            # Es imprescindible usar -ErrorAction Stop para que el fallo active el bloque catch.
            try {
                # Comprobamos primero si el proceso existe
                $procesoEncontrado = Get-Process -Id $pidMatar -ErrorAction Stop
                
                # Forzamos la detención inmediata del proceso sin pedir confirmación
                Stop-Process -Id $pidMatar -Force -ErrorAction Stop
                Write-Host "Éxito: Proceso '$($procesoEncontrado.Name)' (PID: $pidMatar) terminado." -ForegroundColor Green
            }
            catch {
                Write-Host "Error: No se pudo encontrar o finalizar ningún proceso con PID: $pidMatar." -ForegroundColor Red
            }
        }

        "4" {
            Write-Host "`n--- PARSEO DE REGISTROS Y EXPORTACIÓN A CSV ---" -ForegroundColor Yellow
            
            # 1. Definimos una entrada de datos crudos (Here-String o Array)
            $datosCrudos = @"
SRV_WEB_01;192.168.1.10;00-14-22-01-23-45;ACTIVO;45
SRV_DB_02;10.0.0.5;00-14-22-AA-BB-CC;RETIRED;120
SRV_PROXY_03;172.16.0.2;00-14-22-99-88-77;ACTIVO;8
"@ -split "`n"

            # 2. Creamos un array colector vacío para guardar los objetos normalizados
            $listaObjetos = @()

            # 3. Iteramos línea por línea sobre el conjunto de datos
            foreach ($linea in $datosCrudos) {
                # Limpiamos espacios extremos con .Trim()
                $lineaLimpia = $linea.Trim()

                # Ignoramos líneas vacías
                if (-not [string]::IsNullOrWhiteSpace($lineaLimpia)) {
                    # Dividimos la línea en campos usando el delimitador ';'
                    $campos = $lineaLimpia.Split(";")

                    $nombreRaw = $campos[0].Trim()
                    $ipRaw     = $campos[1].Trim()
                    $macRaw    = $campos[2].Trim()
                    $estadoRaw = $campos[3].Trim()
                    $idRaw     = $campos[4].Trim()

                    # 4. Filtro: omitimos los equipos marcados como RETIRED
                    if ($estadoRaw -ne "RETIRED") {
                        
                        # 5. Normalización y limpieza:
                        # - Nombre a minúsculas y sustituyendo guiones bajos por guiones normales
                        $nombreFinal = $nombreRaw.ToLower().Replace("_", "-")
                        
                        # - MAC a mayúsculas y sustituyendo guiones por dos puntos
                        $macFinal = $macRaw.ToUpper().Replace("-", ":")
                        
                        # - Relleno numérico (Padding) a 6 dígitos con ceros a la izquierda
                        $idFinal = $idRaw.PadLeft(6, "0")

                        # 6. Construcción del objeto estructurado con [PSCustomObject]
                        $nodo = [PSCustomObject]@{
                            ID          = $idFinal
                            Dispositivo = $nombreFinal
                            DireccionIP = $ipRaw
                            MAC         = $macFinal
                            Estado      = $estadoRaw
                        }

                        # Añadimos el objeto procesado a la colección
                        $listaObjetos += $nodo
                    }
                }
            }

            # 7. Mostramos la tabla limpia resultante en consola
            $listaObjetos | Format-Table -AutoSize

            # 8. Exportamos la colección a un fichero CSV UTF-8 sin información de tipos
            $rutaSalida = "$HOME\Desktop\inventario_limpio.csv"
            $listaObjetos | Export-Csv -Path $rutaSalida -NoTypeInformation -Encoding UTF8
            Write-Host "Archivo CSV generado correctamente en: $rutaSalida" -ForegroundColor Green
        }

        "5" {
            Write-Host "`nCerrando la consola de administración..." -ForegroundColor Yellow
        }

        default {
            Write-Host "`nOpción no válida. Por favor, introduzca un valor entre 1 y 5." -ForegroundColor Red
        }
    }

} while ($opcion -ne "5")
```

---

## Chuleta de sintaxis y métodos rápidos de PowerShell

### 1. Manipulación de cadenas (.NET Strings)

* `.Trim()`: Elimina espacios en blanco al inicio y al final.
* `.ToLower()` / `.ToUpper()`: Convierte a minúsculas o mayúsculas.
* `.Replace("origen", "destino")`: Sustitución literal de caracteres.
* `-replace '\s+', ' '`: Sustitución mediante expresiones regulares.
* `.Split(";")`: Divide un texto por un carácter separador y genera un array.
* `.Substring(inicio, longitud)`: Extrae una subcadena a partir de un índice.
* `.PadLeft(longitud, "0")`: Rellena con caracteres a la izquierda hasta alcanzar la longitud especificada.

### 2. Operadores de comparación en PowerShell

* `-eq` (igual) / `-ne` (distinto).
* `-gt` (mayor) / `-ge` (mayor o igual) / `-lt` (menor) / `-le` (menor o igual).
* `-like "*texto*"`: Búsqueda con comodines (`*`, `?`).
* `-match "^patron$"`: Coincidencia mediante expresión regular (almacena grupos en `$Matches`).

### 3. Pipeline y cmdlets fundamentales

* `Get-Process | Sort-Object CPU -Descending | Select-Object -First 5`: Ordenación y selección de objetos.
* `Where-Object { $_.Propiedad -eq "Valor" }`: Filtrado con ScriptBlock.
* `ConvertTo-Html`: Transforma objetos en tablas formateadas para web.
* `Export-Csv -Path "archivo.csv" -NoTypeInformation -Encoding UTF8`: Guarda una colección de objetos como archivo CSV estándar.
