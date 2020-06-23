Feature: AWS Serverless App Lambda Dialog

  Background: Open the home page of the application
    Given I open the base URL

  Scenario: Open the Lmabda dialog and run the functions
    When I click the "Open Lambda Test Dialog" button
    Then The lambda dialog is "displayed"
    And The output box is cleared

    When I click the "Node Hello Lambda" button
    Then The output from the call is displayed
    Then The output box shows "Hello from Lambda Node!"

    When I click the "Python Hello Lambda" button
    Then The output from the call is displayed
    Then The output box shows "Hello from Lambda Python!"

    When I click the "Node Lottery Lambda" button
    Then The output from the call is displayed

    When I click the "Clear Ouput" button
    Then The output box is cleared

    When I click the "Lambda Dialog Close" button
    Then The lambda dialog is "hidden"

  Scenario Outline: Ensuring the output is cleared after using the <buttonName> button
    When I click the "Open Lambda Test Dialog" button
    Then The lambda dialog is "displayed"
    And The output box is cleared

    When I click the "<buttonName>" button
    Then The output from the call is displayed

    When I click the "Lambda Dialog Close" button
    Then The lambda dialog is "hidden"

    When I click the "Open Lambda Test Dialog" button
    And The output box is cleared

    Examples:
      | buttonName          |
      | Node Hello Lambda   |
      | Python Hello Lambda |
      | Node Lottery Lambda |
