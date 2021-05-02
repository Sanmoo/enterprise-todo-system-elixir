defmodule SimpleTodoCore.UseCases.FindTaskList do
  import Destructure

  defmodule Deps, do: defstruct [:task_repository, :task_list_repository]
  def call(d%Deps{task_repository, task_list_repository}), do: fn
    list_id ->
      with {:ok, tasks} = task_repository.find_all_tasks_in_list(list_id),
           task_list = task_list_repository.find(list_id)
      do
        case task_list do
          nil -> nil
          l -> Map.put(l, :tasks, tasks)
        end
      end
  end
end
