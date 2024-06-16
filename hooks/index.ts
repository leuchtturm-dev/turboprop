import { DialogHook } from "./dialog";
import { MenuHook } from "./menu";
import { PinInputHook } from "./pin-input";

const Hooks = {
  Dialog: DialogHook,
  Menu: MenuHook,
  PinInput: PinInputHook,
};

export { DialogHook as Dialog, MenuHook as Menu, PinInputHook as PinInput, Hooks };
