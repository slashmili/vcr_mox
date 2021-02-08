defmodule VcrMox.Adaptor.HTTPoison do
  alias VcrMox.Fixture
  require ExUnit.Assertions

  def mock(fixture_name, opts) do
    [fixture] = Fixture.read!(fixture_name, opts)

    Mox.expect(VcrMox.MockHTTPoison, :get, fn request_get_url ->
      fixture_request_url = fixture.request.url
      ExUnit.Assertions.assert(request_get_url == fixture_request_url)
      from_fixture(fixture)
    end)
  end

  def mock_with_real_call(fixture_name, opts) do
    Mox.expect(VcrMox.MockHTTPoison, :get, fn get_url ->
      response = HTTPoison.get(get_url)

      response
      |> to_fixture()
      |> Fixture.store(fixture_name, opts)

      response
    end)
  end

  defp to_fixture({:ok, response}) do
    %{
      request: %{
        body: response.request.body,
        headers: Enum.into(response.request.headers, %{}),
        method: response.request.method,
        options: response.request.options,
        params: response.request.params,
        url: response.request_url
      },
      response: %{
        binary: false,
        body: response.body,
        headers: Enum.into(response.headers, %{}),
        status_code: response.status_code,
        type: response.status_code
      }
    }
  end

  defp from_fixture(fixture) do
    {:ok,
     %HTTPoison.Response{
       body: fixture.response.body,
       headers: Enum.into(fixture.response.headers, []),
       request: %HTTPoison.Request{
         body: fixture.request.body,
         headers: Enum.into(fixture.request.headers, []),
         method: fixture.request.method,
         options: [],
         params: %{},
         url: fixture.request.url
       },
       request_url: fixture.request.url,
       status_code: fixture.response.status_code
     }}
  end
end
