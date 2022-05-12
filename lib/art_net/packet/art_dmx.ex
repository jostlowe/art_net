defmodule ArtNet.Packet.ArtDmx do
  defstruct [:sequence, :physical, :universe, :data]

  def decode(<<
        sequence::integer,
        physical::integer,
        universe::integer-little-16,
        length::integer-16,
        data::binary-size(length)
      >>) do
    %__MODULE__{
      sequence: sequence,
      physical: physical,
      universe: universe + 1,
      data: :binary.bin_to_list(data)
    }
  end
end
