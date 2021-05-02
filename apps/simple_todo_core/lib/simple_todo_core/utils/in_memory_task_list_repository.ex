defmodule SimpleTodoCore.Utils.InMemoryTaskListRepository do
  alias SimpleTodoCore.Repositories.TaskListRepository
  use SimpleTodoCore.Utils.BaseInMemoryRepository, repository: TaskListRepository

  @impl TaskListRepository
  def find_by_name(name) do
    filtered = 
      Agent.get(__MODULE__, &(&1))
      |> Enum.filter(fn task -> task.name == name end)
    {:ok, filtered}
  end
end
