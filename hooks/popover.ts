import * as popover from "@zag-js/popover";
import { getBooleanOption, normalizeProps, renderPart } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

class Popover extends Component<popover.Context, popover.Api> {
  initService(context: popover.Context): Machine<any, any, any> {
    return popover.machine(context);
  }

  initApi() {
    return popover.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["trigger", "positioner", "content", "title", "description", "close-trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
}

export interface PopoverHook extends ViewHook {
  popover: Popover;
  context(): popover.Context;
}

export default {
  mounted() {
    this.popover = new Popover(this.el, this.context());
    this.popover.init();
  },

  updated() {
    this.popover.render();
  },

  beforeDestroy() {
    this.popover.destroy();
  },

  context(): popover.Context {
    return {
      id: this.el.id,
      autoFocus: getBooleanOption(this.el, "autoFocus"),
      modal: getBooleanOption(this.el, "modal"),
      closeOnInteractOutside: getBooleanOption(this.el, "closeOnInteractOutside"),
      closeOnEscape: getBooleanOption(this.el, "closeOnEscape"),
      onOpenChange: (details: popover.OpenChangeDetails) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
    };
  },
} as PopoverHook;
