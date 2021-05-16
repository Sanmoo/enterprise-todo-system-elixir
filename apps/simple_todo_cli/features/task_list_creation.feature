Feature: Task list creation
  
  Scenario: Successful creation of tasks
    When I call "stodo new-task-list --name 'Shop in whatever'"
    And I call "stodo list-task-lists"
    I can see the result:
      | name             |
      | Shop in whatever |

