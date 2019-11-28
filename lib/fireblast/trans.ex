defmodule Fireblast.Trans do
  import Fireblast
  import Fireblast.Util

  def process_children(children, acc) do
    children
    |> prepare_children()
    |> IO.inspect()

    # {new_children, %{elements: elements, }}
    %{iolist: children_iolist, dynamic: dynamic} =
      children
      |> Enum.reduce(
        %{env: acc.env, iolist: [], dynamic: []},
        &Fireblast.Iolist.to_iolist/2
      )

    %{iolist: children_iolist, dynamic: dynamic ++ acc.dynamic}
  end

  defp prepare_children(children) do
    IO.puts("here")
    fun = fn el, acc -> {IO.inspect(el), acc} end
    {new_children, _} = walk_ex_xml(children, [], fun)
    new_children
  end

  def render(%{children: children}) do
    IO.inspect(children, label: :children)
    ~x(<div>#{children}</div>)
  end
end
