import { createNormalizer } from "@zag-js/types";

type Attribute = {
  name: string;
  value: string;
};

type AttributeMap = {
  part: string;
  style: string;
  hasFocus: boolean;
  attrs: Attribute[];
};

export interface Attrs {
  [key: string]: any;
}

const propMap: Attrs = {
  onFocus: "onFocusin",
  onBlur: "onFocusout",
  onChange: "onInput",
  onDoubleClick: "onDblclick",
  htmlFor: "for",
  className: "class",
  defaultValue: "value",
  defaultChecked: "checked",
};

const prevAttrsMap = new WeakMap<HTMLElement, Attrs>();

const toStyleString = (style: any) => {
  return Object.entries(style).reduce((styleString, [key, value]) => {
    if (value === null || value === undefined) return styleString;
    const formattedKey = key.startsWith("--") ? key : key.replace(/[A-Z]/g, (match) => `-${match.toLowerCase()}`);
    return `${styleString}${formattedKey}:${value};`;
  }, "");
};

export const normalizeProps = createNormalizer((props: any) => {
  return Object.entries(props).reduce<any>((acc, [key, value]) => {
    if (value === undefined) return acc;
    key = propMap[key] || key;

    if (key === "style" && typeof value === "object") {
      acc.style = toStyleString(value);
    } else {
      acc[key.toLowerCase()] = value;
    }

    return acc;
  }, {});
});

export const spreadProps = (node: HTMLElement, attrs: Attrs) => {
  const oldAttrs = prevAttrsMap.get(node) || {};
  const attrKeys = Object.keys(attrs);

  const addEvent = (event: string, callback: EventListener) => {
    node.addEventListener(event.toLowerCase(), callback);
  };

  const removeEvent = (event: string, callback: EventListener) => {
    node.removeEventListener(event.toLowerCase(), callback);
  };

  const onEvents = (attr: string) => attr.startsWith("on");
  const others = (attr: string) => !attr.startsWith("on");

  const setup = (attr: string) => addEvent(attr.substring(2), attrs[attr]);
  const teardown = (attr: string) => removeEvent(attr.substring(2), attrs[attr]);

  const apply = (attrName: string) => {
    let value = attrs[attrName];

    const oldValue = oldAttrs[attrName];
    if (value === oldValue) return;

    if (typeof value === "boolean") {
      value = value || undefined;
    }

    if (value != null) {
      if (["value", "checked", "htmlFor"].includes(attrName)) {
        (node as any)[attrName] = value;
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

export const renderPart = (root: HTMLElement, name: string, api: any) => {
  const camelizedName = name.replace(/(^|-)([a-z])/g, (_match, _prefix, letter) => letter.toUpperCase());

  const part = root.querySelector<HTMLElement>(`[data-part='${name}']`);
  const getterName = `get${camelizedName}Props`;

  if (part) spreadProps(part, api[getterName]());
};

export const getAttributes = (root: HTMLElement, name: string) => {
  const part = root.querySelector<HTMLElement>(`[data-part='${name}']`);
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
    attrs,
  };
};

export const restoreAttributes = (root: HTMLElement, attributeMaps: AttributeMap[]) => {
  for (const attributeMap of attributeMaps) {
    const part = root.querySelector<HTMLElement>(`[data-part='${attributeMap.part}']`);
    if (!part) return;

    for (const attr of attributeMap.attrs) {
      part.setAttribute(attr.name, attr.value);
    }
    part.style.cssText = attributeMap.style;
    if (attributeMap.hasFocus) part.focus();
  }
};
