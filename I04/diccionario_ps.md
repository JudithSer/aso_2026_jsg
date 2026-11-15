# Diccionario de PowerShell – UT04

Prácticas incluidas:

- PR0401: Canalización, objetos y formato en PowerShell.
- PR0402: Variables, tipos de datos y colecciones en PowerShell.
- PR0403: Manipulación de cadenas.

---

## 1. Conceptos básicos y variables

Antes de trabajar con comandos avanzados, hay que entender cómo funciona PowerShell.

## 1.1. Variables

Una variable es un espacio donde guardamos información para utilizarla posteriormente.

En PowerShell, todas las variables empiezan por `$`.

```powershell
$nombre = "Javier"
$edad = 25
```

- `$nombre` almacena texto.
- `$edad` almacena un número.

**Cómo se usa:** asignamos un valor con `=` y podemos utilizarlo escribiendo el nombre de la variable.

```powershell
Write-Host $nombre
```

## 1.2. Tipado dinámico

PowerShell permite cambiar el tipo de dato que almacena una variable.

```powershell
$recurso = 8080
$recurso = "Puerto HTTP"
```

Primero almacena un número y después una cadena de texto.

Para conocer el tipo de una variable:

```powershell
$recurso.GetType().Name
```

Tipos habituales:

| Tipo | Qué almacena | Ejemplo |
| --- | --- | --- |
| `String` | Texto | `"Hola"` |
| `Int32` | Enteros | `100` |
| `Int64` | Enteros grandes | `2199023255552L` |
| `Boolean` | Verdadero o falso | `$true` |
| `Decimal` | Números decimales | `149.95d` |
| `DateTime` | Fechas y horas | `Get-Date` |

## 1.3. Tipado estático

Consiste en indicar expresamente qué tipo de dato debe almacenar una variable.

```powershell
[int]$maxConexiones = 100
[bool]$firewallActivo = $true
```

Si intentamos introducir texto que no puede convertirse en número:

```powershell
$maxConexiones = "Cien"
```

PowerShell devuelve un error de conversión.

**Recuerda:**

- Tipado dinámico: PowerShell determina el tipo según el valor.
- Tipado estático: nosotros indicamos el tipo mediante `[tipo]`.

## 1.4. Mostrar información: Write-Host

Sirve para mostrar mensajes directamente por pantalla.

```powershell
$nombre = "Javier"
Write-Host "Hola $nombre"
```

Resultado:

```text
Hola Javier
```

Es especialmente útil para mostrar resultados y mensajes durante la ejecución de scripts.

---

## 2. Tipos de datos y operaciones básicas

## 2.1. Obtener la longitud: `.Length`

Devuelve el número de caracteres que tiene una cadena o elementos que tiene un array.

```powershell
$pass = "P@ssw0rd123"
$pass.Length
```

Resultado: `11`

## 2.2. Obtener el tipo: `.GetType()`

Devuelve información sobre el tipo de dato de un objeto.

```powershell
$recurso.GetType().Name
```

Por ejemplo, puede devolver `String`, `Int32` o `Boolean`.

## 2.3. Operaciones matemáticas

PowerShell permite realizar operaciones matemáticas habituales.

| Operador | Operación | Ejemplo |
| --- | --- |
| `+` | Suma | `$a + $b` |
| `-` | Resta | `$a - $b` |
| `*` | Multiplicación | `$a * $b` |
| `/` | División | `$a / $b` |
| `%` | Módulo (resto) | `$a % $b` |

Ejemplo:

```powershell
$memoriaLibreMB = 3540
$memoriaTotalMB = 16384

$porcentaje = ($memoriaLibreMB / $memoriaTotalMB) * 100
```

## 2.4. Clase `[Math]`

Sirve para realizar operaciones matemáticas adicionales.

| Método | Función |
| --- | --- |
| `[Math]::Round()` | Redondea al valor más cercano |
| `[Math]::Ceiling()` | Redondea hacia arriba |
| `[Math]::Floor()` | Redondea hacia abajo |

Ejemplo:

```powershell
[Math]::Round($porcentaje)
[Math]::Ceiling($porcentaje)
[Math]::Floor($porcentaje)
```

**Importante:** `::` se utiliza para acceder a métodos estáticos de una clase, como `[Math]`.

## 2.5. Fechas: `DateTime`

