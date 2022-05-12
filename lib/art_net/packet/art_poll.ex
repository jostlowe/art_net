defmodule ArtNet.Packet.ArtPoll do
  defstruct [:talk_to_me, :priority]

  def decode(<<
        talk_to_me::integer,
        priority::integer
      >>) do
    %__MODULE__{talk_to_me: talk_to_me, priority: priority}
  end
end
