#!/bin/bash

echo Installing thunderclient/cli...
npm i -g @thunderclient/cli
git clone https://github.com/IISSI2-IS-2022-2023/DeliverUS-Backend.git
baseBackendName='DeliverUS-Backend'
echo $baseBackendName
for dir in ./$1/*/
do
	echo
	echo "Student project: $dir"

	cd "$dir"
	echo "...copying .git from "../../$baseBackendName/.git""
	cp -r "../../$baseBackendName/.git" . >> correccion.log 2>&1

	echo "...copying .env from $baseBackendName"
	cp "../../$baseBackendName/.env.example" .env >> correccion.log 2>&1

    echo "...copying settings.json from base dir"
	cp "../../$baseBackendName/.vscode/settings.json" .vscode >> correccion.log 2>&1

	echo "...copying thunder-tests from base dir"
	cp -r "../../$baseBackendName/example_api_client/thunder-tests" ./example_api_client/ >> correccion.log 2>&1

	echo "...removing package-lock.json to prevent from old file type versions from $dir"
	rm package-lock.json >> correccion.log 2>&1

    echo "...npm install"
	npm install >> correccion.log 2>&1
	npm i csv-parser fs >> correccion.log 2>&1

    echo "...migrating and seeding"
    npx sequelize-cli db:migrate:undo:all >> correccion.log 2>&1
	npx sequelize-cli db:migrate >> correccion.log 2>&1
	npx sequelize-cli db:seed:all >> correccion.log 2>&1

	echo "...starting the student project"
	nodemon --ignore ./example_api_client/ backend.js >> correccion.log 2>&1 &
	pid=$!

	echo "...waiting for 5 seconds for launched project to start"
	sleep 5

	echo "...running TC tests"
	rm -rf thunder-reports >> correccion.log 2>&1
	timeout 30s tc --col all --report csv,html - ui >> correccion.log 2>&1
	if [ $? -eq 124 ]; then
	  echo ...timeout reached, aborting
	else
	  report_csv=$(find thunder-reports -name thunder-report_*)
	  node - "$report_csv" >> correccion.log 2>&1 <<EOF
const fs = require('fs');
const csv = require('csv-parser');

const results = {};

fs.createReadStream(process.argv[2])
  .pipe(csv({skipLines: 13,
    mapHeaders: ({ header }) => header.trim(),
    mapValues: ({ value }) => value.trim()}))
  .on('data', (data) => {
    if (!results[data.Result]) {
      results[data.Result] = 0;
    }
    results[data.Result]++;
  })
  .on('end', () => {
    fs.writeFileSync('resumen_tests.txt', JSON.stringify(results));
  });
EOF
	fi

	echo "...killing backend server"
	kill $pid >> correccion.log 2>&1


	echo "...counting passing tests"

	wait $pid >> correccion.log 2>&1
	cd ../..
done
