defmodule SimpleTodoCore.UseCases.UpdateTaskList do
  alias SimpleTodoCore.Entities.TaskList

  defmodule Deps, do: defstruct [:task_list_repository]
  def call(%Deps{task_list_repository: repo}), do: fn
    task_list ->
      with :ok <- TaskList.validate(task_list),
           {:ok, similar_task_lists } = repo.find_by_name(task_list.name)
      do
        task_list_id = task_list.id
        case similar_task_lists do
          [] -> repo.update(task_list)
          [%TaskList{id: ^task_list_id} | _] -> repo.update(task_list)
          _ -> {:error, [name: {"There is already a task list with the same name", []}]}
        end
      end
  end
end
