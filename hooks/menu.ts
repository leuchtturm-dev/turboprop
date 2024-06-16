import * as menu from "@zag-js/menu";
import { normalizeProps, spreadProps, renderPart } from "./util";
import { Component } from "./component";

export class Menu extends Component<menu.Context, menu.Api> {
  initService(context: menu.Context) {
    return menu.machine(context);
  }

  initApi() {
    return menu.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["trigger", "positioner", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);

    this.itemGroupLabels().forEach((label) => {
      console.log(label.dataset.for);
      spreadProps(label, this.api.getItemGroupLabelProps({ htmlFor: label.dataset.for! }));
    });

    this.itemGroups().forEach((group) => {
      spreadProps(group, this.api.getItemGroupProps({ id: group.dataset.id! }));
    });

    this.separators().forEach((separator) => spreadProps(separator, this.api.getSeparatorProps()));

    this.items().forEach((item) => {
      spreadProps(item, this.api.getItemProps({ value: item.dataset.id! }));
    });
  }

  itemGroupLabels() {
    return Array.from(this.el.querySelectorAll("[data-part='item-group-label']")) as HTMLElement[];
  }

  itemGroups() {
    return Array.from(this.el.querySelectorAll("[data-part='item-group']")) as HTMLElement[];
  }

  separators() {
    return Array.from(this.el.querySelectorAll("[data-part='separator']")) as HTMLElement[];
  }

  items() {
    return Array.from(this.el.querySelectorAll("[data-part='item']")) as HTMLElement[];
  }
}

export const MenuHook = {
  mounted() {
    this.context = { id: this.el.id };
    this.menu = new Menu(this.el, this.context);
    this.menu.init();
  },

  updated() {
    this.menu.render();
  },

  beforeDestroy() {
    this.menu.destroy();
  },
};
