#!/bin/bash
echo "Iniciando script de corrección de IISSI2: Este script añadirá la carpeta git de los proyectos base para que, desde un IDE pueda hacerse un diff y ver fácilmente lo realizado por el estudiante"
#carpeta_frontend=$(ls -c -ltd *Frontend*)
carpeta_frontend=$(ls -d *Frontend*)
if test -z "$carpeta_frontend"
then
      echo "No se ha encontrado carpeta que contenga la string Frontend. Renombre el directorio del alumno para contener la string Frontend (case sensitive)"
      exit 1
else
      echo "Se ha encontrado carpeta de front-end: $carpeta_frontend"
fi
echo "La carpeta de frontend encontrada es $carpeta_frontend"
#carpeta_backend=$(ls -c -ltd *Backend*)
carpeta_backend=$(ls -d *Backend*)
if test -z "$carpeta_backend"
then
      echo "No se ha encontrado carpeta que contenga la string Backend. Renombre el directorio del alumno para contener la string Backend (case sensitive)"
      exit 1
else
      echo "Se ha encontrado carpeta de back-end: $carpeta_backend"
fi
git clone https://github.com/IISSI2-IS/DeliverUS-Backend.git backend-base
git clone https://github.com/IISSI2-IS/DeliverUS-Frontend-Owner.git frontend-base
cp -R ./frontend-base/.git ./$carpeta_frontend
mv -f ./frontend-base/.env.example ./$carpeta_frontend/.env
cp -R ./backend-base/.git ./$carpeta_backend
mv -f ./backend-base/.env.example ./$carpeta_backend/.env
mv -f ./backend-base/docker-compose.yml ./$carpeta_backend/docker-compose.yml
cp ./$carpeta_backend/.env ./$carpeta_backend/.env.docker
sed -i '' 's/localhost/mariadb/g' ./$carpeta_backend/.env.docker
rm -rf ./frontend-base
rm -rf ./backend-base
cd ./$carpeta_backend
git config core.filemode false
git config core.autocrlf false
git config core.whitespace cr-at-eol
cd ..
cd ./$carpeta_frontend
git config core.filemode false
git config core.autocrlf false
git config core.whitespace cr-at-eol
cd ..
read -p "El script de inicialización de GIT finalizó con éxito. ¿Quiere hacer npm install y start en los dos proyectos? y/n " yn
    case $yn in
        [Yy]* ) echo "Abriendo VSCode...";code .;cd ./$carpeta_backend;docker-compose up -d; cd ..; cd ./$carpeta_frontend;npm install;npm start;echo "Npm install ejecutado en ambos proyectos. Haciendo npm start de back-end en docker y front-end en local";;
        [Nn]* ) echo "Abriendo VSCode...";code .;exit 0;;
        * ) echo "Conteste yes o no.";;
    esac
