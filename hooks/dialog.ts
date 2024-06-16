import * as dialog from "@zag-js/dialog";
import { normalizeProps, renderPart } from "./util";
import { Component } from "./component";

export class Dialog extends Component<dialog.Context, dialog.Api> {
  initService(context: dialog.Context) {
    return dialog.machine(context);
  }

  initApi() {
    return dialog.connect(this.service.state, this.service.send, normalizeProps);
  }

  render() {
    const parts = ["trigger", "backdrop", "positioner", "content", "title", "description", "close-trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
}

export const DialogHook = {
  mounted() {
    this.dialog = new Dialog(this.el, this.context());
    this.dialog.init();
  },

  updated() {
    this.dialog.render();
  },

  beforeDestroy() {
    this.dialog.destroy();
  },

  context(): dialog.Context {
    const self = this;
    return {
      id: this.el.id,
      role: this.el.dataset.role,
      preventScroll: this.el.dataset.preventScroll === "true" || this.el.dataset.preventScroll === "",
      closeOnInteractOutside: this.el.dataset.closeOnInteractOutside === "true" || this.el.dataset.closeOnInteractOutside === "",
      closeOnEscape: this.el.dataset.closeOnEscape === "true" || this.el.dataset.closeOnEscape === "",
      onOpenChange(details: any) {
        if (self.el.dataset.onOpenChange) {
          self.pushEvent(self.el.dataset.onOpenChange, details);
        }
      },
    };
  },
};
