defmodule ExxHtml do

  use Exx
  alias ExxHtml.Iolist

  def process_exx(exx, _) do
    {:ok, Iolist.to_iolist(exx)}
  end
end
