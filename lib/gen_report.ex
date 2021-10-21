defmodule GenReport do
  alias GenReport.Parser

  def build(file_name) do
    file = Parser.parse_file(file_name)
    peoples = peoples_uniq(file)

    %{
      "all_hours" => all_hours_build(file, peoples),
      "hours_per_month" => hours_per_month_build(file, peoples),
      "hours_per_year" => hours_per_year_build(file, peoples)
    }
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp peoples_uniq(file) do
    file
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.uniq()
  end

  defp all_hours_build(file, peoples) do
    template =
      peoples
      |> Enum.into(%{}, &{&1, 0})

    file
    |> Enum.reduce(template, fn [name, hours, _day, _month, _year], report ->
      Map.put(report, name, report[name] + hours)
    end)
  end

  defp hours_per_month_build(file, peoples) do
    file
    |> Enum.reduce(hours_per_month_template(file, peoples), fn [name, hours, _day, month, _year],
                                                               report ->
      people = Map.get(report, name)
      people = Map.put(people, month, people[month] + hours)
      Map.put(report, name, people)
    end)
  end

  defp hours_per_month_template(file, peoples) do
    months =
      file
      |> Enum.map(&Enum.at(&1, 3))
      |> Enum.uniq()
      |> Enum.into(%{}, &{&1, 0})

    peoples
    |> Enum.into(%{}, &{&1, months})
  end

  defp hours_per_year_build(file, peoples) do
    file
    |> Enum.reduce(hours_per_year_template(file, peoples), fn [name, hours, _day, _month, year],
                                                              report ->
      people = Map.get(report, name)
      people = Map.put(people, year, people[year] + hours)
      Map.put(report, name, people)
    end)
  end

  defp hours_per_year_template(file, peoples) do
    years =
      file
      |> Enum.map(&Enum.at(&1, 4))
      |> Enum.uniq()
      |> Enum.into(%{}, &{&1, 0})

    peoples
    |> Enum.into(%{}, &{&1, years})
  end
end
