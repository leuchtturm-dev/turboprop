import { createNormalizer } from "@zag-js/types";

const prevAttrsMap = new WeakMap();
const propMap = {
  onFocus: "onFocusin",
  onBlur: "onFocusout",
  onChange: "onInput",
  onDoubleClick: "onDblclick",
  htmlFor: "for",
  className: "class",
  defaultValue: "value",
  defaultChecked: "checked",
};

const toStyleString = (style) => {
  let string = "";
  for (let key in style) {
    const value = style[key];
    if (value === null || value === undefined) continue;
    if (!key.startsWith("--")) key = key.replace(/[A-Z]/g, (match) => `-${match.toLowerCase()}`);
    string += `${key}:${value};`;
  }
  return string;
};

export const normalizeProps = createNormalizer((props) => {
  return Object.entries(props).reduce((acc, [key, value]) => {
    if (value === undefined) return acc;

    if (key in propMap) {
      key = propMap[key];
    }

    if (key === "style" && typeof value === "object") {
      acc.style = toStyleString(value);
      return acc;
    }

    acc[key.toLowerCase()] = value;

    return acc;
  }, {});
});

export function spreadProps(node, attrs) {
  const oldAttrs = prevAttrsMap.get(node) || {};
  const attrKeys = Object.keys(attrs);

  const addEvent = (e, f) => {
    node.addEventListener(e.toLowerCase(), f);
  };

  const removeEvent = (e, f) => {
    node.removeEventListener(e.toLowerCase(), f);
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
      value = value || undefined;
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
  oldEvents.forEach((evt) => {
    removeEvent(evt.substring(2), oldAttrs[evt]);
  });

  attrKeys.filter(onEvents).forEach(setup);
  attrKeys.filter(others).forEach(apply);

  prevAttrsMap.set(node, attrs);

  return function cleanup() {
    attrKeys.filter(onEvents).forEach(teardown);
  };
}

export function renderPart(root, name, api) {
  const camelizedName = name.replace(/(^|-)([a-z])/g, (_match, _prefix, letter) => letter.toUpperCase());

  const part = root.querySelector(`[data-part='${name}']`);
  const getterName = `get${camelizedName}Props`;

  if (part) spreadProps(part, api[getterName]());
}
