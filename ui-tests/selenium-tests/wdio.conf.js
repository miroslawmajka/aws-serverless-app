require('dotenv').config();

const HEADLESS_CHROME = process.env.HEADLESS_CHROME;
const WEBSITE_URL = process.env.WEBSITE_URL;
const DEBUG = process.env.DEBUG;

const HALF_MINUTE = 30000;
const FEATURES_DIR = 'features';

const capabilities = [
    {
        browserName: 'chrome',
        maxInstances: 1
    }
];

if (HEADLESS_CHROME)
    capabilities.forEach(c => {
        c['goog:chromeOptions'] = {
            args: ['--headless', '--disable-gpu']
        };
    });

const wdioConfig = {
    sync: true,
    connectionRetryCount: 3,
    waitforTimeout: HALF_MINUTE / 6,
    connectionRetryTimeout: HALF_MINUTE,
    baseUrl: WEBSITE_URL,
    logLevel: 'warn',
    before: () => {
        global.expect = require('chai').expect;
    },
    onComplete: exitCode => {
        console.log(`All WebdriverIO workers complete with "${exitCode}" exit code`);
    },
    specs: [`./${FEATURES_DIR}/*.feature`],
    framework: 'cucumber',
    cucumberOpts: {
        format: ['pretty'],
        colors: true,
        timeout: HALF_MINUTE * 2,
        backtrace: true,
        require: [`./${FEATURES_DIR}/support/*.js`, `./${FEATURES_DIR}/step_definitions/*.js`]
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

if (DEBUG === 'true') {
    wdioConfig.debug = true;
    wdioConfig.execArgv = ['--inspect-brk=127.0.0.1:5859'];
}

exports.config = wdioConfig;
