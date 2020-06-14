const wdioCucumber = require('./wdio.cucumber.conf');

// Running 1 test at a time in a local Chrome browser, ideal for debugging
const capabilities = [
    {
        browserName: 'chrome',
        maxInstances: 1
    }
];

if (process.env.HEADLESS_CHROME)
    capabilities.forEach((c) => {
        c['goog:chromeOptions'] = {
            args: ['--headless', '--disable-gpu']
        };
    });

exports.config = Object.assign(
    {
        capabilities,
        maxInstances: 1,
        path: '/',
        runner: 'local',
        chromeDriverLogs: './output',
        services: ['chromedriver']
    },
    wdioCucumber
);
