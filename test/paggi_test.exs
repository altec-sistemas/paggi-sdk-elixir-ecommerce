defmodule PaggiTest do
  use ExUnit.Case
  doctest Paggi

  setup do
    Paggi.init_ets()
    Paggi.configure("PAGGI_VERSION", "v1")
  end

  describe "Lib initialized" do
    test "so can retrieve environment variabe" do
      assert Paggi.get_env({:system, "PAGGI_ENVIRONMENT"}) == System.get_env("PAGGI_ENVIRONMENT")
    end

    test "so can retrieve environment variabe from ETS" do
      assert Paggi.get_env({:ets, "PAGGI_VERSION"}) == System.get_env("PAGGI_VERSION")
    end

    test "so can retrieve partner_id" do
      assert not is_nil(Paggi.get_partner_id())
    end
  end
end
