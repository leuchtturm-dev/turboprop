defmodule Turboprop.VariantsTest do
  use ExUnit.Case, async: true

  import Turboprop.Variants
  alias Turboprop.Cache

  doctest Turboprop.Variants

  setup do
    Cache.create_table()
    :ok
  end

  describe "basic" do
    test "should return base styles for h1" do
      h1 =
        component(%{
          base: "text-3xl font-bold"
        })

      assert variant(h1, :base) == "text-3xl font-bold"
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

      result = variant(h1, is_big: true, color: :blue)
      assert result == "font-bold text-blue-500 text-5xl"
    end

    test "should work with custom class" do
      h1 =
        component(%{
          base: "text-3xl font-bold"
        })

      assert variant(h1, class: "text-xl") == "font-bold text-xl"
    end

    test "should work without anything" do
      styles = component(%{})
      result = variant(styles, [])
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

      result = variant(h1, color: "green", is_underline: false)
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

      assert variant(h1) == "text-3xl truncate"
      assert variant(h1, bool: true) == "text-3xl underline"
      assert variant(h1, bool: false) == "text-3xl truncate"
      assert variant(h1, bool: nil) == "text-3xl truncate"
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

      assert variant(h1) == "text-3xl truncate"
      assert variant(h1, bool: true) == "text-3xl"
      assert variant(h1, bool: false) == "text-3xl truncate"
      assert variant(h1, bool: nil) == "text-3xl truncate"
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

      assert variant(h1) == "text-3xl"
      assert variant(h1, bool: true) == "text-3xl underline"
      assert variant(h1, bool: false) == "text-3xl"
      assert variant(h1, bool: nil) == "text-3xl"
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

      base = variant(menu, :base)
      item = variant(menu, color: :primary, slot: :item)

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

      popover_open = variant(popover, is_open: true)
      assert popover_open == "isOpen--true-1 isOpen--true-2 isOpen--true-3"

      popover_closed = variant(popover, is_open: false)
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

      result = variant(h1, is_big: true, color: "red")
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

      assert variant(h1) == "text-3xl"
      assert variant(h1, bool: true) == "text-3xl"
      assert variant(h1, bool: false) == "text-3xl truncate"
      assert variant(h1, bool: nil) == "text-3xl"
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

      assert variant(h1) == "text-3xl underline"
      assert variant(h1, bool: true) == "text-3xl underline"
      assert variant(h1, bool: false) == "text-3xl truncate"
      assert variant(h1, bool: nil) == "text-3xl underline"
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

      base = variant(menu)
      title = variant(menu, slot: :title)
      item = variant(menu, slot: :item)
      list = variant(menu, slot: :list)
      wrapper = variant(menu, slot: :wrapper)

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

      assert variant(menu, slot: :base, class: "text-lg") == "font-bold underline bg-blue-500 text-lg"
      assert variant(menu, slot: :title, class: "text-2xl") == "text-2xl"
      assert variant(menu, slot: :item, class: "text-sm") == "opacity-100 text-sm"
      assert variant(menu, slot: :list, class: "bg-blue-50") == "list-none bg-blue-50"
      assert variant(menu, slot: :wrapper, class: "flex-row") == "flex flex-row"
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

      base = variant(menu, color: "secondary", size: "md", slot: :base)
      title = variant(menu, color: "secondary", size: "md", slot: :title)
      item = variant(menu, color: "secondary", size: "md", slot: :item)
      list = variant(menu, color: "secondary", size: "md", slot: :list)
      wrapper = variant(menu, color: "secondary", size: "md", slot: :wrapper)

      assert base == "text-3xl font-bold underline color--secondary-base"
      assert title == "text-2xl color--secondary-title size--md-title"
      assert item == "text-xl color--secondary-item enabled--item"
      assert list == "list-none color--secondary-list"
      assert wrapper == "flex flex-col color--secondary-wrapper"
    end

    test "should work with slots -- custom variants -- custom class" do
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
              md: %{
                base: "text-md",
                title: "text-md"
              }
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

      assert variant(menu, slot: :base, class: "text-xl", color: "secondary", size: "md") == "font-bold underline text-xl"
      assert variant(menu, slot: :title, class: "text-2xl", color: "secondary", size: "md") == "text-white text-2xl"
      assert variant(menu, slot: :item, class: "bg-purple-50", color: "secondary", size: "md") == "text-xl opacity-100 bg-purple-50"
      assert variant(menu, slot: :list, class: "bg-purple-100", color: "secondary", size: "md") == "list-none bg-purple-100"
      assert variant(menu, slot: :wrapper, class: "bg-purple-900 flex-row", color: "secondary", size: "md") == "flex bg-purple-900 flex-row"
    end

    test "should work with slots and compound variants" do
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
              true: %{title: "disabled--title"},
              false: %{item: "enabled--item"}
            }
          },
          default_variants: [
            color: "primary",
            size: "sm",
            is_disabled: false
          ],
          compound_variants: [
            %{
              color: "secondary",
              size: "md",
              class: %{
                base: "compound--base",
                title: "compound--title",
                item: "compound--item",
                list: "compound--list",
                wrapper: "compound--wrapper"
              }
            }
          ]
        })

      base = variant(menu, slot: :base, color: "secondary", size: "md")
      title = variant(menu, slot: :title, color: "secondary", size: "md")
      item = variant(menu, slot: :item, color: "secondary", size: "md")
      list = variant(menu, slot: :list, color: "secondary", size: "md")
      wrapper = variant(menu, slot: :wrapper, color: "secondary", size: "md")

      assert base == "text-3xl font-bold underline color--secondary-base compound--base"
      assert title == "text-2xl color--secondary-title size--md-title compound--title"
      assert item == "text-xl color--secondary-item enabled--item compound--item"
      assert list == "list-none color--secondary-list compound--list"
      assert wrapper == "flex flex-col color--secondary-wrapper compound--wrapper"
    end

    test "should support slot level variant overrides" do
      menu =
        component(%{
          base: "text-3xl",
          slots: %{
            title: "text-2xl"
          },
          variants: %{
            color: %{
              primary: %{
                base: "color--primary-base",
                title: "color--primary-title"
              },
              secondary: %{
                base: "color--secondary-base",
                title: "color--secondary-title"
              }
            }
          },
          default_variants: [
            color: "primary"
          ]
        })

      # variant styles for base and title slots using default and overridden variants
      base_default = variant(menu, slot: :base)
      title_default = variant(menu, slot: :title)
      base_secondary = variant(menu, slot: :base, color: "secondary")
      title_secondary = variant(menu, slot: :title, color: "secondary")

      assert base_default == "text-3xl color--primary-base"
      assert title_default == "text-2xl color--primary-title"
      assert base_secondary == "text-3xl color--secondary-base"
      assert title_secondary == "text-2xl color--secondary-title"
    end
  end

  describe "compound slots" do
    test "should support slot level variant overrides - compoundSlots" do
      menu =
        component(%{
          base: "text-3xl",
          slots: %{
            title: "text-2xl",
            subtitle: "text-xl"
          },
          variants: %{
            color: %{
              primary: %{
                base: "color--primary-base",
                title: "color--primary-title",
                subtitle: "color--primary-subtitle"
              },
              secondary: %{
                base: "color--secondary-base",
                title: "color--secondary-title",
                subtitle: "color--secondary-subtitle"
              }
            }
          },
          compound_slots: [
            %{
              slots: [:title, :subtitle],
              color: "secondary",
              class: "truncate"
            }
          ],
          default_variants: [
            color: "primary"
          ]
        })

      # Testing default variant application
      assert variant(menu, slot: :base) == "text-3xl color--primary-base"
      assert variant(menu, slot: :title) == "text-2xl color--primary-title"
      assert variant(menu, slot: :subtitle) == "text-xl color--primary-subtitle"

      # Testing secondary variant application with compound slot effect
      assert variant(menu, slot: :base, color: "secondary") == "text-3xl color--secondary-base"
      assert variant(menu, slot: :title, color: "secondary") == "text-2xl color--secondary-title truncate"
      assert variant(menu, slot: :subtitle, color: "secondary") == "text-xl color--secondary-subtitle truncate"
    end

    test "should support slot level variant and array variants overrides - compoundSlots" do
      menu =
        component(%{
          slots: %{
            base: "flex flex-wrap",
            cursor: ["absolute", "flex", "overflow-visible"]
          },
          variants: %{
            size: %{
              xs: %{},
              sm: %{}
            }
          },
          compound_slots: [
            %{
              slots: [:base],
              size: [:xs, :sm],
              class: "w-7 h-7 text-xs"
            }
          ]
        })

      assert variant(menu, slot: :base) == "flex flex-wrap"
      assert variant(menu, slot: :cursor) == "absolute flex overflow-visible"
      assert variant(menu, slot: :base, size: :xs) == "flex flex-wrap w-7 h-7 text-xs"
      assert variant(menu, slot: :base, size: :sm) == "flex flex-wrap w-7 h-7 text-xs"
    end

    test "should not override the default classes when the variant doesn't match - compoundSlots" do
      tabs =
        component(%{
          slots: %{
            base: "inline-flex",
            tab_list: ["flex"],
            tab: ["z-0", "w-full", "px-3", "py-1", "flex", "group", "relative"],
            tab_content: ["relative", "z-10", "text-inherit", "whitespace-nowrap"],
            cursor: ["absolute", "z-0", "bg-white"],
            panel: ["py-3", "px-1", "outline-none"]
          },
          variants: %{
            variant: %{
              solid: %{},
              light: %{},
              underlined: %{},
              bordered: %{}
            },
            color: %{
              default: %{},
              primary: %{},
              secondary: %{},
              success: %{},
              warning: %{},
              danger: %{}
            },
            size: %{
              sm: %{
                tab_list: "rounded-md",
                tab: "h-7 text-xs rounded-sm",
                cursor: "rounded-sm"
              },
              md: %{
                tab_list: "rounded-md",
                tab: "h-8 text-sm rounded-sm",
                cursor: "rounded-sm"
              },
              lg: %{
                tab_list: "rounded-lg",
                tab: "h-9 text-md rounded-md",
                cursor: "rounded-md"
              }
            },
            radius: %{
              none: %{
                tab_list: "rounded-none",
                tab: "rounded-none",
                cursor: "rounded-none"
              },
              sm: %{
                tab_list: "rounded-md",
                tab: "rounded-sm",
                cursor: "rounded-sm"
              },
              md: %{
                tab_list: "rounded-md",
                tab: "rounded-sm",
                cursor: "rounded-sm"
              },
              lg: %{
                tab_list: "rounded-lg",
                tab: "rounded-md",
                cursor: "rounded-md"
              },
              full: %{
                tab_list: "rounded-full",
                tab: "rounded-full",
                cursor: "rounded-full"
              }
            }
          },
          default_variants: [
            color: "default",
            variant: "solid",
            size: "md"
          ],
          compound_slots: [
            %{
              variant: "underlined",
              slots: [:tab, :tab_list, :cursor],
              class: ["rounded-none"]
            }
          ]
        })

      assert variant(tabs, slot: :tab) == "z-0 w-full px-3 py-1 flex group relative h-8 text-sm rounded-sm"
      assert variant(tabs, slot: :tab_list) == "flex rounded-md"
      assert variant(tabs, slot: :cursor) == "absolute z-0 bg-white rounded-sm"
    end

    test "should work with compound slots -- without variants" do
      pagination =
        component(%{
          slots: %{
            base: "flex flex-wrap relative gap-1 max-w-fit",
            item: "",
            prev: "",
            next: "",
            cursor: ["absolute", "flex", "overflow-visible"]
          },
          compound_slots: [
            %{
              slots: [:item, :prev, :next],
              class: ["flex", "flex-wrap", "truncate"]
            }
          ]
        })

      assert variant(pagination, slot: :base) == "flex flex-wrap relative gap-1 max-w-fit"
      assert variant(pagination, slot: :item) == "flex flex-wrap truncate"
      assert variant(pagination, slot: :prev) == "flex flex-wrap truncate"
      assert variant(pagination, slot: :next) == "flex flex-wrap truncate"
      assert variant(pagination, slot: :cursor) == "absolute flex overflow-visible"
    end

    test "should work with compound slots -- with a single variant -- defaultVariants" do
      pagination =
        component(%{
          slots: %{
            base: "flex flex-wrap relative gap-1 max-w-fit",
            item: "",
            prev: "",
            next: "",
            cursor: ["absolute", "flex", "overflow-visible"]
          },
          variants: %{
            size: %{
              xs: %{},
              sm: %{},
              md: %{},
              lg: %{},
              xl: %{}
            }
          },
          compound_slots: [
            %{
              slots: [:item, :prev, :next],
              class: ["flex", "flex-wrap", "truncate"]
            },
            %{
              slots: [:item, :prev, :next],
              size: "xs",
              class: "w-7 h-7 text-xs"
            }
          ],
          default_variants: [
            size: "xs"
          ]
        })

      assert variant(pagination, slot: :base) == "flex flex-wrap relative gap-1 max-w-fit"
      assert variant(pagination, slot: :item) == "flex flex-wrap truncate w-7 h-7 text-xs"
      assert variant(pagination, slot: :prev) == "flex flex-wrap truncate w-7 h-7 text-xs"
      assert variant(pagination, slot: :next) == "flex flex-wrap truncate w-7 h-7 text-xs"
      assert variant(pagination, slot: :cursor) == "absolute flex overflow-visible"
    end

    test "should work with compound slots -- with a single variant -- prop variant" do
      pagination =
        component(%{
          slots: %{
            base: "flex flex-wrap relative gap-1 max-w-fit",
            item: "",
            prev: "",
            next: "",
            cursor: ["absolute", "flex", "overflow-visible"]
          },
          variants: %{
            size: %{
              xs: %{},
              sm: %{},
              md: %{},
              lg: %{},
              xl: %{}
            }
          },
          compound_slots: [
            %{
              slots: [:item, :prev, :next],
              class: ["flex", "flex-wrap", "truncate"]
            },
            %{
              slots: [:item, :prev, :next],
              size: "xs",
              class: "w-7 h-7 text-xs"
            }
          ],
          default_variants: [
            size: "sm"
          ]
        })

      assert variant(pagination, slot: :base, size: "xs") == "flex flex-wrap relative gap-1 max-w-fit"
      assert variant(pagination, slot: :item, size: "xs") == "flex flex-wrap truncate w-7 h-7 text-xs"
      assert variant(pagination, slot: :prev, size: "xs") == "flex flex-wrap truncate w-7 h-7 text-xs"
      assert variant(pagination, slot: :next, size: "xs") == "flex flex-wrap truncate w-7 h-7 text-xs"
      assert variant(pagination, slot: :cursor, size: "xs") == "absolute flex overflow-visible"
    end
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

    assert variant(menu, slot: :base) == ""
    assert variant(menu, slot: :title) == ""
    assert variant(menu, slot: :item) == ""
    assert variant(menu, slot: :list) == ""
  end
end
