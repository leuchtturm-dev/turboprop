import * as pinInput from "@zag-js/pin-input";
import { normalizeProps, spreadProps, renderPart } from "./util";
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
    let type: string | undefined = this.el.dataset.type;
    const validTypes = ["alphanumeric", "numeric", "alphabetic"] as const;

    if (type !== undefined && !(type in validTypes)) {
      console.error(`Invalid 'type' specified: ${type}. Expected 'alphanumeric', 'numeric' or 'alphabetic'.`);
      type = undefined;
    }

    let dir: string | undefined = this.el.dataset.dir;
    const validDirs = ["alphanumeric", "numeric", "alphabetic"] as const;

    if (dir !== undefined && !(dir in validDirs)) {
      console.error(`Invalid 'dir' specified: ${dir}. Expected 'ltr' or 'rtl'.`);
      dir = undefined;
    }

    return {
      id: this.el.id,
      type: type as Type,
      otp: this.el.dataset.otp === "true" || this.el.dataset.otp === "",
      mask: this.el.dataset.mask === "true" || this.el.dataset.mask === "",
      blurOnComplete: this.el.dataset.blurOnComplete === "true" || this.el.dataset.blurOnComplete === "",
      placeholder: this.el.dataset.placeholder,
      dir: dir as Dir,
      onValueChange: (details: pinInput.ValueChangeDetails) => {
        if (this.el.dataset.onChange) {
          this.pushEvent(this.el.dataset.onChange, details);
        }
      },
      onValueComplete: (details: pinInput.ValueChangeDetails) => {
        if (this.el.dataset.onComplete) {
          this.pushEvent(this.el.dataset.onComplete, { value: details.value });
        }
      },
      onValueInvalid: (details: pinInput.ValueInvalidDetails) => {
        if (this.el.dataset.onInvalid) {
          this.pushEvent(this.el.dataset.onInvalid, { value: details.value });
        }
      },
    };
  },
} as PinInputHook;
