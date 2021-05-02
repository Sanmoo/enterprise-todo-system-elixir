defmodule SimpleTodoCore.UseCases.CreateTask do
  alias SimpleTodoCore.Entities.Task

  defmodule Deps, do: defstruct [:task_repository]
  def call(deps = %Deps{}), do: fn
    task ->
      with(
        :ok <- Task.validate(task),
        repo = deps.task_repository,
        {:ok, similar_tasks } = repo.find_completed_with_description_containing(task.description)
      ) do
        if length(similar_tasks) > 0 do
          {:error, [description: {"There is already an uncompleted task with the same description", []}]}
        else
          deps.task_repository.create(task)
        end
      end
  end
end
