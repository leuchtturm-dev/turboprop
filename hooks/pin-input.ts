import * as pinInput from "@zag-js/pin-input";
import { normalizeProps, spreadProps, renderPart, getBooleanOption, getOption } from "./util";
import { Component } from "./component";
import type { ViewHook } from "phoenix_live_view";
import type { Machine } from "@zag-js/core";

type Type = "alphanumeric" | "numeric" | "alphabetic" | undefined;
type Dir = "ltr" | "rtl" | undefined;

class PinInput extends Component<pinInput.Context, pinInput.Api> {
  initService(context: pinInput.Context): Machine<any, any, any> {
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
    this.renderInputs();
  }

  renderInputs() {
    for (const input of this.el.querySelectorAll<HTMLElement>("[data-part='input']")) {
      const index = input.dataset.index;
      if (!index || Number.isNaN(Number.parseInt(index))) {
        console.error("Missing or non-integer `data-index` attribute on input.");
        return;
      }
      spreadProps(input, this.api.getInputProps({ index: Number.parseInt(index) }));
    }
  }
}

export interface PinInputHook extends ViewHook {
  pinInput: PinInput;
  context(): pinInput.Context;
}

export default {
  mounted() {
    this.pinInput = new PinInput(this.el, this.context());
    this.pinInput.init();

    this.handleEvent("clear", () => this.pinInput.clearValue());
  },

  updated() {
    this.pinInput.render();
  },

  beforeDestroy() {
    this.pinInput.destroy();
  },

  context(): pinInput.Context {
    return {
      id: this.el.id,
      placeholder: this.el.dataset.placeholder,
      type: getOption(this.el, "type", ["alphanumeric", "numeric", "alphabetic"] as const) as Type,
      dir: getOption(this.el, "dir", ["ltr", "rtl"] as const) as Dir,
      otp: getBooleanOption(this.el, "otp"),
      mask: getBooleanOption(this.el, "mask"),
      blurOnComplete: getBooleanOption(this.el, "blurOnComplete"),
      onValueChange: (details: pinInput.ValueChangeDetails) => {
        if (this.el.dataset.onChange) {
          this.pushEvent(this.el.dataset.onChange, details);
        }
      },
      onValueComplete: (details: pinInput.ValueChangeDetails) => {
        if (this.el.dataset.onComplete) {
          this.pushEvent(this.el.dataset.onComplete, details);
        }
      },
      onValueInvalid: (details: pinInput.ValueInvalidDetails) => {
        if (this.el.dataset.onInvalid) {
          this.pushEvent(this.el.dataset.onInvalid, details);
        }
      },
    };
  },
} as PinInputHook;