Permite trabajar con fechas y horas.

```powershell
$fechaActual = Get-Date
```

Propiedades y métodos importantes:

| Elemento | Función |
| --- | --- |
| `.Year` | Obtiene el año |
| `.Month` | Obtiene el mes |
| `.Day` | Obtiene el día |
| `.AddDays(45)` | Suma 45 días |
| `.AddMonths(1)` | Suma un mes |

Ejemplo:

```powershell
$fechaActual = Get-Date
$fechaCaducidad = $fechaActual.AddDays(45)

Write-Host $fechaCaducidad
```

## 2.6. Medición de tiempo: `TimeSpan`

Representa una duración o intervalo de tiempo.

```powershell
$inicio = Get-Date

Start-Sleep -Seconds 3

$fin = Get-Date

[TimeSpan]$tiempoTotal = $fin - $inicio
```

Para mostrar la duración:

```powershell
$tiempoTotal.TotalSeconds
```

**Diferencia importante:**

- `DateTime`: representa una fecha y hora concreta.
- `TimeSpan`: representa cuánto tiempo ha pasado entre dos fechas.

---

## 3. Manipulación de cadenas de texto (String)

Una cadena (`String`) es cualquier dato de texto. PowerShell incorpora métodos para modificarla, limpiarla, buscar información o extraer partes.

Los métodos se escriben después de la variable utilizando un punto (`.`).

## 3.1. Convertir mayúsculas y minúsculas

| Método | Función |
| --- | --- |
| `.ToUpper()` | Convierte todo a mayúsculas |
| `.ToLower()` | Convierte todo a minúsculas |

Ejemplo:

```powershell
$nombre = "Javier"

$nombre.ToUpper()
$nombre.ToLower()
```

Resultados: `JAVIER` y `javier`.

## 3.2. Eliminar espacios: `.Trim()`

Elimina los espacios que hay al principio y al final de una cadena.

```powershell
$ip = " 192.168.1.10 "
$ip.Trim()
```

Resultado: `192.168.1.10`

Variantes:

- `.Trim()`: elimina espacios de ambos extremos.
- `.TrimStart()`: elimina espacios iniciales.
- `.TrimEnd()`: elimina espacios finales.

## 3.3. Reemplazar texto: `.Replace()`

Permite sustituir una parte de una cadena por otra.

Su estructura es:

```powershell
$variable.Replace("texto antiguo", "texto nuevo")
```

Ejemplos:

```powershell
$fecha = "2023.10.05"
$fecha.Replace(".", "-")
```

Resultado: `2023-10-05`

También podemos eliminar texto utilizando una cadena vacía:

```powershell
$mac = "00 AA 11 BB 22 CC"
$mac.Replace(" ", "")
```

Resultado: `00AA11BB22CC`

Podemos encadenar varios reemplazos:

```powershell
$valor = "(Software)"
$valor.Replace("(", "").Replace(")", "")
```

Resultado: `Software`

## 3.4. Extraer caracteres: `.Substring()`

Permite obtener una parte concreta de una cadena.

Tiene dos formas habituales:

```powershell
$variable.Substring(posicionInicial, cantidad)
```

O bien:

```powershell
$variable.Substring(posicionInicial)
```

Ejemplos:

```powershell
$codigo = "2024-FACTURA-SEP"

$codigo.Substring(0, 4)
```

Resultado: `2024`

Otro ejemplo:

```powershell
$idEmpleado = "E55421"
$idEmpleado.Substring(1)
```

Resultado: `55421`

**Importante:** las posiciones empiezan en cero.

| Posición | 0 | 1 | 2 | 3 | 4 |
|----------|---|---|---|---|---|
| Texto    | H | O | L | A | ! |

## 3.5. Rellenar cadenas: `.PadLeft()` y `.PadRight()`

Sirven para añadir caracteres hasta alcanzar una longitud determinada.

```powershell
$numero = "7"
$numero.PadLeft(3, "0")
```

Resultado: `007`

- `.PadLeft()`: añade caracteres por la izquierda.
- `.PadRight()`: añade caracteres por la derecha.

## 3.6. Comprobar el inicio o final: `.StartsWith()` y `.EndsWith()`

Devuelven un resultado booleano (`True` o `False`).

