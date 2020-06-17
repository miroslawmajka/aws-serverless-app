const Page = require('./page');

class HomePage extends Page {
    constructor() {
        super();

        this.selectorOpenDialogButton = '#btnLambdaDialogOpen';
        this.selectorLambdaDialog = '#dlgLambdaDialog';
        this.selectorOutputBox = '#txtLambdaOuput';
    }

    navigate() {
        browser.url('');

        return this;
    }

    clickLambdaDialogOpen() {
        const openDialogButton = $(this.selectorOpenDialogButton);

        openDialogButton.click();

        return this;
    }

    isLambdaDialogDisplayed() {
        const lambdaDialog = $(this.selectorLambdaDialog);

        lambdaDialog.waitForDisplayed();

        return lambdaDialog.isDisplayed();
    }

    isOutputBoxCleared() {
        const outputBox = $(this.selectorOutputBox);

        outputBox.waitForDisplayed();

        return outputBox.getValue() === '';
    }
}

module.exports = HomePage;
