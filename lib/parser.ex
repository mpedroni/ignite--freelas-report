defmodule GenReport.Parser do
  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> normalize()
  end

  defp normalize([name, hours, day, month, year]) do
    name = String.downcase(name)
    {hours, _} = Integer.parse(hours)
    {day, _} = Integer.parse(day)
    month = @months[month]
    {year, _} = Integer.parse(year)

    [name, hours, day, month, year]
  end
end
