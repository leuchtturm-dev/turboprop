defmodule Turboprop.VariantsTest do
  use ExUnit.Case, async: true

  import Turboprop.Variants

  describe "basic" do
    test "should return base styles for h1" do
      h1 =
        component(%{
          base: "text-3xl font-bold"
        })

      assert resolve(h1, :base) == "text-3xl font-bold"
    end

    test "should work with variants" do
      h1 =
        component(%{
          base: "text-3xl font-bold",
          variants: %{
            is_big: %{
              true: "text-5xl",
              false: "text-2xl"
            },
            color: %{
              red: "text-red-500",
              blue: "text-blue-500"
            }
          }
        })

      result = resolve(h1, is_big: true, color: :blue)
      assert result == "font-bold text-blue-500 text-5xl"
    end

    test "should work with custom class" do
      h1 =
        component(%{
          base: "text-3xl font-bold"
        })

      assert resolve(h1, class: "text-xl") == "font-bold text-xl"
    end

    test "should work without anything" do
      styles = component(%{})
      result = resolve(styles, [])
      assert result == ""
    end

    test "should work with simple variants" do
      h1 =
        component(%{
          base: "text-3xl font-bold underline",
          variants: %{
            color: %{
              red: "text-red-500",
              blue: "text-blue-500",
              green: "text-green-500"
            },
            is_underline: %{
              true: "underline",
              false: "no-underline"
            }
          }
        })

      result = resolve(h1, color: "green", is_underline: false)
      assert result == "text-3xl font-bold text-green-500 no-underline"
    end

    test "should support boolean variants" do
      h1 =
        component(%{
          base: "text-3xl",
          variants: %{
            bool: %{
              true: "underline",
              false: "truncate"
            }
          }
        })

      assert resolve(h1) == "text-3xl truncate"
      assert resolve(h1, bool: true) == "text-3xl underline"
      assert resolve(h1, bool: false) == "text-3xl truncate"
      assert resolve(h1, bool: nil) == "text-3xl truncate"
    end

    test "should support false only variant" do
      h1 =
        component(%{
          base: "text-3xl",
          variants: %{
            bool: %{
              false: "truncate"
            }
          }
        })

      assert resolve(h1) == "text-3xl truncate"
      assert resolve(h1, bool: true) == "text-3xl"
      assert resolve(h1, bool: false) == "text-3xl truncate"
      assert resolve(h1, bool: nil) == "text-3xl truncate"
    end

    test "should support boolean variants -- missing false variant" do
      h1 =
        component(%{
          base: "text-3xl",
          variants: %{
            bool: %{
              true: "underline"
            }
          }
        })

      assert resolve(h1) == "text-3xl"
      assert resolve(h1, bool: true) == "text-3xl underline"
      assert resolve(h1, bool: false) == "text-3xl"
      assert resolve(h1, bool: nil) == "text-3xl"
    end

    # test "should work with nested arrays" do
    #   menu =
    #     component(%{
    #       base: ["base--styles-1", ["base--styles-2", ["base--styles-3"]]],
    #       slots: %{item: ["slots--item-1", ["slots--item-2", ["slots--item-3"]]]},
    #       variants: %{
    #         color: %{
    #           primary: %{
    #             item: ["item--color--primary-1", ["item--color--primary-2", ["item--color--primary-3"]]]
    #           }
    #         }
    #       }
    #     })
    #
    #   base = resolve(menu, :base)
    #   item = resolve(menu, :item, color: :primary)
    #
    #   assert base == "base--styles-1 base--styles-2 base--styles-3"
    #   assert item == "slots--item-1 slots--item-2 slots--item-3 item--color--primary-1 item--color--primary-2 item--color--primary-3"
    #
    #   popover =
    #     component(%{
    #       variants: %{
    #         is_open: %{
    #           true: ["isOpen--true-1", ["isOpen--true-2", ["isOpen--true-3"]]],
    #           false: ["isOpen--false-1", ["isOpen--false-2", ["isOpen--false-3"]]]
    #         }
    #       }
    #     })
    #
    #   popover_open = resolve(popover, is_open: true)
    #   assert popover_open == "isOpen--true-1 isOpen--true-2 isOpen--true-3"
    #
    #   popover_closed = resolve(popover, is_open: false)
    #   assert popover_closed == "isOpen--false-1 isOpen--false-2 isOpen--false-3"
    # end
  end

  describe "slots" do
    test "should work with empty slots" do
      menu =
        component(%{
          slots: %{
            base: "",
            title: "",
            item: "",
            list: ""
          }
        })

      assert resolve(menu, slot: :base) == ""
      assert resolve(menu, slot: :title) == ""
      assert resolve(menu, slot: :item) == ""
      assert resolve(menu, slot: :list) == ""
    end
  end
end