```powershell
$u = "ADM_Lopez"

$u.StartsWith("ADM")
```

Resultado: `True`

También podemos comprobar cómo termina una cadena:

```powershell
$web = "www.miempresa.com"
$web.EndsWith(".com")
```

Resultado: `True`

## 3.7. Dividir cadenas: `.Split()`

Divide una cadena en diferentes partes utilizando un separador.

```powershell
$email = "pepe.garcia@empresa.com"

$email.Split("@")
```

Resultado: genera dos elementos:

- `pepe.garcia`
- `empresa.com`

Podemos seleccionar uno directamente:

```powershell
$email.Split("@")[0]
$email.Split("@")[1]
```

Otros ejemplos:

```powershell
$linea = "Juan;Marketing;Madrid"

$linea.Split(";")[1]
```

Resultado: `Marketing`

## 3.8. Índices de arrays y cadenas

Cuando dividimos una cadena con `.Split()`, obtenemos un array.

Los elementos se seleccionan mediante corchetes:

| Sintaxis | Significado |
| --- | --- |
| `[0]` | Primer elemento |
| `[1]` | Segundo elemento |
| `[2]` | Tercer elemento |
| `[-1]` | Último elemento |

Ejemplo:

```powershell
$path = "C:\Users\Admin\Downloads\instaler.msi"

$path.Split("\")[-1]
```

Resultado: `instaler.msi`

## 3.9. Expresiones regulares y operadores de búsqueda

Estos operadores permiten comprobar patrones dentro de cadenas.

| Operador | Función |
| --- | --- |
| `-like` | Busca coincidencias mediante comodines |
| `-match` | Comprueba si coincide con una expresión regular |
| `-replace` | Sustituye coincidencias mediante expresiones regulares |

**Comodines habituales:**

- `*`: representa cualquier cantidad de caracteres.
- `?`: representa un único carácter.

Ejemplo con `-like`:

```powershell
$codigoActivo = "SRV-2026-PROD-99"

$codigoActivo -like "SRV*"
```

Resultado: `True`, porque empieza por `SRV`.

Ejemplo con `-match`:

```powershell
$codigoActivo -match "\d"
```

Resultado: `True`, porque contiene números.

En expresiones regulares:

- `\d`: representa un dígito numérico.
- `\w`: representa un carácter alfanumérico o guion bajo.
- `\s`: representa un espacio en blanco.

Ejemplo con `-replace`:

```powershell
$codigoActivo -replace "\d", "X"
```

Resultado: `SRV-XXXX-PROD-XX`.

## 3.10. Comillas simples y dobles

En PowerShell no funcionan exactamente igual.

**Comillas simples:** muestran el texto literalmente, sin sustituir las variables.

```powershell
$servicio = "Spooler"

Write-Host 'El servicio es $servicio'
```

Resultado: `El servicio es $servicio`.

**Comillas dobles:** permiten sustituir las variables por su contenido.

```powershell
Write-Host "El servicio es $servicio"
```

Resultado: `El servicio es Spooler`.

## 3.11. Subexpresiones `$()`

Sirven para ejecutar una expresión dentro de una cadena de texto entre comillas dobles.

```powershell
$fecha = Get-Date

Write-Host "Hoy es el día $($fecha.Day)"
```

Así podemos acceder a propiedades o realizar operaciones dentro del mensaje.

## 3.12. Operador de formato `-f`

Permite construir cadenas utilizando posiciones numeradas.

```powershell
"El servidor {0} tiene la IP {1}" -f "SRV-WEB01", "10.0.1.15"
```

Resultado:

```text
El servidor SRV-WEB01 tiene la IP 10.0.1.15
```

- `{0}` corresponde al primer valor.
- `{1}` corresponde al segundo valor.
- `{2}` correspondería al tercero.

## 3.13. Here-Strings

Permiten almacenar textos largos o de varias líneas.

Se utilizan con `@"` y `"@`:

```powershell
$alertaCorreo = @"
Aviso técnico:
Servidor: $servicio
Fecha: $fecha
"@
```

A diferencia de las comillas simples, este formato permite expandir variables.

**Recuerda:** el cierre `"@` debe estar al principio de la línea.

---

## 4. Arrays y colecciones

Las colecciones permiten guardar varios elementos dentro de una misma variable.

## 4.1. Arrays estándar

