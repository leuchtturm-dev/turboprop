"use strict";
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

// hooks/index.ts
var hooks_exports = {};
__export(hooks_exports, {
  Accordion: () => accordion_default,
  Clipboard: () => clipboard_default,
  Collapsible: () => collapsible_default,
  Combobox: () => combobox_default,
  Dialog: () => dialog_default,
  Hooks: () => Hooks,
  Menu: () => menu_default,
  PinInput: () => pin_input_default,
  Popover: () => popover_default,
  Tooltip: () => tooltip_default
});
module.exports = __toCommonJS(hooks_exports);

// hooks/accordion.ts
var accordion = __toESM(require("@zag-js/accordion"));

// hooks/util.ts
var import_types = require("@zag-js/types");
var propMap = {
  onFocus: "onFocusin",
  onBlur: "onFocusout",
  onChange: "onInput",
  onDoubleClick: "onDblclick",
  htmlFor: "for",
  className: "class",
  defaultValue: "value",
  defaultChecked: "checked"
};
var prevAttrsMap = /* @__PURE__ */ new WeakMap();
var toStyleString = (style) => {
  return Object.entries(style).reduce((styleString, [key, value]) => {
    if (value === null || value === void 0) return styleString;
    const formattedKey = key.startsWith("--") ? key : key.replace(/[A-Z]/g, (match) => `-${match.toLowerCase()}`);
    return `${styleString}${formattedKey}:${value};`;
  }, "");
};
var normalizeProps = (0, import_types.createNormalizer)((props) => {
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
var getAttributes = (root, name) => {
  const part = root.querySelector(`[data-part='${name}']`);
  if (!part) return;
  const attrs = [];
  for (const attr of part.attributes) {
    if (attr.name.startsWith("data-") || attr.name.startsWith("aria-")) {
      attrs.push({ name: attr.name, value: attr.value });
    }
  }
  return {
    part: name,
    style: part.style.cssText,
    hasFocus: part === document.activeElement,
    attrs
  };
};
var restoreAttributes = (root, attributeMaps) => {
  for (const attributeMap of attributeMaps) {
    const part = root.querySelector(`[data-part='${attributeMap.part}']`);
    if (!part) return;
    for (const attr of attributeMap.attrs) {
      part.setAttribute(attr.name, attr.value);
    }
    part.style.cssText = attributeMap.style;
    if (attributeMap.hasFocus) part.focus();
  }
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

// hooks/accordion.ts
var Accordion = class extends Component {
  initService(context) {
    return accordion.machine(context);
  }
  initApi() {
    return accordion.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["root"];
    for (const part of parts) renderPart(this.el, part, this.api);
    this.renderItems();
  }
  renderItems() {
    for (const item of this.el.querySelectorAll("[data-part='item']")) {
      const value = item.dataset.value;
      if (!value) {
        console.error("Missing `data-value` attribute on item.");
        return;
      }
      spreadProps(item, this.api.getItemProps({ value }));
      this.renderItemTrigger(item, value);
      this.renderItemIndicator(item, value);
      this.renderItemContent(item, value);
    }
  }
  renderItemTrigger(item, value) {
    const itemTrigger = item.querySelector("[data-part='item-trigger']");
    if (!itemTrigger) return;
    spreadProps(itemTrigger, this.api.getItemTriggerProps({ value }));
  }
  renderItemIndicator(item, value) {
    const itemIndicator = item.querySelector("[data-part='item-indicator']");
    if (!itemIndicator) return;
    spreadProps(itemIndicator, this.api.getItemIndicatorProps({ value }));
  }
  renderItemContent(item, value) {
    const itemContent = item.querySelector("[data-part='item-content']");
    if (!itemContent) return;
    spreadProps(itemContent, this.api.getItemContentProps({ value }));
  }
};
var accordion_default = {
  mounted() {
    this.accordion = new Accordion(this.el, this.context());
    this.accordion.init();
  },
  updated() {
    this.accordion.render();
  },
  beforeDestroy() {
    this.accordion.destroy();
  },
  context() {
    return {
      id: this.el.id,
      value: [""],
      disabled: this.el.dataset.disabled === "true" || this.el.dataset.disabled === "",
      multiple: this.el.dataset.multiple === "true" || this.el.dataset.multiple === "",
      collapsible: this.el.dataset.collapsible === "true" || this.el.dataset.collapsible === "",
      onValueChange: (details) => {
        if (this.el.dataset.onValueChange) {
          this.pushEvent(this.el.dataset.onValueChange, details);
        }
      }
    };
  }
};

// hooks/clipboard.ts
var clipboard = __toESM(require("@zag-js/clipboard"));
var Clipboard = class extends Component {
  initService(context) {
    return clipboard.machine(context);
  }
  initApi() {
    return clipboard.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["root", "label", "control", "input", "trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
};
var clipboard_default = {
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
  context() {
    return {
      id: this.el.id,
      value: this.el.dataset.value,
      onStatusChange: (details) => {
        if (this.el.dataset.onStatusChange) {
          this.pushEvent(this.el.dataset.onStatusChange, details);
        }
      }
    };
  }
};

// hooks/collapsible.ts
var collapsible = __toESM(require("@zag-js/collapsible"));
var Collapsible = class extends Component {
  initService(context) {
    return collapsible.machine(context);
  }
  initApi() {
    return collapsible.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["root", "trigger", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
};
var collapsible_default = {
  mounted() {
    this.collapsible = new Collapsible(this.el, this.context());
    this.collapsible.init();
  },
  updated() {
    this.collapsible.render();
  },
  beforeDestroy() {
    this.collapsible.destroy();
  },
  context() {
    let dir = this.el.dataset.dir;
    const validDirs = ["ltr", "rtl"];
    if (dir !== void 0 && !validDirs.includes(dir)) {
      console.error(`Invalid 'dir' specified: '${dir}'. Expected 'ltr' or 'rtl'.`);
      dir = void 0;
    }
    return {
      id: this.el.id,
      dir,
      disabled: this.el.dataset.disabled === "true" || this.el.dataset.disabled === "",
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      }
    };
  }
};

// hooks/combobox.ts
var combobox = __toESM(require("@zag-js/combobox"));
var Combobox = class extends Component {
  initService(context) {
    return combobox.machine(context);
  }
  initApi() {
    return combobox.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["root", "label", "control", "input", "trigger", "positioner", "content"];
    for (const part of parts) renderPart(this.el, part, this.api);
    this.renderItems();
  }
  renderItems() {
    for (const item of this.el.querySelectorAll("[data-part='item']")) {
      const value = item.dataset.value;
      const label = item.dataset.label;
      if (!value || !label) {
        console.error("Missing `data-value` or `data-label` attribute on item.");
        return;
      }
      spreadProps(item, this.api.getItemProps({ item: { value, label } }));
    }
  }
};
var combobox_default = {
  mounted() {
    this.combobox = new Combobox(this.el, this.context());
    this.combobox.init();
  },
  beforeUpdate() {
    const parts = ["root", "label", "control", "input", "trigger", "positioner", "content"];
    this.attributeCache = parts.map((part) => {
      return getAttributes(this.el, part);
    });
  },
  updated() {
    this.combobox.api.setCollection(this.collection());
    this.combobox.render();
    restoreAttributes(this.el, this.attributeCache);
  },
  beforeDestroy() {
    this.combobox.destroy();
  },
  items() {
    return Array.from(this.el.querySelectorAll("[data-part='item']")).map((item) => {
      const value = item.dataset.value;
      const label = item.dataset.label;
      if (!value || !label) {
        console.error("Missing `data-value` or `data-label` attribute on item.");
        return;
      }
      return { value, label };
    }).filter((value) => value !== void 0);
  },
  collection() {
    return combobox.collection({
      items: this.items(),
      itemToValue: (item) => item.value,
      itemToString: (item) => item.label
    });
  },
  context() {
    let inputBehavior = this.el.dataset.inputBehavior;
    const validInputBehaviors = ["autohighlight", "autocomplete", "none"];
    if (inputBehavior !== void 0 && !validInputBehaviors.includes(inputBehavior)) {
      console.error(`Invalid 'inputBehavior' specified: '${inputBehavior}'. Expected 'autohighlight', 'autocomplete' or 'none'.`);
      inputBehavior = void 0;
    }
    let selectionBehavior = this.el.dataset.selectionBehavior;
    const validSelectionBehaviors = ["clear", "replace", "preserve"];
    if (selectionBehavior !== void 0 && !validSelectionBehaviors.includes(selectionBehavior)) {
      console.error(`Invalid 'selectionBehavior' specified: '${selectionBehavior}'. Expected 'clear', 'replace' or 'preserve'.`);
      selectionBehavior = void 0;
    }
    return {
      id: this.el.id,
      name: this.el.dataset.name,
      collection: this.collection(),
      multiple: this.el.dataset.multiple === "true" || this.el.dataset.multiple === "",
      disabled: this.el.dataset.disabled === "true" || this.el.dataset.disabled === "",
      readOnly: this.el.dataset.readOnly === "true" || this.el.dataset.readOnly === "",
      loopFocus: this.el.dataset.loopFocus === "true" || this.el.dataset.loopFocus === "",
      allowCustomValue: this.el.dataset.allowCustomValue === "true" || this.el.dataset.allowCustomValue === "",
      inputBehavior,
      selectionBehavior,
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      },
      onInputValueChange: (details) => {
        if (this.el.dataset.onInputValueChange) {
          this.pushEvent(this.el.dataset.onInputValueChange, details);
        }
      },
      onHighlightChange: (details) => {
        if (this.el.dataset.onHighlightChange) {
          this.pushEvent(this.el.dataset.onHighlightChange, details);
        }
      },
      onValueChange: (details) => {
        if (this.el.dataset.onValueChange) {
          this.pushEvent(this.el.dataset.onValueChange, details);
        }
      }
    };
  }
};

// hooks/dialog.ts
var dialog = __toESM(require("@zag-js/dialog"));
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
    if (role !== void 0 && !validRoles.includes(role)) {
      console.error(`Invalid 'role' specified: '${role}'. Expected 'dialog' or 'alertdialog'.`);
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
      }
    };
  }
};

// hooks/menu.ts
var menu = __toESM(require("@zag-js/menu"));
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
      const value = itemGroup.dataset.value;
      if (!value) {
        console.error("Missing `data-value` attribute on item group.");
        return;
      }
      spreadProps(itemGroup, this.api.getItemGroupProps({ id: value }));
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
    for (const separator of this.el.querySelectorAll("[data-part='separator']"))
      spreadProps(separator, this.api.getSeparatorProps());
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
  }
};

