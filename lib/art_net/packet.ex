defmodule ArtNet.Packet do
  @preamble "Art-Net\0"
  @protocol_version 14

  defp opcode_to_module(opcode) when is_integer(opcode) do
    case opcode do
      0x2000 -> ArtNet.Packet.ArtPoll
      0x5000 -> ArtNet.Packet.ArtDmx
    end
  end

  def decode(<<
        @preamble,
        op_code::integer-little-16,
        @protocol_version::integer-16,
        inner::binary
      >>) do
    packet_type = opcode_to_module(op_code)
    packet_type.decode(inner)
  end
end
