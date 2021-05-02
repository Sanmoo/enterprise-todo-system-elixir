defmodule SimpleTodoCore.Repositories.Base do
  defmacro __using__([module: module]) do
    quote do
      @type error :: {:error, %{message: String.t}}

      @callback create(unquote(module).t) :: {:ok, unquote(module).t } | error
      @callback update(unquote(module).t) :: {:ok} | error
      @callback destroy(id :: integer) :: {:ok} | error
      @callback find(id :: integer) :: unquote(module).t | error | nil
      @callback find_all() :: [unquote(module).t] | error
    end
  end
end
