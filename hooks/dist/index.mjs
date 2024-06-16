var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) =>
  key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : (obj[key] = value);
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

// hooks/dialog.ts
import * as dialog from "@zag-js/dialog";

// hooks/util.ts
import { createNormalizer } from "@zag-js/types";
var propMap = {
  onFocus: "onFocusin",
  onBlur: "onFocusout",
  onChange: "onInput",
  onDoubleClick: "onDblclick",
  htmlFor: "for",
  className: "class",
  defaultValue: "value",
  defaultChecked: "checked",
};
var prevAttrsMap = /* @__PURE__ */ new WeakMap();
var toStyleString = (style) => {
  return Object.entries(style).reduce((styleString, [key, value]) => {
    if (value === null || value === void 0) return styleString;
    const formattedKey = key.startsWith("--") ? key : key.replace(/[A-Z]/g, (match) => `-${match.toLowerCase()}`);
    return `${styleString}${formattedKey}:${value};`;
  }, "");
};
var normalizeProps = createNormalizer((props) => {
  return Object.entries(props).reduce((acc, [key, value]) => {
    if (value === void 0) return acc;
    key = propMap[key] || key;
    if (key === "style" && typeof value === "object") {
      acc.style = toStyleString(value);
    } else {
      acc[key.toLowerCase()] = value;
    }
    return acc;
  }, {});
});
var spreadProps = (node, attrs) => {
  const oldAttrs = prevAttrsMap.get(node) || {};
  const attrKeys = Object.keys(attrs);
  const addEvent = (event, callback) => {
    node.addEventListener(event.toLowerCase(), callback);
  };
  const removeEvent = (event, callback) => {
    node.removeEventListener(event.toLowerCase(), callback);
  };
  const onEvents = (attr) => attr.startsWith("on");
  const others = (attr) => !attr.startsWith("on");
  const setup = (attr) => addEvent(attr.substring(2), attrs[attr]);
  const teardown = (attr) => removeEvent(attr.substring(2), attrs[attr]);
  const apply = (attrName) => {
    let value = attrs[attrName];
    const oldValue = oldAttrs[attrName];
    if (value === oldValue) return;
    if (typeof value === "boolean") {
      value = value || void 0;
    }
    if (value != null) {
      if (["value", "checked", "htmlFor"].includes(attrName)) {
        node[attrName] = value;
      } else {
        node.setAttribute(attrName.toLowerCase(), value);
      }
      return;
    }
    node.removeAttribute(attrName.toLowerCase());
  };
  for (const key in oldAttrs) {
    if (attrs[key] == null) {
      node.removeAttribute(key.toLowerCase());
    }
  }
  const oldEvents = Object.keys(oldAttrs).filter(onEvents);
  for (const oldEvent of oldEvents) removeEvent(oldEvent.substring(2), oldAttrs[oldEvent]);
  attrKeys.filter(onEvents).forEach(setup);
  attrKeys.filter(others).forEach(apply);
  prevAttrsMap.set(node, attrs);
  return function cleanup() {
    attrKeys.filter(onEvents).forEach(teardown);
  };
};
var renderPart = (root, name, api) => {
  const camelizedName = name.replace(/(^|-)([a-z])/g, (_match, _prefix, letter) => letter.toUpperCase());
  const part = root.querySelector(`[data-part='${name}']`);
  const getterName = `get${camelizedName}Props`;
  if (part) spreadProps(part, api[getterName]());
};

// hooks/component.ts
var Component = class {
  constructor(el, context) {
    __publicField(this, "el");
    __publicField(this, "service");
    __publicField(this, "api");
    __publicField(this, "init", () => {
      this.render();
      this.service.subscribe(() => {
        this.api = this.initApi();
        this.render();
      });
      this.service.start();
    });
    __publicField(this, "destroy", () => {
      this.service.stop();
    });
    this.el = el;
    this.service = this.initService(context);
    this.api = this.initApi();
  }
};

