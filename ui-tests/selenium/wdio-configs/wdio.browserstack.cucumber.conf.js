const browserstackLocal = require('browserstack-local');
const fs = require('fs');

const wdioCucumber = require('./wdio.cucumber.conf');

const BROWSERSTACK_ACCESS_KEY = process.env.BROWSERSTACK_ACCESS_KEY;
const BROWSERSTACK_LOCAL_IDENTIFIER = process.env.BROWSERSTACK_LOCAL_IDENTIFIER;

// Ideal for running in continous testing environment powered by TeamCity/CircleCI/etc
const capabilities = [
    {
        os: 'OS X',
        os_version: 'Mojave',
        browserName: 'Chrome',
        browser_version: '77.0',
        maxInstances: 1,
        'browserstack.local': true,
        'browserstack.localIdentifier': BROWSERSTACK_LOCAL_IDENTIFIER
    }
];

capabilities.forEach((c) => {
    c.build = 'Cucumber Boilerplate Build N/A';
    c.project = 'Cucumber Boilerplate Project';
});

const config = Object.assign(
    {
        capabilities,
        maxInstances: 1,
        user: process.env.BROWSERSTACK_USERNAME,
        key: BROWSERSTACK_ACCESS_KEY,
        services: ['browserstack'],
        onPrepare: (config, capabilities) => {
            return new Promise((resolve, reject) => {
                console.log('Connecting to BrowserStack Local Testing...');

                exports.tunnelInstance = new browserstackLocal.Local();

                fs.mkdirSync('./output', { recursive: true });

                const opts = {
                    key: BROWSERSTACK_ACCESS_KEY,
                    verbose: true,
                    forceLocal: true,
                    onlyAutomate: true,
                    force: true,
                    logFile: './output/browserstack-local.log',
                    localIdentifier: BROWSERSTACK_LOCAL_IDENTIFIER
                };

                exports.tunnelInstance.start(opts, (error) => {
                    if (error) return reject(error);

                    console.log('Connected to BrowserStack Local Testing');
                    console.log(opts);

                    resolve();
                });
            });
        }
    },
    wdioCucumber
);

// Override "onComplete" from common
config.onComplete = (exitCode, config, capabilities, results) => {
    console.log(
        `All WebdriverIO workers complete with "${exitCode}" exit code`
    );
    console.log(
        `BrowserStack Local Testing running: "${exports.tunnelInstance.isRunning()}"`
    );

    if (exports.tunnelInstance) {
        console.log('Stopping BrowserStack Local Testing...');

        return new Promise((resolve) => {
            exports.tunnelInstance.stop(() => {
                console.log('Stopped BrowserStack Local Testing');

                resolve();
            });
        });
    }
};

exports.config = config;
