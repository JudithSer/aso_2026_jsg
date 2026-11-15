# Plantilla en Bash para el examen

```bash
#!/bin/bash
# ==============================================================================
# SCRIPT DE ADMINISTRACIÓN Y MANTENIMIENTO DEL SISTEMA (BASH)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Comprobación de privilegios de ejecución (Root)
# Comprobamos si el usuario actual es root mediante el identificador EUID (debe ser 0).
# Si no lo es, enviamos un mensaje de error a stderr (>&2) y salimos con código 1.
# ------------------------------------------------------------------------------
if [ "$EUID" -ne 0 ] && [ "$USER" != "root" ]; then
    echo "Error crítico: Este script debe ser ejecutado obligatoriamente por root." >&2
    exit 1
fi

# ------------------------------------------------------------------------------
# 2. Bucle principal del menú interactivo (while true)
# Mantiene la ejecución activa hasta que el usuario introduzca expresamente la
# opción de salida (opción 5 con exit 0).
# ------------------------------------------------------------------------------
while true; do
    echo ""
    echo "=========================================="
    echo "         MENÚ DE GESTIÓN DEL SISTEMA      "
    echo "=========================================="
    echo "1. Estado y alertas de espacio en disco"
    echo "2. Localizar ficheros por tamaño"
    echo "3. Gestión y limpieza de usuario"
    echo "4. Crear copia de seguridad comprimida"
    echo "5. Salir"
    echo "------------------------------------------"
    
    # Leemos la opción elegida por teclado
    read -p "Seleccione una opción (1-5): " opcion

    # Evaluamos la opción seleccionada usando la estructura condicional case
    case $opcion in
        1)
            echo ""
            echo "--- ESTADO DE LAS PARTICIONES ---"
            
            # Mostramos el espacio libre y ocupado en formato legible (Megas/Gigas) con df -h
            df -h
            echo ""

            # Analizamos partición a partición omitiendo la cabecera con tail -n +2
            df -h | tail -n +2 | while read -r fs size used avail pcent mountpoint; do
                # Extraemos el valor numérico quitando el carácter '%' al final
                uso_num=${pcent%\%}

                # Comprobamos con test numérico (-gt) si supera el umbral crítico del 90%
                if [ -n "$uso_num" ] && [ "$uso_num" -gt 90 ]; then
                    echo "[ALERTA] La partición '$mountpoint' ($fs) está al $uso_num% de capacidad."
                fi
            done
            ;;

        2)
            echo ""
            echo "--- BÚSQUEDA DE FICHEROS POR TAMAÑO ---"
            
            # Solicitamos la ruta del directorio que queremos examinar
            read -p "Ruta del directorio a escanear: " dir_buscar
            
            # Validamos con test -d si el directorio realmente existe y es accesible
            if [ ! -d "$dir_buscar" ]; then
                echo "Error: La ruta '$dir_buscar' no existe o no es un directorio válido."
            else
                read -p "Tamaño mínimo en Megabytes (ej. 100): " tam_mb
                
                # Comprobamos que no se haya dejado en blanco con test -z
                if [ -z "$tam_mb" ]; then
                    echo "Error: Debe indicar un valor numérico para el tamaño."
                else
                    echo "Buscando ficheros mayores de ${tam_mb}MB en '$dir_buscar'..."
                    # find busca solo ficheros regulares (-type f) mayores a los megas indicados (-size +XM)
                    find "$dir_buscar" -type f -size +"$tam_mb"M -exec ls -lh {} + 2>/dev/null
                fi
            fi
            ;;

        3)
            echo ""
            echo "--- GESTIÓN Y LIMPIEZA DE USUARIO ---"
            read -p "Nombre del usuario a consultar: " usuario_objetivo
            
            # Comprobamos con grep en modo silencioso (-q) si el usuario existe en /etc/passwd
            if grep -q "^$usuario_objetivo:" /etc/passwd; then
                echo "Usuario verificado en el sistema."

                # Contamos cuántos ficheros temporales pertenecen a ese usuario en /tmp
                total_ficheros=$(find /tmp -user "$usuario_objetivo" -type f 2>/dev/null | wc -l)
                echo "Ficheros encontrados en /tmp: $total_ficheros"

                if [ "$total_ficheros" -gt 0 ]; then
                    # Eliminamos los ficheros temporales del usuario usando la acción -delete de find
                    find /tmp -user "$usuario_objetivo" -type f -delete 2>/dev/null
                    
                    # Registramos la operación en un log del sistema con marca temporal exacta
                    echo "$(date '+%Y-%m-%d %H:%M:%S') - Limpieza de $total_ficheros ficheros del usuario $usuario_objetivo" >> /var/log/limpieza_scripts.log
                    echo "Limpieza completada y registrada en el archivo de log."
                else
                    echo "El usuario '$usuario_objetivo' no tiene ficheros temporales en /tmp."
                fi
            else
                echo "Error: El usuario '$usuario_objetivo' no existe en /etc/passwd."
            fi
            ;;

        4)
            echo ""
            echo "--- COPIA DE SEGURIDAD AUTOMÁTICA ---"
            
            # Generamos la fecha actual en formato YYYYMMDD para nombrar el archivo de forma única
            fecha_str=$(date +%Y%m%d)
            archivo_tar="/root/backup_sistema_${fecha_str}.tar.gz"

            # Directorios esenciales a respaldar (configuraciones críticas de red y acceso remoto)
            rutas_copia="/etc/netplan /etc/ssh"

            echo "Creando archivo comprimido en: $archivo_tar..."
            # tar empaqueta (-c), comprime con gzip (-z) y genera el archivo destino (-f)
            tar -czf "$archivo_tar" $rutas_copia 2>/dev/null

            # Comprobamos el código de salida ($?) de tar para verificar si se ejecutó con éxito
            if [ $? -eq 0 ]; then
                echo "Copia de seguridad completada con éxito en '$archivo_tar'."
            else
                echo "Hubo advertencias o errores al empaquetar los ficheros."
            fi
            ;;

        5)
            echo "Cerrando el script de administración. ¡Hasta pronto!"
            # Salimos del programa con código de retorno exitoso 0
            exit 0
            ;;

        *)
            # Control de opción no contemplada en el menú
            echo "Opción no reconocida. Debe introducir un número entre el 1 y el 5."
            ;;
    esac
done
```

