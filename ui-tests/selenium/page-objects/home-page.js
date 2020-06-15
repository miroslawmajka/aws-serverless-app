const Page = require('./page');

class HomePage extends Page {
    constructor() {
        super();

        this.selectorOpenDialogButton = '#myHeader > div > div > button';
        this.selectorLambdaDialog = '#id01 > div';
    }

    navigate() {
        browser.url('');

        return this;
    }

    clickLambdaDialogOpen() {
        const openDialogButton = $(this.selectorOpenDialogButton);

        openDialogButton.click();
    }

    lambdaDialogIsDisplayed() {
        const lambdaDialog = $(this.selectorLambdaDialog);

        lambdaDialog.waitForDisplayed();

        return lambdaDialog.isDisplayed();
    }
}

module.exports = HomePage;
