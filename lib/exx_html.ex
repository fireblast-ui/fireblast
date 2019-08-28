defmodule Fireblast do

  use Exx
  alias Fireblast.Iolist

  defmacro __using__(_opts) do
    quote do
      require Fireblast
      import Fireblast
    end
  end

  def process_exx(exx, env) do
    %{iolist: iolist, dynamic: dynamic} = Iolist.to_iolist(exx, %{env: env, dynamic: [], iolist: [], vars_count: 0})
    safe = {:safe, iolist}
    {:__block__, [], dynamic ++ [safe]}
  end
end
