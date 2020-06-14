/* eslint-disable space-before-function-paren */
const { Then, When } = require('cucumber');

const Page = require('../../page-objects/page');
const { expect } = require('chai');

When(/^I navigate to "([^"]*)" website$/, function (url) {
    const targetPage = new Page(url);

    this.scenarioContext.currentPage = targetPage.navigate();
});

Then(/^The page loads successfully$/, function () {
    const page = this.scenarioContext.currentPage;

    const pageSource = page.getPageSource();

    expect(pageSource).not.to.be.an('undefined');
});
