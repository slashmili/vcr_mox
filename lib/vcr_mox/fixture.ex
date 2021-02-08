defmodule VcrMox.Fixture do
  @fixture_prefix "test/fixtures/"

  def fixture_exists?(name) do
    name
    |> fixture_file_path([])
    |> File.exists?()
  end

  def fixture_file_path(name, _opts) do
    "#{@fixture_prefix}#{name}.json"
  end

  def store(fixture_data, fixture_name, opts) do
    File.mkdir_p!(@fixture_prefix)
    append(fixture_file_path(fixture_name, opts), fixture_data)
  end

  def read!(fixture_name, opts) do
    fixture_name
    |> fixture_file_path(opts)
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(&to_map_with_atom_keys/1)
  end

  defp append(fixture_file_path, fixture_data) do
    current_fixture_data = try_to_read(fixture_file_path)
    fixture_data = current_fixture_data ++ [fixture_data]
    File.write(fixture_file_path, Jason.encode!(fixture_data, pretty: true))
  end

  defp try_to_read(fixture_file_path) do
    case File.read(fixture_file_path) do
      {:ok, content} ->
        Jason.decode!(content)

      {:error, :enoent} ->
        []
    end
  end

  defp to_map_with_atom_keys(map) do
    %{
      request: %{
        body: map["request"]["body"],
        headers: map["request"]["headers"],
        method: String.to_atom(map["request"]["method"]),
        options: map["request"]["options"],
        params: map["request"]["params"],
        url: map["request"]["url"]
      },
      response: %{
        binary: map["response"]["binary"],
        body: map["response"]["body"],
        headers: map["response"]["headers"],
        status_code: map["response"]["status_code"],
        type: map["response"]["type"]
      }
    }
  end
end
