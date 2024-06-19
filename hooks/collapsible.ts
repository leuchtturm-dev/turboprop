import * as collapsible from "@zag-js/collapsible";
import { normalizeProps, renderPart } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

type Dir = "ltr" | "rtl" | undefined;

class Collapsible extends Component<collapsible.Context, collapsible.Api> {
  initService(context: collapsible.Context): Machine<any, any, any> {
    return collapsible.machine(context);
  }

  initApi() {
    return collapsible.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["root", "trigger", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
}

export interface CollapsibleHook extends ViewHook {
  collapsible: Collapsible;
  context(): collapsible.Context;
}

export default {
  mounted() {
    this.collapsible = new Collapsible(this.el, this.context());
    this.collapsible.init();
  },

  updated() {
    this.collapsible.render();
  },

  beforeDestroy() {
    this.collapsible.destroy();
  },

  context(): collapsible.Context {
    let dir: string | undefined = this.el.dataset.dir;
    const validDirs = ["ltr", "rtl"] as const;

    if (dir !== undefined && !validDirs.includes(dir as any)) {
      console.error(`Invalid 'dir' specified: '${dir}'. Expected 'ltr' or 'rtl'.`);
      dir = undefined;
    }

    return {
      id: this.el.id,
      dir: dir as Dir,
      disabled: this.el.dataset.disabled === "true" || this.el.dataset.disabled === "",
      onOpenChange: (details: collapsible.OpenChangeDetails) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
    };
  },
} as CollapsibleHook;
