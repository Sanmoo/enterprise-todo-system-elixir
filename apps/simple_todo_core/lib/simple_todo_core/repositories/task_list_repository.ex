defmodule SimpleTodoCore.Repositories.TaskListRepository do
  alias SimpleTodoCore.Entities.TaskList
  use SimpleTodoCore.Repositories.Base, module: TaskList

  @callback find_by_name(String.t) :: {:ok, Task.t}
end
