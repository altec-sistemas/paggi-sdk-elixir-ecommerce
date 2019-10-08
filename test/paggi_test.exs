defmodule PaggiTest do
  use ExUnit.Case
  doctest Paggi

  describe "Lib initialized" do
    test "so can retrieve environment variabe" do
      assert Paggi.get_env({:system, "PAGGI_ENVIRONMENT"}) == System.get_env("PAGGI_ENVIRONMENT")
    end

    test "so Paggi can retrieve partner_id" do
      assert not is_nil(Paggi.get_partner_id())
    end
  end
end