Un array almacena varios elementos ordenados.

```powershell
$nodos = @("Nodo1", "Nodo2", "Nodo3", "Nodo4", "Nodo5")
```

Para acceder a sus elementos:

```powershell
$nodos[0]
$nodos[-1]
```

Resultados:

- Primer elemento: `Nodo1`.
- Último elemento: `Nodo5`.

Para saber cuántos elementos contiene:

```powershell
$nodos.Count
```

Resultado: `5`.

## 4.2. Rangos o Slicing

Permite seleccionar varios elementos consecutivos de un array.

```powershell
$subRed = $nodos[0..2]
```

Resultado:

```text
Nodo1
Nodo2
Nodo3
```

`0..2` significa desde la posición 0 hasta la 2, ambas incluidas.

## 4.3. ArrayList

Es una colección dinámica que permite añadir y eliminar elementos.

A diferencia de un array estándar, puede cambiar de tamaño.

Crear una ArrayList:

```powershell
$colaImpresion = New-Object System.Collections.ArrayList
```

Añadir elementos:

```powershell
[void]$colaImpresion.Add("Factura.pdf")
[void]$colaImpresion.Add("Informe.docx")
[void]$colaImpresion.Add("Nomina.pdf")
```

El `[void]` sirve para silenciar el resultado que devuelve `.Add()`.

Métodos importantes:

| Método | Función |
| --- | --- |
| `.Add()` | Añade un elemento |
| `.Insert()` | Inserta un elemento en una posición |
| `.Remove()` | Elimina un elemento |
| `.Contains()` | Comprueba si existe un elemento |

Ejemplo:

```powershell
$colaImpresion.Insert(0, "Urgente.pdf")
$colaImpresion.Remove("Informe.docx")

$colaImpresion.Contains("Nomina.pdf")
```

Resultado: `True`, si sigue en la colección.

## 4.4. Listas genéricas `List[T]`

Son colecciones dinámicas que permiten establecer un tipo de dato concreto.

Por ejemplo, una lista que solamente admite cadenas de texto:

```powershell
$listaIPs = [System.Collections.Generic.List[string]]::new()
```

Añadir elementos:

```powershell
$listaIPs.Add("192.168.1.50")
$listaIPs.Add("10.0.0.1")
$listaIPs.Add("172.16.0.10")
```

Ordenar:

```powershell
$listaIPs.Sort()
```

La diferencia principal con ArrayList es que una lista genérica puede estar fuertemente tipada.

## 4.5. Recorrer colecciones con `foreach`

Permite ejecutar instrucciones para cada elemento de una colección.

```powershell
foreach ($elemento in $lista) {
    Write-Host $elemento
}
```

Se lee como: por cada elemento de la lista, muestra su contenido.

También podemos recorrer una colección con `ForEach-Object`:

```powershell
$listaIPs | ForEach-Object {
    Write-Host $_.Length
}
```

Aquí:

- `$_` representa el elemento actual que está pasando por la canalización.
- `.Length` muestra su número de caracteres.

**Diferencia:**

- `foreach`: estructura de bucle tradicional.
- `ForEach-Object`: cmdlet que procesa los objetos que recibe por la canalización.

---

## 5. Tablas Hash y objetos personalizados

Aquí empezamos a trabajar con estructuras que permiten almacenar información organizada mediante nombres y valores.

## 5.1. Tablas Hash (Hash Tables)

Una tabla Hash almacena información en parejas de **clave y valor**.

Es parecida a un diccionario: cada dato tiene un nombre que permite localizarlo.

Ejemplo:

```powershell
$fichaServidor = @{
    Hostname = "SRV-AD01"
    IP       = "192.168.1.10"
    RAM_GB   = 32
    Critico  = $true
}
```

Para consultar un valor:

```powershell
$fichaServidor.Hostname
$fichaServidor.IP
```

También podemos modificar valores:

```powershell
$fichaServidor.RAM_GB = 64
```

Añadir una clave:

```powershell
$fichaServidor.SO = "Windows Server 2022"
```

Eliminar una clave:

```powershell
$fichaServidor.Remove("Critico")
```

## 5.2. Recorrer una tabla Hash

Podemos utilizar `foreach` para recorrer todas sus claves.

```powershell
foreach ($clave in $fichaServidor.Keys) {
    Write-Host "$clave : $($fichaServidor[$clave])"
}
```

