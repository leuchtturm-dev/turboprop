var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);

// hooks/accordion.ts
import * as accordion from "@zag-js/accordion";

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
var getOption = (el, name, validOptions) => {
  const kebabName = name.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase();
  let initial = el.dataset[kebabName];
  if (validOptions && initial !== void 0 && !validOptions.includes(initial)) {
    console.error(`Invalid '${name}' specified: '${initial}'. Expected one of '${validOptions.join("', '")}'.`);
    initial = void 0;
  }
  return initial;
};
var getBooleanOption = (el, name) => {
  const kebabName = name.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase();
  return el.dataset[kebabName] === "true" || el.dataset[kebabName] === "";
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
    cssText: part.style.cssText,
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
    part.style.cssText = attributeMap.cssText;
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
      disabled: getBooleanOption(this.el, "disabled"),
      multiple: getBooleanOption(this.el, "multiple"),
      collapsible: getBooleanOption(this.el, "collapsible"),
      onValueChange: (details) => {
        if (this.el.dataset.onValueChange) {
          this.pushEvent(this.el.dataset.onValueChange, details);
        }
      }
    };
  }
};

// hooks/clipboard.ts
import * as clipboard from "@zag-js/clipboard";
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
import * as collapsible from "@zag-js/collapsible";
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
    return {
      id: this.el.id,
      dir: getOption(this.el, "dir", ["ltr", "rtl"]),
      disabled: getBooleanOption(this.el, "disabled"),
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      }
    };
  }
};

// hooks/combobox.ts
import * as combobox from "@zag-js/combobox";
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
    return {
      id: this.el.id,
      name: this.el.dataset.name,
      collection: this.collection(),
      inputBehavior: getOption(this.el, "inputBehavior", ["autocomplete", "autohighlight", "none"]),
      selectionBehavior: getOption(this.el, "selectionBehavior", ["clear", "replace", "preserve"]),
      multiple: getBooleanOption(this.el, "multiple"),
      disabled: getBooleanOption(this.el, "disabled"),
      readOnly: getBooleanOption(this.el, "readOnly"),
      loopFocus: getBooleanOption(this.el, "loopFocus"),
      allowCustomValue: getBooleanOption(this.el, "allowCustomValue"),
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
import * as dialog from "@zag-js/dialog";
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
    return {
      id: this.el.id,
      role: getOption(this.el, "role", ["dialog", "alertdialog"]),
      preventScroll: getBooleanOption(this.el, "preventScroll"),
      closeOnInteractOutside: getBooleanOption(this.el, "closeOnInteractOutside"),
      closeOnEscape: getBooleanOption(this.el, "closeOnEscape"),
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      }
    };
  }
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
    return {
      id: this.el.id,
      placeholder: this.el.dataset.placeholder,
      type: getOption(this.el, "type", ["alphanumeric", "numeric", "alphabetic"]),
      dir: getOption(this.el, "dir", ["ltr", "rtl"]),
      otp: getBooleanOption(this.el, "otp"),
      mask: getBooleanOption(this.el, "mask"),
      blurOnComplete: getBooleanOption(this.el, "blurOnComplete"),
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
import * as popover from "@zag-js/popover";
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
      autoFocus: getBooleanOption(this.el, "autoFocus"),
      modal: getBooleanOption(this.el, "modal"),
      closeOnInteractOutside: getBooleanOption(this.el, "closeOnInteractOutside"),
      closeOnEscape: getBooleanOption(this.el, "closeOnEscape"),
      onOpenChange: (details) => {
        if (this.el.dataset.onOpenChange) {
          this.pushEvent(this.el.dataset.onOpenChange, details);
        }
      }
    };
  }
};

// hooks/tooltip.ts
import * as tooltip from "@zag-js/tooltip";
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
      positioning: {
        placement: this.el.dataset.positioningPlacement
      },
      closeOnEscape: getBooleanOption(this.el, "closeOnEscape"),
      closeOnScroll: getBooleanOption(this.el, "closeOnScroll"),
      closeOnPointerDown: getBooleanOption(this.el, "closeOnPointerDown"),
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
export {
  accordion_default as Accordion,
  clipboard_default as Clipboard,
  collapsible_default as Collapsible,
  combobox_default as Combobox,
  dialog_default as Dialog,
  Hooks,
  menu_default as Menu,
  pin_input_default as PinInput,
  popover_default as Popover,
  tooltip_default as Tooltip
};
