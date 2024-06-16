import * as combobox from "@zag-js/combobox";
import { normalizeProps, renderPart, spreadProps } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";
import { proxy } from "valtio";
import { useProxy } from "valtio/utils";

type Item = { value: string; label: string };

class Combobox extends Component<combobox.Context, combobox.Api> {
  initService(context: combobox.Context): Machine<any, any, any> {
    return combobox.machine(context);
  }

  initApi() {
    return combobox.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["root", "label", "control", "input", "trigger", "positioner", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);
    this.renderItems();
  }

  renderItems() {
    for (const item of this.el.querySelectorAll<HTMLElement>("[data-part='item']")) {
      const value = item.dataset.value;
      const label = item.dataset.label;
      if (!value || !label) {
        console.error("Missing `data-value` or `data-label` attribute on item.");
        return;
      }

      spreadProps(item, this.api.getItemProps({ item: { value, label } }));
    }
  }
}

export interface ComboboxHook extends ViewHook {
  combobox: Combobox;
  items(): Item[];
  collection(): any;
  context(): combobox.Context;
}

export default {
  mounted() {
    this.combobox = new Combobox(this.el, this.context());
    this.combobox.init();
  },

  updated() {
    this.combobox.render();
  },

  beforeDestroy() {
    this.combobox.destroy();
  },

  items(): Item[] {
    return Array.from(this.el.querySelectorAll<HTMLElement>("[data-part='item']"))
      .map((item: HTMLElement) => {
        const value = item.dataset.value;
        const label = item.dataset.label;
        if (!value || !label) {
          console.error("Missing `data-value` or `data-label` attribute on item.");
          return;
        }

        return { value, label };
      })
      .filter((value) => value !== undefined) as Item[];
  },

  context(): combobox.Context {
    const initialItems = this.items();
    const state = proxy({ items: initialItems });
    const $state = useProxy(state);

    const collection = combobox.collection({
      items: $state.items,
      itemToValue: (item: Item) => item.value,
      itemToString: (item: Item) => item.label,
    });

    return {
      id: this.el.id,
      collection,
      // TODO: Figure out disabled
      disabled: false,
      readOnly: this.el.dataset.readOnly === "true" || this.el.dataset.readOnly === "",
      loopFocus: this.el.dataset.loopFocus === "true" || this.el.dataset.loopFocus === "",
      // TODO: Validation
      // inputBehavior: this.el.dataset.inputBehavior,
      // selectionBehavior: this.el.dataset.selectionBehavior,
      onOpenChange: (details: combobox.OpenChangeDetails) => {
        state.items = initialItems;
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
      onInputValueChange: (details: combobox.InputValueChangeDetails) => {
        const filtered = this.items().filter((item) => item.label.toLowerCase().includes(details.inputValue.toLowerCase()));
        state.items = filtered;

        if (this.el.dataset.onInputValueChange) {
          this.pushEvent(this.el.dataset.onInputValueChange, details);
        }
      },
      onHighlightChange: (details: combobox.HighlightChangeDetails) => {
        if (this.el.dataset.onHighlightChange) {
          this.pushEvent(this.el.dataset.onHighlightChange, details);
        }
      },
      onValueChange: (details: combobox.ValueChangeDetails) => {
        if (this.el.dataset.onValueChange) {
          this.pushEvent(this.el.dataset.onValueChange, details);
        }
      },
    };
  },
} as ComboboxHook;
