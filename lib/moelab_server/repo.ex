defmodule MoelabServer.Repo do
  use Ecto.Repo,
    otp_app: :moelab_server,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
