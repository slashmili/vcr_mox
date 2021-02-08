defmodule VcrMox.FixtureTest do
  use ExUnit.Case
  alias VcrMox.Fixture

  import Mox
  setup :verify_on_exit!

  describe "fixture_exists?/1" do
    test "concatenates correct path" do
      assert Fixture.fixture_exists?("0001-test")
    end
  end
end