Elementos importantes:

- `.Keys`: obtiene todas las claves.
- `$fichaServidor[$clave]`: obtiene el valor asociado a una clave.

## 5.3. PSCustomObject

Permite crear objetos personalizados con propiedades propias.

```powershell
$servidor = [PSCustomObject]@{
    Hostname = "SRV-AD01"
    IP       = "192.168.1.10"
    RAM_GB   = 64
}
```

Es útil para representar información estructurada y trabajar con ella como si fuera un objeto de PowerShell.

## 5.4. Exportar información: `Export-Csv`

Permite guardar objetos en un fichero CSV, que puede abrirse con Excel y otras aplicaciones.

```powershell
$servidor | Export-Csv -Path "servidor.csv" -NoTypeInformation
```

Parámetros importantes:

| Parámetro | Función |
| --- | --- |
| `-Path` | Indica dónde guardar el archivo |
| `-NoTypeInformation` | Evita incluir información del tipo de objeto |

## 5.5. Splatting

Es una técnica que permite pasar varios parámetros a un comando utilizando una tabla Hash.

Por ejemplo:

```powershell
$parametrosCarpeta = @{
    Path     = "C:\Temp"
    Name     = "Logs_ASO"
    ItemType = "Directory"
}

New-Item @parametrosCarpeta
```

Normalmente escribiríamos:

```powershell
New-Item -Path "C:\Temp" -Name "Logs_ASO" -ItemType "Directory"
```

Con Splatting agrupamos los parámetros en una tabla Hash y utilizamos `@nombreVariable` para pasarlos al comando.

**Ojo con la diferencia:**

- `$variable`: accede a una variable.
- `@variable`: se utiliza para pasar una tabla Hash como conjunto de parámetros (*Splatting*).

---

## 6. Objetos y propiedades en PowerShell (PR0401)

Este bloque es especialmente importante porque PowerShell no trabaja solamente con texto: trabaja principalmente con **objetos**.

Un objeto contiene información organizada en propiedades y puede incluir métodos para realizar acciones.

Por ejemplo, un proceso de Windows puede tener:

- Nombre.
- Identificador.
- Memoria utilizada.
- Ruta del ejecutable.
- Estado.

## 6.1. Cmdlets

Los cmdlets son comandos propios de PowerShell.

Normalmente siguen la estructura:

```powershell
Verbo-Sustantivo
```

Ejemplos:

| Cmdlet | Función |
| --- | --- |
| `Get-Service` | Obtiene servicios |
| `Get-Process` | Obtiene procesos |
| `Get-LocalUser` | Obtiene usuarios locales |
| `Get-ChildItem` | Lista archivos y carpetas |
| `Get-Date` | Obtiene fecha y hora |
| `New-Item` | Crea archivos o carpetas |

Los verbos ayudan a entender qué hace el comando:

- `Get`: obtener.
- `Set`: modificar.
- `New`: crear.
- `Remove`: eliminar.
- `Start`: iniciar.
- `Stop`: detener.

## 6.2. Canalización `|`

La canalización permite enviar la salida de un comando directamente a otro.

El símbolo es:

```powershell
|
```

Ejemplo:

```powershell
Get-Service | Get-Member
```

Primero obtenemos los servicios y después enviamos los objetos obtenidos a `Get-Member`.

Es uno de los elementos más importantes de PowerShell.

## 6.3. Get-Member

Permite descubrir qué tipo de objeto devuelve un comando y qué propiedades y métodos tiene.

Ejemplo:

```powershell
Get-Service | Get-Member
```

Muestra información como:

- `TypeName`: tipo de objeto.
- `Properties`: propiedades.
- `Methods`: métodos.

**¿Para qué sirve?**

Cuando no sabemos qué información contiene un comando, utilizamos `Get-Member` para descubrirlo.

## 6.4. Propiedades y métodos

Es importante distinguirlos:

- **Propiedades:** información que contiene un objeto.
- **Métodos:** acciones que podemos realizar sobre un objeto.

Por ejemplo, un proceso puede tener la propiedad `Id` y métodos para finalizarlo.

Ejemplo:

```powershell
Get-Process | Get-Member
```

Algunas propiedades importantes de procesos:

| Propiedad | Información |
| --- | --- |
| `Name` | Nombre del proceso |
| `Id` | Identificador PID |
| `Path` | Ruta del ejecutable |
| `WS` | Memoria de trabajo |

En servicios podemos encontrar:

| Propiedad | Información |
| --- | --- |
| `Name` | Nombre del servicio |
| `Status` | Estado |
| `StartType` | Tipo de inicio |
| `DisplayName` | Nombre descriptivo |

## 6.5. Acceder directamente a una propiedad

Podemos consultar directamente una propiedad de un objeto.

Ejemplo:

```powershell
(Get-Service -Name wuauserv).Status
```

Esto obtiene el servicio Windows Update y muestra únicamente su estado.

La estructura es:

```powershell
(Comando).Propiedad
```

Los paréntesis hacen que primero se ejecute el comando y después se acceda a la propiedad del resultado.

## 6.6. Select-Object

Permite seleccionar qué propiedades queremos mostrar.

Ejemplo:

```powershell
Get-LocalUser | Select-Object Name, Enabled, LastLogon
```

En lugar de mostrar todas las propiedades de los usuarios, muestra únicamente las tres indicadas.

También podemos seleccionar elementos concretos:

```powershell
Get-Process | Select-Object -First 5
```

Esto muestra los primeros cinco procesos.

## 6.7. Select-Object `*`

El comodín `*` representa todos los elementos o propiedades, dependiendo del comando.

Ejemplo:

```powershell
Get-Process -Name explorer | Select-Object *
```

Muestra todas las propiedades disponibles del proceso `explorer`.

---

## 7. Ordenación, agrupación y estadísticas

Una vez sabemos obtener objetos y seleccionar sus propiedades, podemos organizarlos y analizarlos.

## 7.1. Sort-Object

Permite ordenar los objetos según una propiedad.

Ejemplo:

```powershell
Get-Process | Sort-Object WS
```

Ordena los procesos por memoria de trabajo de menor a mayor.

Para ordenar de mayor a menor:

```powershell
Get-Process | Sort-Object WS -Descending
```

Parámetros:

- `-Descending`: orden descendente.
- `-Ascending`: orden ascendente.

## 7.2. Group-Object

Agrupa objetos que tienen valores iguales en una propiedad.

Ejemplo:

```powershell
Get-Service | Group-Object StartType
```

Agrupa los servicios según su tipo de inicio.

Podemos utilizar varias propiedades:

```powershell
Get-LocalUser | Group-Object Enabled, PasswordRequired
```

Agrupa los usuarios según dos condiciones.

## 7.3. Measure-Object

Permite calcular estadísticas de una colección de objetos.

Por ejemplo, para analizar el tamaño de los archivos:

```powershell
Get-ChildItem "C:\Windows\System32" -File |
    Measure-Object Length -Minimum -Maximum -Average
```

Calcula:

| Parámetro | Función |
| --- | --- |
| `-Minimum` | Valor mínimo |
| `-Maximum` | Valor máximo |
| `-Average` | Promedio |
| `-Sum` | Suma |
| `-Count` | Cantidad de elementos |

Es muy útil para analizar archivos, memoria, tamaños y otros valores numéricos.

---

## 8. Filtrado de objetos: Where-Object

Este es otro de los conceptos fundamentales de PowerShell.

`Where-Object` permite filtrar objetos según una condición.

Por ejemplo, si tenemos 100 servicios, podemos mostrar solamente los que estén funcionando.

## 8.1. Sintaxis moderna

Es la sintaxis simplificada, sin llaves ni `$_`.

```powershell
Get-Service | Where-Object Status -eq Running
```

Muestra los servicios cuyo estado es `Running`.

## 8.2. Sintaxis clásica (ScriptBlock)

Utiliza llaves `{ }` y el símbolo `$_`.

```powershell
Get-Service | Where-Object { $_.Status -eq "Running" }
```

Aquí:

- `{ }`: delimitan el bloque de instrucciones.
- `$_`: representa el objeto actual que se está examinando.
- `.Status`: accede a la propiedad Status.
- `-eq`: compara si dos valores son iguales.

## 8.3. Operadores de comparación

Estos operadores son muy importantes y aparecen constantemente en los ejercicios.