// hooks/pin-input.ts
var pinInput = __toESM(require("@zag-js/pin-input"));
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
  context() {
    let type = this.el.dataset.type;
    const validTypes = ["alphanumeric", "numeric", "alphabetic"];
    if (type !== void 0 && !validTypes.includes(type)) {
      console.error(`Invalid 'type' specified: '${type}'. Expected 'alphanumeric', 'numeric' or 'alphabetic'.`);
      type = void 0;
    }
    let dir = this.el.dataset.dir;
    const validDirs = ["ltr", "rtl"];
    if (dir !== void 0 && !validDirs.includes(dir)) {
      console.error(`Invalid 'dir' specified: '${dir}'. Expected 'ltr' or 'rtl'.`);
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
          this.pushEvent(this.el.dataset.onComplete, details);
        }
      },
      onValueInvalid: (details) => {
        if (this.el.dataset.onInvalid) {
          this.pushEvent(this.el.dataset.onInvalid, details);
        }
      }
    };
  }
};

// hooks/popover.ts
var popover = __toESM(require("@zag-js/popover"));
var Popover = class extends Component {
  initService(context) {
    return popover.machine(context);
  }
  initApi() {
    return popover.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["trigger", "positioner", "content", "title", "description", "close-trigger"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
};
var popover_default = {
  mounted() {
    this.popover = new Popover(this.el, this.context());
    this.popover.init();
  },
  updated() {
    this.popover.render();
  },
  beforeDestroy() {
    this.popover.destroy();
  },
  context() {
    return {
      id: this.el.id,
      autoFocus: this.el.dataset.autoFocus === "true" || this.el.dataset.autoFocus === "",
      modal: this.el.dataset.modal === "true" || this.el.dataset.modal === "",
      closeOnInteractOutside: this.el.dataset.closeOnInteractOutside === "true" || this.el.dataset.closeOnInteractOutside === "",
      closeOnEscape: this.el.dataset.closeOnEscape === "true" || this.el.dataset.closeOnEscape === "",
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      }
    };
  }
};

// hooks/tooltip.ts
var tooltip = __toESM(require("@zag-js/tooltip"));
var Tooltip = class extends Component {
  initService(context) {
    return tooltip.machine(context);
  }
  initApi() {
    return tooltip.connect(this.service.state, this.service.send, normalizeProps);
  }
  render() {
    const parts = ["trigger", "positioner", "content", "arrow", "arrow-tip"];
    for (const part of parts) renderPart(this.el, part, this.api);
  }
  onOpenChange(details) {
    const positioner = this.el.querySelector("[data-part='positioner']");
    if (!positioner) return;
    positioner.hidden = !details.open;
  }
};
var tooltip_default = {
  mounted() {
    this.tooltip = new Tooltip(this.el, this.context());
    this.tooltip.init();
  },
  updated() {
    this.tooltip.render();
  },
  beforeDestroy() {
    this.tooltip.destroy();
  },
  context() {
    let openDelay;
    let closeDelay;
    if (this.el.dataset.openDelay && !Number.isNaN(Number.parseInt(this.el.dataset.openDelay))) {
      openDelay = Number.parseInt(this.el.dataset.openDelay);
      console.log(openDelay);
    }
    if (this.el.dataset.closeDelay && !Number.isNaN(Number.parseInt(this.el.dataset.closeDelay))) {
      closeDelay = Number.parseInt(this.el.dataset.closeDelay);
    }
    return {
      id: this.el.id,
      openDelay,
      closeDelay,
      closeOnEscape: this.el.dataset.closeOnEscape === "true" || this.el.dataset.closeOnEscape === "",
      closeOnScroll: this.el.dataset.closeOnScroll === "true" || this.el.dataset.closeOnScroll === "",
      closeOnPointerDown: this.el.dataset.closeOnPointerDown === "true" || this.el.dataset.closeOnPointerDown === "",
      positioning: {
        placement: this.el.dataset.positioningPlacement
      },
      onOpenChange: (details) => {
        this.tooltip.onOpenChange(details);
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      }
    };
  }
};

// hooks/index.ts
var Hooks = {
  Accordion: accordion_default,
  Clipboard: clipboard_default,
  Collapsible: collapsible_default,
  Combobox: combobox_default,
  Dialog: dialog_default,
  Menu: menu_default,
  PinInput: pin_input_default,
  Popover: popover_default,
  Tooltip: tooltip_default
};
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  Accordion,
  Clipboard,
  Collapsible,
  Combobox,
  Dialog,
  Hooks,
  Menu,
  PinInput,
  Popover,
  Tooltip
});
