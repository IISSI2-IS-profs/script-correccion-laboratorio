# script-correccion-backend-Fer 2023

Se espera la siguiente estructura de carpetas

- `script-correccion-iissi2-backend-Fer.sh`
- LX
  - LX-FC 3
  - LX-FC 5
  - resto de proyectos de estudiantes

El script se ejecuta desde esta carpeta raíz pasandole como argumento el nombre de la carpeta que contiene los proyectos:

Windows:

```Bash
bash script-correccion-iissi2-backend-Fer-win.sh LX
```

MacOS

```Bash
sudo bash script-correccion-iissi2-backend-Fer-macos.sh LX
```

En cada proyecto de los estudiantes aparecerá un fichero llamado `resumen_tests.txt` donde se habrá calculado el agregado. Por ejemplo:

```Javascript
{"Pass":55,"Fail":22,"Error":9}
```

En la carpeta `thunder-reports` de cada grupo aparecerán los resultados de los tests pormenorizados en csv y html. Podéis también compartirlos con cada grupo.

Este puede ser un texto a compartir con ellos a través de un pull request del repo de estudiantes si lo habilitastéis al crear el assignment o un issue y **adjuntar también el CSV generado en thunder-report** (se puede arrastrar sobre el cuadro de comentario):

```Text
Título: Evaluación primer entregable

Comentario:
Estimados estudiantes,
se ha procedido a realizar una corrección automática de su primer entregable.

El proyecto base cumplía ya con 41 tests y estos son los resultados para su proyecto:
{"Pass":55,"Fail":22,"Error":9}

Resultados pormenorizados:
thunder-report.csv


Tenga en cuenta que estos tests pueden obviar algunas situaciones. Por ejemplo, hemos comprobado que algunos grupos no almacenaban correctamente las líneas de pedido en la tabla intermedia entre Order y Product, y sólo se guardaba como objeto en memoria, por lo que el test correspondiente ha podido ejecutarse con éxito. Sin embargo, es necesario solucionar esto para que en Frontend puedan mostrarse correctamente los pedidos.

Es necesario que aborde las posibles deficiencias encontradas para el correcto funcionamiento del sistema en su conjunto y poder continuar desarrollando el Frontend.

Un saludo,
Alejandro.

```

En el caso de que no se haya podido generar el informe por malfuncionamiento del backend, podéis compartirles este mensaje:

```

Estimados estudiantes,
se ha procedido a realizar una corrección automática de su primer entregable.

Debido a que alguno de los tests provocan la caída del servidor por un error no depurado, no se ha podido generar el informe. Es necesario que corrija los errores y se asegure de que todos los tests se ejecutan correctamente para el correcto funcionamiento del sistema en su conjunto y poder continuar desarrollando el Frontend.

Tenga en cuenta, además, que estos tests pueden obviar algunas situaciones. Por ejemplo, hemos comprobado que algunos grupos no almacenaban correctamente las líneas de pedido en la tabla intermedia entre Order y Product, y sólo se guardaba como objeto en memoria, por lo que el test correspondiente ha podido ejecutarse con éxito. Sin embargo, es necesario solucionar esto para que en Frontend puedan mostrarse correctamente los pedidos.



Un saludo,
Alejandro.
```


## ¿Qué pasos sigue este script?

1. Descarga el repositorio backend base en la raíz
1. Copia el .env y el .git del repo base (al copiar el .git, si luego abres desde VSC, puedes ver cómodamente las diferencias)
1. Copia el settings.json para que thunder-cli funcione correctamente
1. Elimina el package-lock.json, cuando es generado por versiones antiguas de npm impide la instalación de dependencias en versiones actuales de npm.
1. Instala dependencias, rebuild database, lanzar servidor
1. Ejecuta los tests TC, generando el csv y html
1. Agrega los resultados y los guarda en resumen_tests.txt

# script-correccion-laboratorio 2022

*ATENCIÓN*: Si usa Windows (solo si usa Windows), haga los siguientes pasos:

1. wsl --install (si tiene Git Bash puede usar Git bash para ejecutar)
2. Reinicie el sistema
3. Abrir windows terminal (NO SÍMBOLO DEL SISTEMA)

PASOS PARA USUARIOS MAC/LINUX:

1. Antes de correr el script, abre VSCode, pulse ctrl + shift + p y seleccionar Comando shell: Instalar el comando 'code' en el PATH.

PASOS PARA TODOS:

1. Descargue el proyecto del alumno.
2. Copie este archivo script-correccion-iissi2.sh en la carpeta descomprimida. El archivo .sh debe ser hermano de los 2 proyectos del alumno: Frontend y Backend
3. Navegue desde el terminal a la carpeta descomprimida donde se encuentra el archivo .sh
4. Ejecute el script con el siguiente comando en terminal: ./script-correccion-iissi2.sh
5. Lea *atentamente* el output del script.
6. Ejecute desde el terminal VSCode npm start en la carpeta de back-end (el front-end será lanzado desde el script)
