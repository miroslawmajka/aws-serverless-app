/// <reference types="cypress" />

context('Lambda Dialog', () => {
    beforeEach(() => {
        cy.visit(Cypress.env('WEBSITE_URL'));
    });

    it('is opened upon clicking the button', () => {
        cy.get('#btnLambdaDialogOpen').click();
    });

    // TODO: expand tests
});
