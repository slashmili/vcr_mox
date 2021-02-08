defmodule VcrMox do
  defmacro __using__(_opts) do
  end

  defmacro use_cassette(title, opts, do: block) do
    quote do
      adaptor = Module.concat([VcrMox.Adaptor, unquote(opts)[:for]])

      if VcrMox.Fixture.fixture_exists?(unquote(title)) do
        adaptor.mock(unquote(title), unquote(opts))
      else
        adaptor.mock_with_real_call(unquote(title), unquote(opts))
      end

      unquote(block)
    end
  end
end
