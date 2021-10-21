defmodule GenReport.Parser do
  @months_name %{
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
  def parse_file(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line ->
      [name, hours, day, month, year] = parse_line(line)

      [
        String.downcase(name),
        String.to_integer(hours),
        String.to_integer(day),
        Map.get(@months_name, month),
        String.to_integer(year)
      ]
    end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
  end
end
