defmodule ExxHtml do

  use Exx
  alias ExxHtml.Iolist

  defmacro __using__(_opts) do
    quote do
      require ExxHtml
      import ExxHtml
    end
  end

  def process_exx(exx, env) do
    %{iolist: iolist, dynamic: dynamic} = Iolist.to_iolist(exx, %{env: env, dynamic: [], iolist: [], vars_count: 0})
    safe = {:safe, iolist}
    {:__block__, [], dynamic ++ [safe]}
  end
end
