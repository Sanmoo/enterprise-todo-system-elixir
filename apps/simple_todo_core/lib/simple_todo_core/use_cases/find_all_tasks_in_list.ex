defmodule SimpleTodoCore.UseCases.FindAllTasksInList do
  import Destructure

  defmodule Deps, do: defstruct [:task_repository]
  def call(d%Deps{task_repository}), do: fn
    id -> task_repository.find_all_tasks_in_list(id)
  end
end
