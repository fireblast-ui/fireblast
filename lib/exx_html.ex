defmodule ExxHtml do

  use Exx
  alias ExxHtml.Iolist

  def process_exx(exx, _) do
    {:safe, Iolist.to_iolist(exx)}
    |> IO.inspect()
  end
end
