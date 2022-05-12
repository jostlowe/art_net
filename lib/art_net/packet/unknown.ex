defmodule ArtNet.Packet.Unknown do
  def decode(<<_binary>>) do
    # Unknown packet. Don't decode anything
    nil
  end
end
