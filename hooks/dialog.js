import * as dialog from "@zag-js/dialog";
import { normalizeProps, renderPart } from "./util";

export const Dialog = {
  mounted() {
    this.context = {
      id: this.el.id,
      role: this.el.dataset.role,
      preventScroll: this.el.dataset.preventScroll === "true" || this.el.dataset.preventScroll === "",
      closeOnInteractOutside: this.el.dataset.closeOnInteractOutside === "true" || this.el.dataset.closeOnInteractOutside === "",
      closeOnEscape: this.el.dataset.closeOnEscape === "true" || this.el.dataset.closeOnEscape === "",
      onOpenChange(details) {
        if (self.el.dataset.onOpenChange) {
          self.pushEvent(self.el.dataset.onOpenChange, details);
        }
      },
    };

    this.service = dialog.machine(this.context);
    this.api = dialog.connect(this.service.state, this.service.send, normalizeProps);

    this.render();
    this.service.subscribe(() => {
      this.api = dialog.connect(this.service.state, this.service.send, normalizeProps);
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

  render() {
    const parts = ["trigger", "backdrop", "positioner", "content", "title", "description", "close-trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  },
};
