defmodule ExxHtml.MyCounter do
  use ExxHtml

  def render(%{attributes: %{"count" => count}}) do
    ~x(<div>#{count}</div>)
  end
end
