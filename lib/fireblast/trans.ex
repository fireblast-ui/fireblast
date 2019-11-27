defmodule Fireblast.Trans do
  import Fireblast

  def process_children(children, acc) do
    # %{iolist: children_iolist, dynamic: children_dynamic} =
    children
    |> Enum.reduce(
      %{env: acc.env, iolist: [], dynamic: acc.dynamic},
      &Fireblast.Iolist.to_iolist/2
    )
  end

  def render(%{children: children}) do
    IO.inspect(children, label: :children)
    ~x(<div>#{children}</div>)
  end
end
