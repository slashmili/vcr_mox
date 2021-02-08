defmodule VcrMoxTest do
  use ExUnit.Case
  use VcrMox
  import Mox
  setup :verify_on_exit!

  defmodule TestHTTPoison do
    def get_something(url) do
      # HTTPoison.get(url)
      VcrMox.MockHTTPoison.get(url)
    end
  end

  test "greets the world" do
    VcrMox.use_cassette "example_call", for: HTTPoison, methods: [get: 1] do
      assert {:ok, %HTTPoison.Response{} = response} =
               TestHTTPoison.get_something("https://postman-echo.com/get?foo1=bar1&foo2=bar2s")

      assert response.request.url == "https://postman-echo.com/get?foo1=bar1&foo2=bar2s"

      assert response.body ==
               "{\"args\":{\"foo1\":\"bar1\",\"foo2\":\"bar2s\"},\"headers\":{\"x-forwarded-proto\":\"https\",\"x-forwarded-port\":\"443\",\"host\":\"postman-echo.com\",\"x-amzn-trace-id\":\"Root=1-601f0f7b-311c5c1e5de086fb78135d06\",\"user-agent\":\"hackney/1.17.0\"},\"url\":\"https://postman-echo.com/get?foo1=bar1&foo2=bar2s\"}"

      assert response.headers == [
               {"Connection", "keep-alive"},
               {"Content-Length", "279"},
               {"Content-Type", "application/json; charset=utf-8"},
               {"Date", "Sat, 06 Feb 2021 21:51:55 GMT"},
               {"ETag", "W/\"117-8G5knXpfpOwGI8byyi9LjDvERKo\""},
               {"Vary", "Accept-Encoding"},
               {"set-cookie",
                "sails.sid=s%3AOovYmeRH7T8nsJLvo3NqzqjFuPP_FciQ.BJL9UGS7QpnfodayyZ1Vb1RFHUFV7dkzOdRRVMBL56A; Path=/; HttpOnly"}
             ]

      assert response.request.method == :get
      assert response.request.body == "request body"
      assert response.request.headers == [{"Content-Type", "application/json"}]

      # assert VcrMox.hello() == :world
    end
  end
end
