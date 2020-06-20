const Page = require('./page');

const {
    OpenDialogButton,
    HelloNodeButton,
    HelloPythonButton,
    LotteryNodeButton,
    ClearOutputButton,
    DialogCloseButton
} = require('./home-buttons');

class HomePage extends Page {
    constructor() {
        super();

        this.selectorLambdaDialog = '#dlgLambdaDialog';
        this.selectorOutputBox = '#txtLambdaOuput';
    }

    navigate() {
        browser.url('');

        return this;
    }

    waitForLambdaDialogDisplayed() {
        const lambdaDialog = $(this.selectorLambdaDialog);

        lambdaDialog.waitForDisplayed();

        return this;
    }

    waitForLambdaDialogHidden() {
        const lambdaDialog = $(this.selectorLambdaDialog);

        lambdaDialog.waitForDisplayed(undefined, true);

        return this;
    }

    isLambdaDialogDisplayed() {
        const lambdaDialog = $(this.selectorLambdaDialog);

        return lambdaDialog.isDisplayed();
    }

    waitForOutputBoxCleared() {
        const outputBox = $(this.selectorOutputBox);

        outputBox.waitForDisplayed();

        browser.waitUntil(() => outputBox.getValue() === '');

        return this;
    }

    isOutputBoxCleared() {
        const outputBox = $(this.selectorOutputBox);

        outputBox.waitForDisplayed();

        return outputBox.getValue() === '';
    }

    waitForOutputBoxContent() {
        const outputBox = $(this.selectorOutputBox);

        browser.waitUntil(() => outputBox.getValue() !== '');

        return this;
    }

    getOutputBoxContent() {
        const outputBox = $(this.selectorOutputBox);

        return outputBox.getValue();
    }

    getButton(buttonName) {
        const buttonMap = [
            {
                name: 'Open Lambda Test Dialog',
                ButtonClass: OpenDialogButton
            },
            {
                name: 'Node Hello Lambda',
                ButtonClass: HelloNodeButton
            },
            {
                name: 'Python Hello Lambda',
                ButtonClass: HelloPythonButton
            },
            {
                name: 'Node Lottery Lambda',
                ButtonClass: LotteryNodeButton
            },
            {
                name: 'Clear Ouput',
                ButtonClass: ClearOutputButton
            },
            {
                name: 'Lambda Dialog Close',
                ButtonClass: DialogCloseButton
            }
        ];

        const ButtonClass = buttonMap.find(b => b.name === buttonName).ButtonClass;

        if (!ButtonClass) throw new Error(`Invalid button name passed: ${buttonName}`);

        return new ButtonClass();
    }
}

module.exports = HomePage;
