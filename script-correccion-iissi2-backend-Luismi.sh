#!/bin/bash
echo "Starting IISSI2 fix script. This script clones the student repository (first argument to the script) and the reference repository (second argument) and performs preprocessing. It generates a file (differences.diff) with the differences between both projects. It then performs the npm install of the student project, creates the tables, and populates them. Lastly, run the Thunder Client tests through the console"
rm -rf student-backend-project
git clone $1 student-backend-project
student_folder=$(ls -d student-backend-project)
if test -z "$student_folder"
then
      echo "No repository folder found for student"
      exit 1
else
      echo "Student folder found: $student_folder"
fi

input="$student_folder/.git/config"
while IFS= read -r line
do
  if [[ $line == *https://github.com* ]]; then
      echo "Reading remote origin from metadata file: $line"
  fi
done < "$input"



git clone $2 repository-base

reference_folder=$(ls -d repository-base)
if test -z "repository-base"
then
      echo "No reference repository folder found"
      exit 1
else
      echo "Reference folder found: $reference_folder"
fi

cd ./$student_folder
git config core.filemode false
git config core.autocrlf false
git config core.whitespace cr-at-eol
cd ..

cd ./$reference_folder
git config core.filemode false
git config core.autocrlf false
git config core.whitespace cr-at-eol
cd ..

echo "Looking for differences between the reference repository and the one analyzed from the student"
diff -qr --exclude=package-lock.json --exclude=.env.example --exclude=.git ./$student_folder ./$reference_folder

echo "Generating a file called 'differences.diff' with the differences between the two analysed directories"
diff -ur -I '^ \|^.#\|^.$' --exclude=package-lock.json --exclude=.env.example --exclude=.git --exclude=.vscode --exclude=README.md  ./$student_folder ./$reference_folder > differences.diff

npm i -g @thunderclient/cli

cd ./$student_folder
thunder_tests_folder=$(find . -name thunder-tests)

if test -z "thunder_tests_folder"
then
      echo "No thunder test folder found"
      exit 1
else
      echo "Thunder test folder found: $thunder_tests_folder"
fi

cp ../$reference_folder/.env.example .env
npm install
npx sequelize-cli db:migrate:undo:all
npx sequelize-cli db:migrate
npx sequelize-cli db:seed:all


echo "Starting the student project"
npm start&

cd $thunder_tests_folder
cd ..

echo "Waiting for 10 seconds for launched project to start"
sleep 10

tc --col all