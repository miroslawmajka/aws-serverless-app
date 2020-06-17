const { Given, Then, When } = require('cucumber');

const HomePage = require('../../page-objects/home-page');
const { expect } = require('chai');

Given(/^I open the base URL$/, function () {
    const homePage = new HomePage();

    this.scenarioContext.currentPage = homePage.navigate();
});

When(/^I click the "([^"]*)" button$/, function (buttonName) {
    const homePage = this.scenarioContext.currentPage;

    // TODO: create a button map that will run a click based upon "buttonName"

    homePage.clickLambdaDialogOpen();
});

Then(/^The lambda dialog is "(displayed|hidden)"$/, function (displayedOrHidden) {
    const homePage = this.scenarioContext.currentPage;

    const isDisplayed = homePage.isLambdaDialogDisplayed();

    expect(isDisplayed).to.equal(displayedOrHidden === 'displayed');
});

Then(/^The output box is cleared$/, function () {
    const homePage = new HomePage();

    expect(homePage.isOutputBoxCleared()).to.equal(true);
});
