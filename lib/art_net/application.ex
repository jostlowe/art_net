defmodule ArtNet.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # The server recieveing UDP frames and decoding them
      ArtNet.Server,

      # A Registry for keeping subscribers
      {Registry, keys: :duplicate, name: ArtNet.SubscriberRegistry}
    ]

    opts = [strategy: :one_for_one, name: ArtNet.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
