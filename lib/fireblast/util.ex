defmodule Fireblast.Util do
  def map_to_quoted_map(map) when is_map(map) do
    do_map_to_quoted_map(map)
  end

  def compress_io_list(l) when is_list(l) do
    Enum.reduce(l, [], &do_compress_io_list/2)
    |> :lists.reverse()
  end

  defp do_map_to_quoted_map(map) when is_map(map) do
    keyword_list =
      map
      |> Enum.to_list()
      |> do_map_to_quoted_map()

    {:%{}, [], keyword_list}
  end

  defp do_map_to_quoted_map(list) when is_list(list) do
    list
    |> Enum.map(&do_map_to_quoted_map/1)
  end

  defp do_map_to_quoted_map({key, value}) do
    {key, do_map_to_quoted_map(value)}
  end

  defp do_map_to_quoted_map(other) do
    other
  end

  defp do_compress_io_list(a, [b | acc]) when is_binary(a) and is_binary(b) do
    [b <> a | acc]
  end

  defp do_compress_io_list(a, acc) do
    [a | acc]
  end
end
