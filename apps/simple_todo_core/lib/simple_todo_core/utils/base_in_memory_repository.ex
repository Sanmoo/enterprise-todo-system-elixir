defmodule SimpleTodoCore.Utils.BaseInMemoryRepository do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      use Agent

      @behaviour opts[:repository]

      @impl opts[:repository]
      def create(entity_struct) do
        repo_list = Agent.get(__MODULE__, &(&1))
        next_id = case length(repo_list) do
          0 -> 0
          _ ->
            [ last_entity | _ ] = repo_list
            last_entity.id + 1
        end

        entity_struct = Map.put(entity_struct, :id, next_id)
        Agent.update(__MODULE__, &[entity_struct | &1])
        {:ok, entity_struct}
      end

      @impl opts[:repository]
      def find_all(), do: Agent.get(__MODULE__, &(&1))

      @impl opts[:repository]
      def update(entity) do
        index = find_index(entity.id)
        Agent.update(__MODULE__, fn entity_list ->
          List.update_at(entity_list, index, fn _ -> entity end)
        end)
      end

      @impl opts[:repository]
      def destroy(id) do
        index = find_index(id)
        Agent.update(__MODULE__, fn entity_list ->
          List.delete_at(entity_list, index)
        end)
      end

      @impl opts[:repository]
      def find(id) do
        case find_index(id) do
          nil -> nil
          index -> Enum.at(Agent.get(__MODULE__, &(&1)), index)
        end
      end

      defp find_index(entity_id) do
        Agent.get(__MODULE__, &(&1)) |> Enum.find_index(fn entity -> entity.id == entity_id end)
      end

      def start_link(initial_value) do
        Agent.start_link(fn -> initial_value end, name: __MODULE__)
      end
    end
  end
end
