const { Given, Then, When } = require('cucumber');

const HomePage = require('../../page-objects/home-page');
const { expect } = require('chai');

Given(/^I open the base URL$/, function () {
    const homePage = new HomePage();

    this.scenarioContext.currentPage = homePage.navigate();
});

When(/^I click the "([^"]*)" button$/, function (buttonName) {
    const homePage = this.scenarioContext.currentPage;

    homePage.getButton(buttonName).click();
});

Then(/^The lambda dialog is "(displayed|hidden)"$/, function (displayedOrHidden) {
    const shouldBeDisplayed = displayedOrHidden === 'displayed';

    const homePage = this.scenarioContext.currentPage;

    if (shouldBeDisplayed) {
        homePage.waitForLambdaDialogDisplayed();
    } else {
        homePage.waitForLambdaDialogHidden();
    }

    const isDisplayed = homePage.isLambdaDialogDisplayed();

    expect(isDisplayed).to.equal(shouldBeDisplayed);
});

Then(/^The output box is cleared$/, function () {
    const homePage = new HomePage();

    homePage.waitForOutputBoxCleared();

    expect(homePage.isOutputBoxCleared()).to.equal(true);
});

Then(/^The output from the call is displayed$/, function () {
    const homePage = new HomePage();

    homePage.waitForOutputBoxContent();

    const outputContent = homePage.getOutputBoxContent();

    expect(outputContent).not.to.equal(undefined);
    expect(outputContent).not.to.equal(null);
    expect(outputContent).not.to.equal('');
});

Then(/^The output box shows "([^"]*)"$/, function (expectedContent) {
    const homePage = this.scenarioContext.currentPage;

    const actualContent = homePage.getOutputBoxContent();

    expect(actualContent).to.equal(expectedContent);
});