---

## Chuleta de sintaxis y patrones rápidos de Bash

### 1. Variables especiales

* `$0`: Nombre del script.
* `$1`, `$2`, ..., `${10}`: Argumentos recibidos por línea de comandos.
* `$#`: Número total de argumentos pasados.
* `$@`: Lista de argumentos separados e individualizados (usar siempre con comillas: `"$@"`).
* `$*`: Todos los argumentos concatenados en una única cadena (`"$1 $2 $3..."`).
* `$?`: Código de retorno del último comando (`0` = éxito, cualquier otro número = error).
* `$$`: PID del proceso actual.

### 2. Comprobaciones de archivos y directorios con `test` o `[ ]`

* `[ -d "$ruta" ]`: Comprueba si la ruta existe y es un **directorio**.
* `[ -f "$ruta" ]`: Comprueba si la ruta existe y es un **fichero regular**.
* `[ -s "$ruta" ]`: Comprueba si el fichero existe y **su tamaño es mayor de 0 bytes**.
* `[ -r "$ruta" ]` / `[ -w "$ruta" ]` / `[ -x "$ruta" ]`: Comprueba permisos de **lectura**, **escritura** o **ejecución**.
* `[ -z "$cadena" ]`: Comprueba si una cadena está **vacía**.
* `[ -n "$cadena" ]`: Comprueba si una cadena **no está vacía**.

### 3. Comparaciones numéricas

* `-eq`: Igual a (`==`).
* `-ne`: Distinto de (`!=`).
* `-gt`: Mayor estrictamente (`>`).
* `-ge`: Mayor o igual (`>=`).
* `-lt`: Menor estrictamente (`<`).
* `-le`: Menor o igual (`<=`).

### 4. Lectura de ficheros línea por línea

```bash
while IFS= read -r linea; do
    echo "Línea: $linea"
done < "/ruta/al/fichero.txt"
```
