import * as pinInput from "@zag-js/pin-input";
import { normalizeProps, spreadProps, renderPart } from "./util";
import { Component } from "./component";

export class PinInput extends Component<pinInput.Context, pinInput.Api> {
  initService(context: pinInput.Context) {
    return pinInput.machine(context);
  }

  initApi() {
    return pinInput.connect(this.service.state, this.service.send, normalizeProps);
  }

  clearValue() {
    this.api.clearValue();
  }

  render() {
    const parts = ["root", "label"];
    for (const part of parts) renderPart(this.el, part, this.api);
    for (const input of this.inputs()) spreadProps(input, this.api.getInputProps({ index: Number.parseInt(input.dataset.index!) }));
  }

  inputs() {
    return Array.from(this.el.querySelectorAll("[data-part='input']")) as HTMLElement[];
  }
}

export const PinInputHook = {
  mounted() {
    this.handleEvent("clear", () => this.pinInput.clearValue());

    this.pinInput = new PinInput(this.el, this.context());
    this.pinInput.init();
  },

  updated() {
    this.pinInput.render();
  },

  beforeDestroy() {
    this.pinInput.destroy();
  },

  context(): pinInput.Context {
    const self = this;
    return {
      id: this.el.id,
      type: this.el.dataset.type,
      otp: this.el.dataset.otp === "true" || this.el.dataset.otp === "",
      mask: this.el.dataset.mask === "true" || this.el.dataset.mask === "",
      blurOnComplete: this.el.dataset.blurOnComplete === "true" || this.el.dataset.blurOnComplete === "",
      placeholder: this.el.dataset.placeholder,
      dir: this.el.dataset.dir,
      onValueChange(details: any) {
        if (self.el.dataset.onChange) {
          self.pushEvent(self.el.dataset.onChange, { value: details.value });
        }
      },
      onValueComplete(details: any) {
        if (self.el.dataset.onComplete) {
          self.pushEvent(self.el.dataset.onComplete, { value: details.value });
        }
      },
      onValueInvalid(details: any) {
        if (self.el.dataset.onInvalid) {
          self.pushEvent(self.el.dataset.onInvalid, { value: details.value });
        }
      },
    };
  },
};
