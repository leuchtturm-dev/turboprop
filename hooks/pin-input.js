import * as pinInput from "@zag-js/pin-input";
import { normalizeProps, spreadProps, renderPart } from "./util";

export const PinInput = {
  mounted() {
    const self = this;
    this.context = {
      id: this.el.id,
      placeholder: this.el.dataset.placeholder,
      type: this.el.dataset.type,
      otp: this.el.dataset.otp === "true" || this.el.dataset.otp === "",
      mask: this.el.dataset.mask === "true" || this.el.dataset.mask === "",
      blurOnComplete: this.el.dataset.blurOnComplete === "true" || this.el.dataset.blurOnComplete === "",
      dir: this.el.dataset.dir,
      onValueChange(details) {
        if (self.el.dataset.onChange) {
          self.pushEvent(self.el.dataset.onChange, { value: details.value });
        }
      },
      onValueComplete(details) {
        if (self.el.dataset.onComplete) {
          self.pushEvent(self.el.dataset.onComplete, { value: details.value });
        }
      },
      onValueInvalid(details) {
        if (self.el.dataset.onInvalid) {
          self.pushEvent(self.el.dataset.onInvalid, { value: details.value });
        }
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
    const parts = ["root", "label"];
    for (const part of parts) renderPart(this.el, part, this.api);
    for (const input of this.inputs()) spreadProps(input, this.api.getInputProps({ index: Number.parseInt(input.dataset.index) }));
  },
};
