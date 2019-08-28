defmodule Fireblast.TestComponent do
  use Fireblast

  def render(%{attributes: %{"id" => id}, children: children}) do
    ~x(<div id=#{id}>#{children}</div>)
  end
end
