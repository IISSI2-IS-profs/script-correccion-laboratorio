#!/bin/bash
echo "Iniciando script de corrección de IISSI2: Este script añadirá la carpeta git de los proyectos base para que, desde un IDE pueda hacerse un diff y ver fácilmente lo realizado por el estudiante"
carpeta_backend=$(ls -d *Backend*)
if test -z "$carpeta_backend"
then
      echo "No se ha encontrado carpeta que contenga la string Backend. Renombre el directorio del alumno para contener la string Backend (case sensitive)"
      exit 1
else
      echo "Se ha encontrado carpeta de back-end: $carpeta_backend"
fi
cd $carpeta_backend
cd ..
git clone https://github.com/IISSI2-IS-profs/DeliverUS-Owner-Monorepo monorepo-base
cp -R ./monorepo-base/.git .
cp -R ./monorepo-base/.gitignore .
rm -rf ./monorepo-base
git config core.filemode false
git config core.autocrlf false
git config core.whitespace cr-at-eol
read -p "El script de inicialización de GIT finalizó con éxito. ¿Quiere hacer npm install y start en los dos proyectos? y/n " yn
    case $yn in
        [Yy]* ) echo "Abriendo VSCode...";code .; npm run install:all:bash; echo "Npm install ejecutado en ambos proyectos. Haciendo npm start de back-end (front-end deberás hacerlo a mano ya que ambos tienen que ser interactivos)"; npm run start:backend ;;
        [Nn]* ) echo "Abriendo VSCode...";code .;exit 0;;
        * ) echo "Conteste yes o no.";;
    esac
