defmodule Fireblast.Trans do
  import Fireblast

  def pre_process_children(children) do
    children
  end

  def render(%{children: children}) do
    IO.inspect(children, label: :children)
    ~x(<div>#{children}</div>)
  end
end
