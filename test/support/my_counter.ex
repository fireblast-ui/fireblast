defmodule Fireblast.MyCounter do
  import Fireblast

  def render(%{attributes: %{"count" => count}}) do
    ~x(<div>#{count}</div>)
  end
end