// hooks/dialog.ts
var Dialog = class extends Component {
  initService(context) {
    return dialog.machine(context);
  }
  initApi() {
    return dialog.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["trigger", "backdrop", "positioner", "content", "title", "description", "close-trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
};
var dialog_default = {
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
  context() {
    let role = this.el.dataset.role;
    const validRoles = ["dialog", "alertdialog"];
    if (role !== void 0 && !(role in validRoles)) {
      console.error(`Invalid 'role' specified: ${role}. Expected 'dialog' or 'alertdialog'.`);
      role = void 0;
    }
    return {
      id: this.el.id,
      role,
      preventScroll: this.el.dataset.preventScroll === "true" || this.el.dataset.preventScroll === "",
      closeOnInteractOutside: this.el.dataset.closeOnInteractOutside === "true" || this.el.dataset.closeOnInteractOutside === "",
      closeOnEscape: this.el.dataset.closeOnEscape === "true" || this.el.dataset.closeOnEscape === "",
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
    };
  },
};

// hooks/menu.ts
import * as menu from "@zag-js/menu";
var Menu = class extends Component {
  initService(context) {
    return menu.machine(context);
  }
  initApi() {
    return menu.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["trigger", "positioner", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);
    this.renderItemGroupLabels();
    this.renderItemGroups();
    this.renderItems();
    this.renderSeparators();
  }
  renderItemGroupLabels() {
    for (const itemGroupLabel of this.el.querySelectorAll("[data-part='item-group-label']")) {
      const htmlFor = itemGroupLabel.getAttribute("for");
      if (!htmlFor) {
        console.error("Missing `for` attribute on item group label.");
        return;
      }
      spreadProps(itemGroupLabel, this.api.getItemGroupLabelProps({ htmlFor }));
    }
  }
  renderItemGroups() {
    for (const itemGroup of this.el.querySelectorAll("[data-part='item-group']")) {
      const id = itemGroup.getAttribute("id");
      if (!id) {
        console.error("Missing `id` attribute on item group.");
        return;
      }
      spreadProps(itemGroup, this.api.getItemGroupProps({ id }));
    }
  }
  renderItems() {
    for (const item of this.el.querySelectorAll("[data-part='item']")) {
      const value = item.dataset.value;
      if (!value) {
        console.error("Missing `data-value` attribute on item.");
        return;
      }
      spreadProps(item, this.api.getItemProps({ value }));
    }
  }
  renderSeparators() {
    for (const separator of this.el.querySelectorAll("[data-part='separator']")) spreadProps(separator, this.api.getSeparatorProps());
  }
};
var menu_default = {
  mounted() {
    this.context = { id: this.el.id };
    this.menu = new Menu(this.el, this.context);
    this.menu.init();
  },
  updated() {
    this.menu.render();
  },
  beforeDestroy() {
    this.menu.destroy();
  },
};

// hooks/pin-input.ts
import * as pinInput from "@zag-js/pin-input";
var PinInput = class extends Component {
  initService(context) {
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
    for (const input of this.el.querySelectorAll("[data-part='input']")) {
      const index = input.dataset.index;
      if (!index || Number.isNaN(Number.parseInt(index))) {
        console.error("Missing or non-integer `data-index` attribute on input.");
        return;
      }
      spreadProps(input, this.api.getInputProps({ index: Number.parseInt(index) }));
    }
  }
};
var pin_input_default = {
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
  context() {
    let type = this.el.dataset.type;
    const validTypes = ["alphanumeric", "numeric", "alphabetic"];
    if (type !== void 0 && !(type in validTypes)) {
      console.error(`Invalid 'type' specified: ${type}. Expected 'alphanumeric', 'numeric' or 'alphabetic'.`);
      type = void 0;
    }
    let dir = this.el.dataset.dir;
    const validDirs = ["alphanumeric", "numeric", "alphabetic"];
    if (dir !== void 0 && !(dir in validDirs)) {
      console.error(`Invalid 'dir' specified: ${dir}. Expected 'ltr' or 'rtl'.`);
      dir = void 0;
    }
    return {
      id: this.el.id,
      type,
      otp: this.el.dataset.otp === "true" || this.el.dataset.otp === "",
      mask: this.el.dataset.mask === "true" || this.el.dataset.mask === "",
      blurOnComplete: this.el.dataset.blurOnComplete === "true" || this.el.dataset.blurOnComplete === "",
      placeholder: this.el.dataset.placeholder,
      dir,
      onValueChange: (details) => {
        if (this.el.dataset.onChange) {
          this.pushEvent(this.el.dataset.onChange, details);
        }
      },
      onValueComplete: (details) => {
        if (this.el.dataset.onComplete) {
          this.pushEvent(this.el.dataset.onComplete, { value: details.value });
        }
      },
      onValueInvalid: (details) => {
        if (this.el.dataset.onInvalid) {
          this.pushEvent(this.el.dataset.onInvalid, { value: details.value });
        }
      },
    };
  },
};

// hooks/index.ts
var Hooks = {
  Dialog: dialog_default,
  Menu: menu_default,
  PinInput: pin_input_default,
};
export { dialog_default as Dialog, Hooks, menu_default as Menu, pin_input_default as PinInput };
