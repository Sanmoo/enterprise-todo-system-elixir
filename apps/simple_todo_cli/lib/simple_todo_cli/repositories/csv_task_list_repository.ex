defmodule SimpleTodoCli.Repositories.CsvTaskListRepository do
  alias SimpleTodoCore.Repositories.TaskListRepository
  use SimpleTodoCli.Repositories.CsvRepositoryBase, repository: TaskListRepository
  alias SimpleTodoCore.Entities.TaskList

  @impl TaskListRepository
  def find_by_name(name) do
    filtered =
      find_all()
      |> Enum.filter(fn task -> task.name == name end)

    {:ok, filtered}
  end

  def file_name(), do: "task_lists.csv"
  defp entity_from_list(list), do: %TaskList{id: Enum.at(list, 0), name: Enum.at(list, 1)}
  defp list_from_entity(entity), do: [entity.id, entity.name]
end
