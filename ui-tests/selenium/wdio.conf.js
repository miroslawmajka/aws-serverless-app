require('dotenv').config();

const HALF_MINUTE = 30000;

const capabilities = [
    {
        browserName: 'chrome',
        maxInstances: 1
    }
];

if (process.env.HEADLESS_CHROME)
    capabilities.forEach(c => {
        c['goog:chromeOptions'] = {
            args: ['--headless', '--disable-gpu']
        };
    });

const wdioConfig = {
    sync: true,
    connectionRetryCount: 3,
    waitforTimeout: HALF_MINUTE / 3,
    connectionRetryTimeout: HALF_MINUTE,
    baseUrl: process.env.BASE_URL,
    logLevel: 'warn',
    before: () => {
        const chai = require('chai');

        global.should = chai.should();
    },
    onComplete: exitCode => {
        console.log(`All WebdriverIO workers complete with "${exitCode}" exit code`);
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
                outputDir: './test-results',
                outputFileFormat: options => {
                    const browserName = options.capabilities.browserName.replace(/\s+/g, '');

                    return `results-${options.cid}.${browserName}.xml`;
                }
            }
        ]
    ],
    capabilities,
    maxInstances: 1,
    path: '/',
    runner: 'local',
    chromeDriverLogs: './selenium-output',
    services: ['chromedriver']
};

if (process.env.DEBUG === 'true') {
    wdioConfig.debug = process.env.DEBUG === 'true';
    wdioConfig.execArgv = ['--inspect-brk=127.0.0.1:5859'];
}

exports.config = wdioConfig;
