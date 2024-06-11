import * as pinInput from "@zag-js/pin-input";
import { normalizeProps, spreadProps, renderPart } from "./util";

export const PinInput = {
  mounted() {
    const self = this;
    this.context = {
      id: this.el.id,
      mask: this.el.hasAttribute('data-mask') && (this.el.dataset.mask === "true" || this.el.dataset.mask === ""),
      onValueChange(details) {
        self.pushEvent(self.el.dataset.onChange, { value: details.value })
      },
      onValueComplete(details) {
        self.pushEvent(self.el.dataset.onComplete, { value: details.value })
      },
      onValueInvalid(details) {
        self.pushEvent(self.el.dataset.onInvalid, { value: details.value })
      },
    };

    this.service = pinInput.machine(this.context);
    this.api = pinInput.connect(this.service.state, this.service.send, normalizeProps);

    this.render();
    this.service.subscribe(() => {
      this.api = pinInput.connect(this.service.state, this.service.send, normalizeProps);
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

  inputs() {
    return Array.from(this.el.querySelectorAll("[data-part='input']"));
  },

  render() {
    parts = ["root", "label"];
    parts.forEach((part) => renderPart(this.el, part, this.api));

    this.inputs().forEach((item) => {
      spreadProps(item, this.api.getInputProps({ index: parseInt(item.dataset.index) }));
    });
  },
};
