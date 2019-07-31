defmodule ExxHtml.TestComponent do
  use ExxHtml

  def render(%{attributes: %{"id" => id}, children: children}) do
    ~x(<div id=#{id}>#{children}</div>)
  end
end