| Operador | Significado |
| --- | --- |
| `-eq` | Igual a |
| `-ne` | Distinto de |
| `-gt` | Mayor que |
| `-ge` | Mayor o igual que |
| `-lt` | Menor que |
| `-le` | Menor o igual que |
| `-like` | Coincidencia con comodines |
| `-notlike` | No coincide con comodines |
| `-match` | Coincide con expresión regular |
| `-contains` | Comprueba si una colección contiene un elemento |

## 8.4. Filtrado con comodines

Podemos utilizar `-like` para filtrar nombres que coincidan con un patrón.

```powershell
Get-Process | Where-Object Name -like "s*"
```

Muestra procesos cuyo nombre empieza por `s`.

Recuerda:

- `s*`: empieza por s y puede tener cualquier cosa después.
- `*s`: termina en s.
- `*s*`: contiene una s en cualquier posición.

## 8.5. Filtrado numérico

También podemos comparar números.

```powershell
Get-Process | Where-Object Id -ge 5000
```

Muestra los procesos cuyo identificador sea mayor o igual que 5000.

---

## 9. Conceptos que debes dominar para los ejercicios

Esta última parte es una chuleta de los símbolos y estructuras que aparecen constantemente en los scripts.

## 9.1. Símbolos importantes

| Símbolo | Significado |
| --- | --- |
| `$` | Identifica una variable |
| `@()` | Crea un array |
| `@{}` | Crea una tabla Hash |
| `[]` | Permite indicar tipos o acceder a posiciones |
| `.` | Accede a propiedades y métodos |
| `::` | Accede a miembros estáticos de una clase |
| `()` | Agrupa expresiones o ejecuta métodos |
| `{}` | Delimita bloques de código |
| `\|` | Canaliza información entre comandos |
| `$_` | Representa el objeto actual en una canalización |
| `#` | Añade comentarios |
| `+` | Suma o concatena cadenas |

## 9.2. Estructuras de control

Aunque todavía no hemos profundizado en ellas, ya hemos utilizado algunas.

**If:** permite ejecutar instrucciones dependiendo de una condición.

```powershell
if ($edad -ge 18) {
    Write-Host "Mayor de edad"
}
else {
    Write-Host "Menor de edad"
}
```

**Foreach:** recorre los elementos de una colección.

```powershell
foreach ($elemento in $lista) {
    Write-Host $elemento
}
```

**Start-Sleep:** detiene temporalmente la ejecución.

```powershell
Start-Sleep -Seconds 3
```

---

## 10. Chuleta rápida para estudiar

| Si necesitas... | Utiliza... |
| --- | --- |
| Crear una variable | `$variable = valor` |
| Forzar un tipo | `[int]`, `[string]`, `[bool]` |
| Conocer el tipo | `.GetType().Name` |
| Mostrar información | `Write-Host` |
| Conocer longitud | `.Length` |
| Convertir a mayúsculas | `.ToUpper()` |
| Convertir a minúsculas | `.ToLower()` |
| Eliminar espacios extremos | `.Trim()` |
| Sustituir texto | `.Replace()` |
| Extraer caracteres | `.Substring()` |
| Rellenar con ceros | `.PadLeft()` |
| Comprobar el inicio | `.StartsWith()` |
| Dividir una cadena | `.Split()` |
| Comprobar patrones | `-like`, `-match` |
| Sustituir con expresiones regulares | `-replace` |
| Obtener fecha actual | `Get-Date` |
| Sumar días | `.AddDays()` |
| Medir duración | `[TimeSpan]` |
| Crear un array | `@()` |
| Crear una tabla Hash | `@{}` |
| Añadir elementos a ArrayList | `.Add()` |
| Insertar elementos | `.Insert()` |
| Eliminar elementos | `.Remove()` |
| Comprobar elementos | `.Contains()` |
| Ordenar una lista | `.Sort()` |
| Recorrer elementos | `foreach` |
| Crear un objeto personalizado | `[PSCustomObject]` |
| Exportar a CSV | `Export-Csv` |
| Pasar parámetros agrupados | `@parametros` |
| Inspeccionar un objeto | `Get-Member` |
| Seleccionar propiedades | `Select-Object` |
| Ordenar objetos | `Sort-Object` |
| Agrupar objetos | `Group-Object` |
| Calcular estadísticas | `Measure-Object` |
| Filtrar objetos | `Where-Object` |
