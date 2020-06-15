// Read the ".env" file with the Terraform output variables
require('dotenv').config();

// Open the Postman environment template file
const postmanEnvTemplate = require('./postman_environment.template.json');

// IMPORANT: update the template "apiUrl" value with the output variable from Terraform
postmanEnvTemplate.values.find(v => v.key === 'apiUrl').value = process.env.API_URL;

// Save the Postman environment file with the "apiUrl" value set to the correct API URL
require('fs').writeFileSync('postman_environment.json', JSON.stringify(postmanEnvTemplate, null, 2));
