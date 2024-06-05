import * as dialog from "@zag-js/dialog";
import { normalizeProps, renderPart } from "./util";

export const Dialog = {
  mounted() {
    this.context = { id: this.el.id };

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
    parts = ["trigger", "backdrop", "positioner", "content", "title", "description", "close-trigger"];
    parts.forEach((part) => renderPart(this.el, part, this.api));
  },
};
