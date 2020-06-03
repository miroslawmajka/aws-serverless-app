const fs = require('fs');

require('dotenv').config();

const postmanEnvTemplate = require('./postman_environment.template.json');

const apiUrl = process.env.API_URL;

postmanEnvTemplate.values.find(v => v.key === "apiUrl").value = apiUrl;

const postmanEnvComplete = JSON.stringify(postmanEnvTemplate, null, 2);

fs.writeFileSync('postman_environment.json', postmanEnvComplete);