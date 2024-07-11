import * as tooltip from "@zag-js/tooltip";
import { getBooleanOption, normalizeProps, renderPart } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

class Tooltip extends Component<tooltip.Context, tooltip.Api> {
  initService(context: tooltip.Context): Machine<any, any, any> {
    return tooltip.machine(context);
  }

  initApi() {
    return tooltip.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["trigger", "positioner", "content", "arrow", "arrow-tip"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }

  onOpenChange(details: tooltip.OpenChangeDetails) {
    const positioner = this.el.querySelector<HTMLElement>("[data-part='positioner']");
    if (!positioner) return;

    positioner.hidden = !details.open;
  }
}

export interface TooltipHook extends ViewHook {
  tooltip: Tooltip;
  context(): tooltip.Context;
}

export default {
  mounted() {
    this.tooltip = new Tooltip(this.el, this.context());
    this.tooltip.init();
  },

  updated() {
    this.tooltip.render();
  },

  beforeDestroy() {
    this.tooltip.destroy();
  },

  context(): tooltip.Context {
    let openDelay: number | undefined;
    let closeDelay: number | undefined;
    if (this.el.dataset.openDelay && !Number.isNaN(Number.parseInt(this.el.dataset.openDelay))) {
      openDelay = Number.parseInt(this.el.dataset.openDelay);
      console.log(openDelay);
    }
    if (this.el.dataset.closeDelay && !Number.isNaN(Number.parseInt(this.el.dataset.closeDelay))) {
      closeDelay = Number.parseInt(this.el.dataset.closeDelay);
    }

    return {
      id: this.el.id,
      openDelay: openDelay,
      closeDelay: closeDelay,
      positioning: {
        placement: this.el.dataset.positioningPlacement as tooltip.Placement,
      },
      closeOnEscape: getBooleanOption(this.el, "closeOnEscape"),
      closeOnScroll: getBooleanOption(this.el, "closeOnScroll"),
      closeOnPointerDown: getBooleanOption(this.el, "closeOnPointerDown"),
      onOpenChange: (details: tooltip.OpenChangeDetails) => {
        this.tooltip.onOpenChange(details);
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
    };
  },
} as TooltipHook;
