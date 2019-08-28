defmodule Fireblast.DashboardUnit do
  use Fireblast
  def render(%{attributes: %{"data_index" => data_index}, children: children}) do
    ~x(
      <>
       <h2>#{data_index}</h2>
       #{children}
      </>
    )
  end
end
