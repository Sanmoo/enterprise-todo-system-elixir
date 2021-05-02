defmodule SimpleTodoCore.UseCases.CreateTaskList do
  alias SimpleTodoCore.Entities.TaskList

  defmodule Deps, do: defstruct [:task_list_repository]
  def call(%Deps{task_list_repository: repo}), do: fn
    task_list ->
      with :ok <- TaskList.validate(task_list),
           {:ok, similar_task_lists } = repo.find_by_name(task_list.name)
      do
        case length(similar_task_lists) do
          0 -> repo.create(task_list) 
          _ -> {:error, [name: {"There is already a task list with the same name", []}]}
        end
      end
  end
end
