Feature: Administrators can view all syncs in the database
  
  Scenario: I can see all syncs listed on the index
    Given the following syncs have occured:
      | timestamp               | new_games     | updated_games | failed_games  | is_successful |
      | 2015-10-30 20:47:03 UTC | 80            | 0             | 0             | true          |
      | 2015-10-30 21:47:03 UTC | 0             | 5             | 0             | true          |
      | 2015-10-30 22:47:03 UTC | 1             | 1             | 1             | false         |
    
    Given I am on the syncs admin page
    Then I can see a list of all of the syncs that have been performed
    
  Scenario: I can force a new sync
    Given I am on the syncs admin page
    When I press the force sync button
    And I wait 2 seconds
    Then I should see "Finished new sync."