import * as menu from "@zag-js/menu";
import { normalizeProps, spreadProps, renderPart } from "./util";

export const Menu = {
  mounted() {
    this.context = { id: this.el.id };

    this.service = menu.machine(this.context);
    this.api = menu.connect(this.service.state, this.service.send, normalizeProps);

    this.render();
    this.service.subscribe(() => {
      this.api = menu.connect(this.service.state, this.service.send, normalizeProps);
      this.render();
    });

    this.service.start();
  },

  updated() {
    this.render();
  },

  beforeDestroy() {
    this.service.stop();
  },

  itemGroupLabels() {
    return Array.from(this.el.querySelectorAll("[data-part='item-group-label']"));
  },

  itemGroups() {
    return Array.from(this.el.querySelectorAll("[data-part='item-group']"));
  },

  separators() {
    return Array.from(this.el.querySelectorAll("[data-part='separator']"));
  },

  items() {
    return Array.from(this.el.querySelectorAll("[data-part='item']"));
  },

  render() {
    parts = ["trigger", "positioner", "content"];
    parts.forEach((part) => renderPart(this.el, part, this.api));

    this.itemGroupLabels().forEach((label) => {
      console.log(label.dataset.for)
      spreadProps(label, this.api.getItemGroupLabelProps({ htmlFor: label.dataset.for }));
    });

    this.itemGroups().forEach((group) => {
      spreadProps(group, this.api.getItemGroupProps({ id: group.dataset.id }));
    });

    this.separators().forEach((separator) => spreadProps(separator, this.api.getSeparatorProps()));

    this.items().forEach((item) => {
      spreadProps(item, this.api.getItemProps({ value: item.dataset.id }));
    });
  },
};
