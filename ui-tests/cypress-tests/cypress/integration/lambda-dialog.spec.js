/// <reference types="cypress" />

context('Lambda Dialog', () => {
    const SELECTOR_NODE_HELLO = '#btnTestNodeHelloLambda';
    const SELECTOR_PYTHON_HELLO = '#btnTestPythonHelloLambda';
    const SELECTOR_NODE_LOTTERY = '#btnTestNodeLotteryLambda';
    const SELECTOR_OUTPUT = '#txtLambdaOuput';
    const SELECTOR_DIALOG = '#dlgLambdaDialog';
    const SELECTOR_OPEN = '#btnLambdaDialogOpen';
    const SELECTOR_CLOSE = '#btnDialogClose';

    const dialogButtons = [
        {
            name: 'Node Hello',
            selector: SELECTOR_NODE_HELLO
        },
        {
            name: 'Python Hello',
            selector: SELECTOR_PYTHON_HELLO
        },
        {
            name: 'Node Lottery',
            selector: SELECTOR_NODE_LOTTERY
        }
    ];

    beforeEach(() => {
        cy.visit(Cypress.env('WEBSITE_URL'));
    });

    it('is opened upon clicking the button and specific button trigger Lambda calls', () => {
        cy.get(SELECTOR_OPEN).click();

        cy.get(SELECTOR_DIALOG).should('be.visible');
        cy.get(SELECTOR_OUTPUT).should('have.value', '');

        cy.get(SELECTOR_NODE_HELLO).click();

        cy.get(SELECTOR_OUTPUT).should('have.value', 'Hello from Lambda Node!');

        cy.get(SELECTOR_PYTHON_HELLO).click();

        cy.get(SELECTOR_OUTPUT).should('have.value', 'Hello from Lambda Python!');

        cy.get(SELECTOR_NODE_LOTTERY).click();

        cy.get(SELECTOR_OUTPUT).should('not.have.value', 'Hello from Lambda Node!');
        cy.get(SELECTOR_OUTPUT).should('not.have.value', 'Hello from Lambda Python!');

        cy.get('#btnClearLambdaOutput').click();

        cy.get(SELECTOR_OUTPUT).should('have.value', '');

        cy.get(SELECTOR_CLOSE).click();

        cy.get(SELECTOR_DIALOG).should('not.be.visible');
    });

    dialogButtons.forEach(b => {
        it(`is opened with a clean output box after using the ${b.name} button`, () => {
            cy.get(SELECTOR_OPEN).click();

            cy.get(SELECTOR_DIALOG).should('be.visible');
            cy.get(SELECTOR_OUTPUT).should('have.value', '');

            cy.get(b.selector).click();
            cy.get(SELECTOR_CLOSE).click();

            cy.get(SELECTOR_DIALOG).should('not.be.visible');

            cy.get(SELECTOR_OPEN).click();

            cy.get(SELECTOR_DIALOG).should('be.visible');
            cy.get(SELECTOR_OUTPUT).should('have.value', '');
        });
    });
});
