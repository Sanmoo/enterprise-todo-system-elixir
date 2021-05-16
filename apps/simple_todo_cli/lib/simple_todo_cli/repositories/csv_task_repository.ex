defmodule SimpleTodoCli.Repositories.CsvTaskRepository do
  alias SimpleTodoCore.Repositories.TaskRepository
  alias SimpleTodoCore.Entities.Task
  use SimpleTodoCli.Repositories.CsvRepositoryBase, repository: TaskRepository

  @impl TaskRepository
  def find_completed_with_description_containing(str) do
    filtered =
      find_all()
      |> Enum.filter(fn task -> String.contains?(task.description, str) end)

    {:ok, filtered}
  end

  @impl TaskRepository
  def find_all_tasks_in_list(id) do
    filtered =
      find_all()
      |> Enum.filter(fn task -> task.task_list_id == id end)

    {:ok, filtered}
  end

  @impl TaskRepository
  def delete_by_list_id(id) do
    filtered =
      find_all()
      |> Enum.filter(fn task -> task.task_list_id != id end)

    dump_entity_list_to_file(filtered)
  end

  def file_name(), do: "tasks.csv"

  defp entity_from_list(list) do
    %Task{
      id: Enum.at(list, 0) |> Integer.parse(10) |> elem(0),
      description: Enum.at(list, 1),
      done: Enum.at(list, 2),
      task_list_id: Enum.at(list, 3) |> Integer.parse(10) |> elem(0)
    }
  end

  defp list_from_entity(entity),
    do: [entity.id, entity.description, entity.done, entity.task_list_id]
end
