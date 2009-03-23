Feature: Searching for a Locality
  Scenario: Fill in valid zip code
    Given I am home
    And I stub out all api calls
    Then I should see a "Enter Address" text field
    When I fill in "32250" for "Enter Address"
    And I submit the search_zip form
    Then I should be on the "32250" locality page

  Scenario: Fill in a zip code with less than five digits
    Given I am home
    And I stub out all api calls
    When I fill in "33" for "Enter Address"
    And I press "search" with javascript enabled
    Then I should be on the home page
    And the "zip_code_error" element should be displayed
