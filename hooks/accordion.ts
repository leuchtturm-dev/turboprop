import * as accordion from "@zag-js/accordion";
import { normalizeProps, spreadProps, renderPart, getBooleanOption } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

class Accordion extends Component<accordion.Context, accordion.Api> {
  initService(context: accordion.Context): Machine<any, any, any> {
    return accordion.machine(context);
  }

  initApi() {
    return accordion.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["root"];
    for (const part of parts) renderPart(this.el, part, this.api);
    this.renderItems();
  }

  renderItems() {
    for (const item of this.el.querySelectorAll<HTMLElement>("[data-part='item']")) {
      const value = item.dataset.value;
      if (!value) {
        console.error("Missing `data-value` attribute on item.");
        return;
      }
      spreadProps(item, this.api.getItemProps({ value }));

      this.renderItemTrigger(item, value);
      this.renderItemIndicator(item, value);
      this.renderItemContent(item, value);
    }
  }

  renderItemTrigger(item: HTMLElement, value: string) {
    const itemTrigger = item.querySelector<HTMLElement>("[data-part='item-trigger']");
    if (!itemTrigger) return;
    spreadProps(itemTrigger, this.api.getItemTriggerProps({ value }));
  }

  renderItemIndicator(item: HTMLElement, value: string) {
    const itemIndicator = item.querySelector<HTMLElement>("[data-part='item-indicator']");
    if (!itemIndicator) return;
    spreadProps(itemIndicator, this.api.getItemIndicatorProps({ value }));
  }

  renderItemContent(item: HTMLElement, value: string) {
    const itemContent = item.querySelector<HTMLElement>("[data-part='item-content']");
    if (!itemContent) return;
    spreadProps(itemContent, this.api.getItemContentProps({ value }));
  }
}

export interface AccordionHook extends ViewHook {
  accordion: Accordion;
  context(): accordion.Context;
}

export default {
  mounted() {
    this.accordion = new Accordion(this.el, this.context());
    this.accordion.init();
  },

  updated() {
    this.accordion.render();
  },

  beforeDestroy() {
    this.accordion.destroy();
  },

  context(): accordion.Context {
    return {
      id: this.el.id,
      value: [""],
      disabled: getBooleanOption(this.el, "disabled"),
      multiple: getBooleanOption(this.el, "multiple"),
      collapsible: getBooleanOption(this.el, "collapsible"),
      onValueChange: (details: accordion.ValueChangeDetails) => {
        if (this.el.dataset.onValueChange) {
          this.pushEvent(this.el.dataset.onValueChange, details);
        }
      },
    };
  },
} as AccordionHook;
