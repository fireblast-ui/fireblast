defmodule Fireblast.Trans do
  import Fireblast
  import Fireblast.Util

  def process_children(children, acc) do
    # {new_children, %{elements: elements, }}
    %{iolist: children_iolist, dynamic: dynamic} =
      children
      |> prepare_children()
      |> Enum.reduce(
        %{env: acc.env, iolist: [], dynamic: []},
        &Fireblast.Iolist.to_iolist/2
      )

    %{iolist: children_iolist, dynamic: dynamic ++ acc.dynamic}
  end

  defp prepare_children(children) do
    fun = fn el, acc -> {el, acc} end
    {new_children, _} = walk_ex_xml(children, [], fun) 
    new_children
  end

  def render(%{children: children}) do
    IO.inspect(children, label: :children)
    ~x(<div>#{children}</div>)
  end
end
