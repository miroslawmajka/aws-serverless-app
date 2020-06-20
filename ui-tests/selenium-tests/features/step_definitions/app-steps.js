const { Given, Then, When } = require('cucumber');

const HomePage = require('../../page-objects/home-page');
const { expect } = require('chai');

Given(/^I open the base URL$/, function () {
    const homePage = new HomePage();

    this.scenarioContext.currentPage = homePage.navigate();
});

When(/^I click the "([^"]*)" button$/, function (buttonName) {
    /**
     * @type HomePage
     */
    const homePage = this.scenarioContext.currentPage;

    homePage.getButton(buttonName).click();
});

Then(/^The lambda dialog is "(displayed|hidden)"$/, function (displayedOrHidden) {
    const shouldBeDisplayed = displayedOrHidden === 'displayed';

    /**
     * @type HomePage
     */
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
    /**
     * @type HomePage
     */
    const homePage = this.scenarioContext.currentPage;

    homePage.waitForOutputBoxCleared();

    expect(homePage.isOutputBoxCleared()).to.equal(true);
});

Then(/^The output from the call is displayed$/, function () {
    /**
     * @type HomePage
     */
    const homePage = this.scenarioContext.currentPage;

    homePage.waitForOutputBoxContent();

    const outputContent = homePage.getOutputBoxContent();

    expect(outputContent).not.to.equal(undefined);
    expect(outputContent).not.to.equal(null);
    expect(outputContent).not.to.equal('');
});

Then(/^The output box shows "([^"]*)"$/, function (expectedContent) {
    /**
     * @type HomePage
     */
    const homePage = this.scenarioContext.currentPage;

    const actualContent = homePage.getOutputBoxContent();

    expect(actualContent).to.equal(expectedContent);
});
