defmodule Fireblast.Scoreboard do
  use Fireblast

  def render(%{attributes: %{"class_name" => class_name, "scores" => scores}}) do
    ~x(<>
        #{
      Enum.map(scores, fn {key, value} ->
        ~x(<div class=#{class_name}>#{key} -> #{value}</div>)
      end)
    }
      </>
    )
  end
end
