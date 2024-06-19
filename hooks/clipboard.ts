import * as clipboard from "@zag-js/clipboard";
import { normalizeProps, renderPart } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

class Clipboard extends Component<clipboard.Context, clipboard.Api> {
  initService(context: clipboard.Context): Machine<any, any, any> {
    return clipboard.machine(context);
  }

  initApi() {
    return clipboard.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["root", "label", "control", "input", "trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
}

export interface ClipboardHook extends ViewHook {
  clipboard: Clipboard;
  context(): clipboard.Context;
}

export default {
  mounted() {
    this.clipboard = new Clipboard(this.el, this.context());
    this.clipboard.init();
  },

  updated() {
    this.clipboard.render();
  },

  beforeDestroy() {
    this.clipboard.destroy();
  },

  context(): clipboard.Context {
    return {
      id: this.el.id,
      value: this.el.dataset.value,
      onStatusChange: (details: clipboard.CopyStatusDetails) => {
        if (this.el.dataset.onStatusChange) {
          this.pushEvent(this.el.dataset.onStatusChange, details);
        }
      },
    };
  },
} as ClipboardHook;
