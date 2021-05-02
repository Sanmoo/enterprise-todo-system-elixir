defmodule SimpleTodoCore.Utils.InMemoryTaskRepository do
  alias SimpleTodoCore.Repositories.TaskRepository
  use SimpleTodoCore.Utils.BaseInMemoryRepository, repository: TaskRepository

  @impl TaskRepository
  def find_completed_with_description_containing(str) do
    filtered = 
      Agent.get(__MODULE__, &(&1))
      |> Enum.filter(fn task -> String.contains?(task.description, str) end)
    {:ok, filtered}
  end

  @impl TaskRepository
  def find_all_tasks_in_list(id) do
    filtered = 
      Agent.get(__MODULE__, &(&1))
      |> Enum.filter(fn task -> task.task_list_id == id end)
    {:ok, filtered}
  end

  @impl TaskRepository
  def delete_by_list_id(id) do
    filtered = 
      Agent.get(__MODULE__, &(&1))
      |> Enum.filter(fn task -> task.task_list_id != id end)
    Agent.update(__MODULE__, fn _ -> filtered end)
  end
end
