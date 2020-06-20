class Button {
    constructor(selector) {
        this.selector = selector;
    }

    click() {
        const button = $(this.selector);

        button.waitForExist();
        button.waitForDisplayed();
        button.waitForEnabled();

        button.click();

        // TODO: not sure why click sometimes fails without this short pause
        browser.pause();
    }
}

class OpenDialogButton extends Button {
    constructor() {
        super('#btnLambdaDialogOpen');
    }
}

class HelloNodeButton extends Button {
    constructor() {
        super('#btnTestNodeHelloLambda');
    }
}

class HelloPythonButton extends Button {
    constructor() {
        super('#btnTestPythonHelloLambda');
    }
}

class LotteryNodeButton extends Button {
    constructor() {
        super('#btnTestNodeLotteryLambda');
    }
}

class ClearOutputButton extends Button {
    constructor() {
        super('#btnClearLambdaOutput');
    }
}

class DialogCloseButton extends Button {
    constructor() {
        super('#btnDialogClose');
    }
}

module.exports = {
    OpenDialogButton,
    HelloNodeButton,
    HelloPythonButton,
    LotteryNodeButton,
    ClearOutputButton,
    DialogCloseButton
};
