defmodule SimpleTodoCore.Repositories.TaskRepository do
  alias SimpleTodoCore.Entities.Task
  use SimpleTodoCore.Repositories.Base, module: Task

  @callback find_completed_with_description_containing(String.t) :: {:ok, [Task.t] }
  @callback find_all_tasks_in_list(integer) :: {:ok, [Task.t] }
  @callback delete_by_list_id(integer) :: :ok | error
end
