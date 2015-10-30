Feature: Administrators can view all score syncs in the database
  
  Scenario: I can see all score syncs listed on the index
    Given the following syncs have occured:
      | sync_start              | tweets_found  | tweets_used   | is_successful |
      | 2015-10-30 20:47:03 UTC | 100           | 0             | true          |
      | 2015-10-30 21:47:03 UTC | 100           | 5             | true          |
      | 2015-10-30 22:47:03 UTC | 100           | 1             | true          |
    
    Given I am on the score syncs admin page
    Then I can see a list of all of the twitter syncs that have been performed
    
  Scenario: I can force a new score sync
    Given I am on the score syncs admin page
    When I press the force sync button
    And I wait 2 seconds
    Then I should see "Finished new score sync from Twitter."