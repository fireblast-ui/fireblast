defmodule ExxHtml do

  use Exx
  alias ExxHtml.Iolist

  defmacro __using__(_opts) do
    quote do
      require ExxHtml
      import ExxHtml
    end
  end

  def process_exx(exx, _) do
    {:safe, Iolist.to_iolist(exx)}
    |> IO.inspect()
  end
end
