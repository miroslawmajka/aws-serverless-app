/// <reference types="cypress" />

// TODO: make this work to get the application URL
// require('dotenv').config();

context('Aliasing', () => {
    beforeEach(() => {
        cy.visit(process.env.WEBSITE_URL);
    });

    it('.as() - alias a DOM element for later use', () => {
        cy.get('#btnLambdaDialogOpen').click();
    });
});
