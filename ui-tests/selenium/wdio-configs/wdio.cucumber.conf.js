require('dotenv').config();

const HALF_MINUTE = 30000;

const wdioCucumber = {
    sync: true,
    connectionRetryCount: 3,
    waitforTimeout: HALF_MINUTE / 3,
    connectionRetryTimeout: HALF_MINUTE,
    baseUrl: process.env.BASE_URL,
    logLevel: 'warn',
    before: (capabilities, specs) => {
        const chai = require('chai');

        global.expect = chai.expect;
        global.assert = chai.assert;
        global.should = chai.should();
    },
    onComplete: (exitCode, config, capabilities, results) => {
        console.log(
            `All WebdriverIO workers complete with "${exitCode}" exit code`
        );
    },
    specs: ['./features/*.feature'],
    framework: 'cucumber',
    cucumberOpts: {
        format: ['pretty'],
        colors: true,
        timeout: HALF_MINUTE * 2,
        backtrace: true,
        require: ['./features/support/*.js', './features/step_definitions/*.js']
    },
    reporters: [
        'spec',
        [
            'junit',
            {
                outputDir: './test-results/cucumber',
                outputFileFormat: (options) => {
                    const browserName = options.capabilities.browserName.replace(
                        /\s+/g,
                        ''
                    );

                    return `results-${options.cid}.${browserName}.xml`;
                }
            }
        ]
    ]
};

// Used for VS Code debugging, see README.md for sample debug launch configuration
if (process.env.DEBUG === 'true') {
    wdioCucumber.debug = process.env.DEBUG === 'true';
    wdioCucumber.execArgv = ['--inspect-brk=127.0.0.1:5859'];
}

module.exports = wdioCucumber;
