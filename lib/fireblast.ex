defmodule Fireblast do
  use ExXml
  alias Fireblast.Iolist

  def process_ex_xml(ex_xml, env) do
    %{iolist: iolist, dynamic: dynamic} =
      Iolist.to_iolist(ex_xml, %{env: env, dynamic: [], iolist: [], vars_count: 0})

    safe = {:safe, iolist}
    {:__block__, [], dynamic ++ [safe]}
  end
end
