import * as combobox from "@zag-js/combobox";
import { getAttributes, restoreAttributes, normalizeProps, renderPart, spreadProps } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";
import { proxy } from "valtio/vanilla";

type Item = { value: string; label: string };
type InputBehavior = "autocomplete" | "autohighlight" | "none" | undefined;
type SelectionBehavior = "clear" | "replace" | "preserve" | undefined;

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
  state: any;
  combobox: Combobox;
  attributeCache: any;
  items(): Item[];
  context(): combobox.Context;
}

export default {
  mounted() {
    this.state = proxy({
      items: this.items(),
      get collection() {
        return combobox.collection({
          items: this.items,
          itemToValue: (item: Item) => item.value,
          itemToString: (item: Item) => item.label,
        });
      },
    });

    this.combobox = new Combobox(this.el, this.context());
    this.combobox.init();
  },

  beforeUpdate() {
    const parts = ["root", "label", "control", "input", "trigger", "positioner", "content"];
    this.attributeCache = parts.map((part) => {
      return getAttributes(this.el, part);
    });
  },

  updated() {
    this.state.items = this.items();
    this.combobox.api.setCollection(this.state.collection);
    this.combobox.render();

    console.log(this.attributeCache);
    restoreAttributes(this.el, this.attributeCache);
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
    let inputBehavior: string | undefined = this.el.dataset.inputBehavior;
    const validInputBehaviors = ["autohighlight", "autocomplete", "none"] as const;

    if (inputBehavior !== undefined && !(inputBehavior in validInputBehaviors)) {
      console.error(`Invalid 'inputBehavior' specified: ${inputBehavior}. Expected 'autohighlight', 'autocomplete' or 'none'.`);
      inputBehavior = undefined;
    }

    let selectionBehavior: string | undefined = this.el.dataset.selectionBehavior;
    const validSelectionBehaviors = ["clear", "replace", "preserve"] as const;

    if (selectionBehavior !== undefined && !(selectionBehavior in validSelectionBehaviors)) {
      console.error(`Invalid 'selectionBehavior' specified: ${selectionBehavior}. Expected 'clear', 'replace' or 'preserve'.`);
      selectionBehavior = undefined;
    }

    return {
      id: this.el.id,
      collection: this.state.collection,
      disabled: this.el.dataset.disabled === "true" || this.el.dataset.disabled === "",
      readOnly: this.el.dataset.readOnly === "true" || this.el.dataset.readOnly === "",
      loopFocus: this.el.dataset.loopFocus === "true" || this.el.dataset.loopFocus === "",
      allowCustomValue: this.el.dataset.allowCustomValue === "true" || this.el.dataset.allowCustomValue === "",
      inputBehavior: inputBehavior as InputBehavior,
      selectionBehavior: selectionBehavior as SelectionBehavior,
      onOpenChange: (details: combobox.OpenChangeDetails) => {
        this.state.items = this.items();
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
      onInputValueChange: (details: combobox.InputValueChangeDetails) => {
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
