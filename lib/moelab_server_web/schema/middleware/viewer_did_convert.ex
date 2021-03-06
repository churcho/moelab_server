defmodule MoelabServerWeb.Schema.Middleware.ViewerDidConvert do
  @behaviour Absinthe.Middleware

  def call(%{value: nil} = resolution, _) do
    %{resolution | value: false}
  end

  def call(%{value: []} = resolution, _) do
    %{resolution | value: false}
  end

  def call(%{value: [_]} = resolution, _) do
    %{resolution | value: true}
  end
end
