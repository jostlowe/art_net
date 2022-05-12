defmodule ArtNet.Server do
  use GenServer, restart: :permanent
  alias ArtNet.Packet.{ArtDmx, ArtPoll}
  require Logger
  @artnet_port 0x1936

  ## API ===========================================================
  def start_link([]) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  ## CALLBACKS ===================================================

  @impl true
  def init(nil) do
    # Create the UDP socket we are using for ArtNet Communications
    {:ok, socket} = :gen_udp.open(@artnet_port, [:binary, {:active, true}])

    initial_state = %{
      socket: socket
    }

    {:ok, initial_state}
  end

  @doc """
  Handles incoming UDP packets, decodes them and relays
  them to any subscribers
  """
  @impl true
  def handle_info({:udp, _, _ip, _port, data}, state) do
    artnet_packet = ArtNet.Packet.decode(data)

    handle_artnet(artnet_packet)

    {:noreply, state}
  end

  def handle_artnet(%ArtDmx{universe: universe, data: data}) do
    message = {:artnet, universe, data}

    Registry.dispatch(ArtNet.SubscriberRegistry, universe, fn subscribers ->
      for {subscriber, _} <- subscribers do
        send(subscriber, message)
      end
    end)
  end

  def handle_artnet(%ArtPoll{}) do
    nil
  end
end
