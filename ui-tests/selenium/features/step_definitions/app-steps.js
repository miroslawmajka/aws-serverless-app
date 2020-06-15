const { Given, Then, When } = require('cucumber');

const HomePage = require('../../page-objects/home-page');
const { expect } = require('chai');

Given(/^I open the base URL$/, function () {
    const homePage = new HomePage();

    this.scenarioContext.currentPage = homePage.navigate();
});

When(/^I click on the Lambda dialog open button$/, function () {
    const homePage = this.scenarioContext.currentPage;

    homePage.clickLambdaDialogOpen();
});

Then(/^The Lambda dialog is displayed$/, function () {
    const homePage = this.scenarioContext.currentPage;

    const isDisplayed = homePage.lambdaDialogIsDisplayed();

    expect(isDisplayed).to.equal(true);
});
