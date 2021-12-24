defmodule GenReport do
  alias GenReport.Parser

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> build_report()
  end

  defp build_report(freelas) do
    freelas = Enum.map(freelas, &parse_freela/1)

    all_hours = calc_people_all_hours(freelas)
    hours_per_month = calc_people_hours_per_month(freelas)
    hours_per_year = calc_people_hours_per_year(freelas)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp parse_freela([name, hours, day, month, year]),
    do: %{name: name, hours: hours, day: day, month: month, year: year}

  defp calc_people_all_hours(freelas) do
    freelas
    |> Enum.reduce(%{}, fn freela, acc ->
      Map.update(acc, freela.name, freela.hours, fn value -> value + freela.hours end)
    end)
  end

  defp calc_people_hours_per_month(freelas) do
    freelas
    |> Enum.group_by(& &1.name, & &1)
    |> Map.map(fn {_person, freelas} ->
      Enum.reduce(freelas, %{}, fn freela, acc ->
        Map.update(acc, freela.month, freela.hours, fn value -> value + freela.hours end)
      end)
    end)
  end

  defp calc_people_hours_per_year(freelas) do
    freelas
    |> Enum.group_by(& &1.name, & &1)
    |> Map.map(fn {_person, freelas} ->
      Enum.reduce(freelas, %{}, fn freela, acc ->
        Map.update(acc, freela.year, freela.hours, fn value -> value + freela.hours end)
      end)
    end)
  end
end
