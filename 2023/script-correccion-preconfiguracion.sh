#!/bin/bash

# Ruta del archivo que deseas copiar
archivo_a_copiar="script-correccion-iissi2-2023-lab-individual.sh"

# Ruta del repositorio a clonar
repositorio="https://github.com/IISSI2-IS-profs/DeliverUS-Owner-Monorepo"
repositorio_local="./DeliverUS-Owner-Monorepo"

# Comprobar si el repositorio ya está clonado
if [ -d "$repositorio_local" ]; then
    echo "El repositorio ya está clonado en la ruta $repositorio_local."
else
    # Clonar el repositorio
    git clone "$repositorio" "$repositorio_local"
    echo "El repositorio se clonó correctamente en la ruta $repositorio_local."
fi

# Copiar el archivo .gitignore a todas las subcarpetas "DeliverUS"
find . -type d -name "DeliverUS" | while read -r carpeta; do
    # Copiar el directorio .git
    cp -r "$repositorio_local/.git" "$carpeta"
    echo "El directorio .git se copió correctamente en la carpeta $carpeta."

    # Copiar el archivo .gitignore
    cp "$repositorio_local/.gitignore" "$carpeta"
    echo "El archivo .gitignore se copió correctamente en la carpeta $carpeta."
done

# Copiar el archivo script-correccion-iissi2-2022.sh a todas las subcarpetas "DeliverUS"
find . -type d -name "DeliverUS" | while read -r carpeta; do
    # Comprobar si el archivo ya existe en la carpeta
    if [ -e "$carpeta/$archivo_a_copiar" ]; then
        echo "El archivo ya existe en la carpeta $carpeta. No se copiará nuevamente."
    else
        # Copiar el archivo a la carpeta
        cp "$archivo_a_copiar" "$carpeta"
        echo "El archivo se copió correctamente en la carpeta $carpeta."
    fi
done
