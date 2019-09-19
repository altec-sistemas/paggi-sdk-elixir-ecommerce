defmodule Paggi.Resource do
  defmacro __using__(_) do
    quote do
      use Paggi.Macros.ResponseManagement

      Module.register_attribute __MODULE__, :resource, accumulate: true, persist: false
      Module.put_attribute(__MODULE__, :resource, String.downcase(List.last(Module.split(__MODULE__))))

      def get_resource_name(), do: @resource
    end
  end
end
