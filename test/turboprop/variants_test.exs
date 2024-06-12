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

    test "should work with nested arrays" do
      menu =
        component(%{
          base: ["base--styles-1", ["base--styles-2", ["base--styles-3"]]],
          slots: %{item: ["slots--item-1", ["slots--item-2", ["slots--item-3"]]]},
          variants: %{
            color: %{
              primary: %{
                item: ["item--color--primary-1", ["item--color--primary-2", ["item--color--primary-3"]]]
              }
            }
          }
        })

      base = resolve(menu, :base)
      item = resolve(menu, color: :primary, slot: :item)

      assert base == "base--styles-1 base--styles-2 base--styles-3"
      assert item == "slots--item-1 slots--item-2 slots--item-3 item--color--primary-1 item--color--primary-2 item--color--primary-3"

      popover =
        component(%{
          variants: %{
            is_open: %{
              true: ["isOpen--true-1", ["isOpen--true-2", ["isOpen--true-3"]]],
              false: ["isOpen--false-1", ["isOpen--false-2", ["isOpen--false-3"]]]
            }
          }
        })

      popover_open = resolve(popover, is_open: true)
      assert popover_open == "isOpen--true-1 isOpen--true-2 isOpen--true-3"

      popover_closed = resolve(popover, is_open: false)
      assert popover_closed == "isOpen--false-1 isOpen--false-2 isOpen--false-3"
    end
  end

  describe "compound variants" do
    test "should work with compound variants" do
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
          },
          compound_variants: [
            %{
              is_big: true,
              color: "red",
              class: "bg-red-500"
            }
          ]
        })

      result = resolve(h1, is_big: true, color: "red")
      assert result == "font-bold text-red-500 text-5xl bg-red-500"
    end
  end

  describe "default variants" do
    test "should support false only variant -- default variant" do
      h1 =
        component(%{
          base: "text-3xl",
          variants: %{
            bool: %{
              false: "truncate"
            }
          },
          default_variants: [
            bool: true
          ]
        })

      assert resolve(h1) == "text-3xl"
      assert resolve(h1, bool: true) == "text-3xl"
      assert resolve(h1, bool: false) == "text-3xl truncate"
      assert resolve(h1, bool: nil) == "text-3xl"
    end

    test "should support boolean variants -- default variants" do
      h1 =
        component(%{
          base: "text-3xl",
          variants: %{
            bool: %{
              true: "underline",
              false: "truncate"
            }
          },
          default_variants: [
            bool: true
          ]
        })

      assert resolve(h1) == "text-3xl underline"
      assert resolve(h1, bool: true) == "text-3xl underline"
      assert resolve(h1, bool: false) == "text-3xl truncate"
      assert resolve(h1, bool: nil) == "text-3xl underline"
    end
  end

  describe "slots" do
    test "should work with slots -- default variants" do
      menu =
        component(%{
          base: "text-3xl font-bold underline",
          slots: %{
            title: "text-2xl",
            item: "text-xl",
            list: "list-none",
            wrapper: "flex flex-col"
          },
          variants: %{
            color: %{
              primary: "color--primary",
              secondary: %{
                title: "color--primary-title",
                item: "color--primary-item",
                list: "color--primary-list",
                wrapper: "color--primary-wrapper"
              }
            },
            size: %{
              xs: "size--xs",
              sm: "size--sm",
              md: %{
                title: "size--md-title"
              }
            },
            is_disabled: %{
              true: %{
                title: "disabled--title"
              },
              false: %{
                item: "enabled--item"
              }
            }
          },
          default_variants: [
            color: "primary",
            size: "sm",
            is_disabled: false
          ]
        })

      base = resolve(menu)
      title = resolve(menu, slot: :title)
      item = resolve(menu, slot: :item)
      list = resolve(menu, slot: :list)
      wrapper = resolve(menu, slot: :wrapper)

      assert base == "text-3xl font-bold underline color--primary size--sm"
      assert title == "text-2xl"
      assert item == "text-xl enabled--item"
      assert list == "list-none"
      assert wrapper == "flex flex-col"
    end

    test "should work with slots -- default variants -- custom class & className" do
      menu =
        component(%{
          slots: %{
            base: "text-3xl font-bold underline",
            title: "text-2xl",
            item: "text-xl",
            list: "list-none",
            wrapper: "flex flex-col"
          },
          variants: %{
            color: %{
              primary: %{base: "bg-blue-500"},
              secondary: %{
                title: "text-white",
                item: "bg-purple-100",
                list: "bg-purple-200",
                wrapper: "bg-transparent"
              }
            },
            size: %{
              xs: %{base: "text-xs"},
              sm: %{base: "text-sm"},
              md: %{title: "text-md"}
            },
            is_disabled: %{
              true: %{title: "opacity-50"},
              false: %{item: "opacity-100"}
            }
          },
          default_variants: [
            color: "primary",
            size: "sm",
            is_disabled: false
          ]
        })

      assert resolve(menu, slot: :base, class: "text-lg") == "font-bold underline bg-blue-500 text-lg"
      assert resolve(menu, slot: :title, class: "text-2xl") == "text-2xl"
      assert resolve(menu, slot: :item, class: "text-sm") == "opacity-100 text-sm"
      assert resolve(menu, slot: :list, class: "bg-blue-50") == "list-none bg-blue-50"
      assert resolve(menu, slot: :wrapper, class: "flex-row") == "flex flex-row"
    end

    test "should work with slots -- custom variants" do
      menu =
        component(%{
          base: "text-3xl font-bold underline",
          slots: %{
            title: "text-2xl",
            item: "text-xl",
            list: "list-none",
            wrapper: "flex flex-col"
          },
          variants: %{
            color: %{
              primary: "color--primary",
              secondary: %{
                base: "color--secondary-base",
                title: "color--secondary-title",
                item: "color--secondary-item",
                list: "color--secondary-list",
                wrapper: "color--secondary-wrapper"
              }
            },
            size: %{
              xs: "size--xs",
              sm: "size--sm",
              md: %{
                title: "size--md-title"
              }
            },
            is_disabled: %{
              true: %{
                title: "disabled--title"
              },
              false: %{
                item: "enabled--item"
              }
            }
          },
          default_variants: [
            color: "primary",
            size: "sm",
            is_disabled: false
          ]
        })

      base = resolve(menu, color: "secondary", size: "md", slot: :base)
      title = resolve(menu, color: "secondary", size: "md", slot: :title)
      item = resolve(menu, color: "secondary", size: "md", slot: :item)
      list = resolve(menu, color: "secondary", size: "md", slot: :list)
      wrapper = resolve(menu, color: "secondary", size: "md", slot: :wrapper)

      assert base == "text-3xl font-bold underline color--secondary-base"
      assert title == "text-2xl color--secondary-title size--md-title"
      assert item == "text-xl color--secondary-item enabled--item"
      assert list == "list-none color--secondary-list"
      assert wrapper == "flex flex-col color--secondary-wrapper"
    end

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
