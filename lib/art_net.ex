defmodule ArtNet do
  def subscribe(universe) when is_integer(universe) do
    Registry.register(ArtNet.SubscriberRegistry, universe, nil)
  end
end
