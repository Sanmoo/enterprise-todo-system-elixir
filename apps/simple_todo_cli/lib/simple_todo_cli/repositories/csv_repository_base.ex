defmodule SimpleTodoCli.Repositories.CsvRepositoryBase do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour opts[:repository]

      @impl opts[:repository]
      def create(entity_struct) do
        repo_list = load_entity_list_from_file()

        next_id =
          case length(repo_list) do
            0 ->
              0

            _ ->
              [last_entity | _] = repo_list
              last_entity.id + 1
          end

        entity_struct = Map.put(entity_struct, :id, next_id)
        dump_entity_list_to_file([entity_struct | repo_list])
        {:ok, entity_struct}
      end

      @impl opts[:repository]
      def find_all(), do: load_entity_list_from_file()

      @impl opts[:repository]
      def update(entity) do
        all = find_all()
        index = Enum.find_index(all, fn local_entity -> local_entity.id == entity.id end)
        updated_list = List.update_at(all, index, entity)
        dump_entity_list_to_file(updated_list)
      end

      @impl opts[:repository]
      def destroy(id) do
        all = find_all()
        index = Enum.find_index(all, fn local_entity -> local_entity.id == id end)
        updated_list = List.delete_at(all, index)
        dump_entity_list_to_file(updated_list)
      end

      @impl opts[:repository]
      def find(id) do
        Enum.find(find_all(), fn entity -> entity.id == id end)
      end

      defp load_entity_list_from_file() do
        File.touch(file_name())
        table_data = File.stream!(file_name()) |> CSV.decode()
        Enum.map(table_data, fn {:ok, data_list} -> entity_from_list(data_list) end)
      end

      defp dump_entity_list_to_file(entity_list) do
        file = File.open!(file_name(), [:write, :utf8])
        table_data = Enum.map(entity_list, fn entity -> list_from_entity(entity) end)
        table_data |> CSV.encode() |> Enum.each(&IO.write(file, &1))
        :ok
      end
    end
  end
end
