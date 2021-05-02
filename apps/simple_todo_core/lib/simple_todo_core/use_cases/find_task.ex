defmodule SimpleTodoCore.UseCases.FindTask do
  import Destructure

  defmodule Deps, do: defstruct [:task_repository]
  def call(d%Deps{task_repository}), do: fn
    task_id -> task_repository.find(task_id)
  end
end
