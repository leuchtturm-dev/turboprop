import * as menu from "@zag-js/menu";
import { normalizeProps, spreadProps, renderPart } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

class Menu extends Component<menu.Context, menu.Api> {
  initService(context: menu.Context): Machine<any, any, any> {
    return menu.machine(context);
  }

  initApi() {
    return menu.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["trigger", "positioner", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);
    this.renderItemGroupLabels();
    this.renderItemGroups();
    this.renderItems();
    this.renderSeparators();
  }

  renderItemGroupLabels() {
    for (const itemGroupLabel of this.el.querySelectorAll<HTMLElement>("[data-part='item-group-label']")) {
      const htmlFor = itemGroupLabel.getAttribute("for");
      if (!htmlFor) {
        console.error("Missing `for` attribute on item group label.");
        return;
      }
      spreadProps(itemGroupLabel, this.api.getItemGroupLabelProps({ htmlFor }));
    }
  }

  renderItemGroups() {
    for (const itemGroup of this.el.querySelectorAll<HTMLElement>("[data-part='item-group']")) {
      const id = itemGroup.getAttribute("id");
      if (!id) {
        console.error("Missing `id` attribute on item group.");
        return;
      }
      spreadProps(itemGroup, this.api.getItemGroupProps({ id }));
    }
  }

  renderItems() {
    for (const item of this.el.querySelectorAll<HTMLElement>("[data-part='item']")) {
      const value = item.dataset.value;
      if (!value) {
        console.error("Missing `data-value` attribute on item.");
        return;
      }
      spreadProps(item, this.api.getItemProps({ value }));
    }
  }
  renderSeparators() {
    for (const separator of this.el.querySelectorAll<HTMLElement>("[data-part='separator']"))
      spreadProps(separator, this.api.getSeparatorProps());
  }
}

export interface MenuHook extends ViewHook {
  menu: Menu;
  context: { id: string };
}

export default {
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
} as MenuHook;
