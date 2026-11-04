# 11. Extraer prefijo de país

$tlf = "+34-600111222"
$tlf.Substring(0, 3)

# 12. Extraer año fiscal

$codigo = "2024-FACTURA-SEP"
$codigo.Substring(0, 4)

# 13. Ignorar el primer carácter

$idEmpleado = "E55421"
$idEmpleado.Substring(1)

# 14. Extraer extensión de archivo

$fichero = "informe.pdf"
$fichero.Substring($fichero.Length - 3)

# 15. Relleno de ceros (Padding)

$numero = "7"
$numero.PadLeft(3, "0")
