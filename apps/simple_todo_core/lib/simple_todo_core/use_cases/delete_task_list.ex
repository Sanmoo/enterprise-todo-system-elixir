defmodule SimpleTodoCore.UseCases.DeleteTaskList do
  import Destructure

  defmodule Deps, do: defstruct [:task_repository, :task_list_repository]
  def call(d%Deps{task_repository, task_list_repository}), do: fn
    list_id ->
      task_repository.delete_by_list_id(list_id)
      task_list_repository.destroy(list_id)
  end
end
