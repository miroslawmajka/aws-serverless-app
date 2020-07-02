/// <reference types="cypress" />

context('Lambda Dialog', () => {
    const NODE_HELLO = '#btnTestNodeHelloLambda';
    const PYTHON_HELLO = '#btnTestPythonHelloLambda';
    const NODE_LOTTERY = '#btnTestNodeLotteryLambda';

    const dialogButtons = [
        {
            name: 'Node Hello',
            selector: NODE_HELLO
        },
        {
            name: 'Python Hello',
            selector: PYTHON_HELLO
        },
        {
            name: 'Node Lottery',
            selector: NODE_LOTTERY
        }
    ];

    beforeEach(() => {
        cy.visit(Cypress.env('WEBSITE_URL'));
    });

    it('is opened upon clicking the button and specific button trigger Lambda calls', () => {
        cy.get('#btnLambdaDialogOpen').click();

        cy.get('#dlgLambdaDialog').should('be.visible');

        cy.get('#txtLambdaOuput').should('have.value', '');

        cy.get(NODE_HELLO).click();

        cy.get('#txtLambdaOuput').should('have.value', 'Hello from Lambda Node!');

        cy.get(PYTHON_HELLO).click();

        cy.get('#txtLambdaOuput').should('have.value', 'Hello from Lambda Python!');

        cy.get(NODE_LOTTERY).click();

        cy.get('#txtLambdaOuput').should('not.have.value', 'Hello from Lambda Node!');
        cy.get('#txtLambdaOuput').should('not.have.value', 'Hello from Lambda Python!');

        cy.get('#btnClearLambdaOutput').click();

        cy.get('#txtLambdaOuput').should('have.value', '');

        cy.get('#btnDialogClose').click();

        cy.get('#dlgLambdaDialog').should('not.be.visible');
    });

    dialogButtons.forEach(b => {
        it(`is opened with a clean output box after using the ${b.name} button`, () => {
            cy.get('#btnLambdaDialogOpen').click();

            cy.get('#dlgLambdaDialog').should('be.visible');

            cy.get('#txtLambdaOuput').should('have.value', '');

            cy.get(b.selector).click();

            cy.get('#btnDialogClose').click();

            cy.get('#dlgLambdaDialog').should('not.be.visible');

            cy.get('#btnLambdaDialogOpen').click();

            cy.get('#dlgLambdaDialog').should('be.visible');

            cy.get('#txtLambdaOuput').should('have.value', '');
        });
    });
});
