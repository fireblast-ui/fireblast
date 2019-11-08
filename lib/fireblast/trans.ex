defmodule Fireblast.Trans do
  import Fireblast

  def render(%{children: children}) do
    IO.inspect(children, label: :children)
    ~x(<div>#{children}</div>)
  end
end
