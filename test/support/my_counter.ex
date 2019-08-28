defmodule Fireblast.MyCounter do
  use Fireblast

  def render(%{attributes: %{"count" => count}}) do
    ~x(<div>#{count}</div>)
  end
end
