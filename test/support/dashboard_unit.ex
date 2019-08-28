defmodule ExxHtml.DashboardUnit do
  use ExxHtml
  def render(%{attributes: %{"data_index" => data_index}, children: children}) do
    ~x(
      <>
       <h2>#{data_index}</h2>
       #{children}
      </>
    )
  end
end
