defmodule SimpleTodoCore.Entities.Base do
  defmacro __using__(_) do
    quote do
      import Ecto.Changeset
      alias __MODULE__

      def validate(new_state, previous_state \\ %__MODULE__{}) do
        case validations(previous_state, Map.from_struct(new_state)).errors do
          [] -> :ok
          errors -> {:error, errors}
        end
      end
    end
  end
end
