ExUnit.start()

defmodule TestHelpers do
  def clean_whitespace(string) do
    whitespace = ~r/^\s*|\s*$/

    string
    |> String.split("\n")
    |> Enum.map(&Regex.replace(whitespace, &1, ""))
    |> Enum.join("")
  end
end
