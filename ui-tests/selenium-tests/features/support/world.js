const { setWorldConstructor } = require('cucumber');

class CustomWorld {
    constructor() {
        this.scenarioContext = {};
    }
}

setWorldConstructor(CustomWorld);
