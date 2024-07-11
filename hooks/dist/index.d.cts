import * as _zag_js_types from '@zag-js/types';
import * as tooltip from '@zag-js/tooltip';
import { Machine } from '@zag-js/core';
import { ViewHook } from 'phoenix_live_view';
import * as popover from '@zag-js/popover';
import * as pinInput from '@zag-js/pin-input';
import * as menu from '@zag-js/menu';
import * as dialog from '@zag-js/dialog';
import * as combobox from '@zag-js/combobox';
import { Collection } from '@zag-js/collection';
import * as collapsible from '@zag-js/collapsible';
import * as clipboard from '@zag-js/clipboard';
import * as accordion from '@zag-js/accordion';

interface ComponentInterface<Api> {
    el: HTMLElement;
    service: ReturnType<any>;
    api: Api;
    init(): void;
    destroy(): void;
    render(): void;
}
declare abstract class Component<Context, Api> implements ComponentInterface<Api> {
    el: HTMLElement;
    service: ReturnType<any>;
    api: Api;
    abstract initService(context: Context): Machine<any, any, any>;
    abstract initApi(): Api;
    abstract render(): void;
    constructor(el: HTMLElement, context: Context);
    init: () => void;
    destroy: () => void;
}

declare class Tooltip extends Component<tooltip.Context, tooltip.Api> {
    initService(context: tooltip.Context): Machine<any, any, any>;
    initApi(): tooltip.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
    onOpenChange(details: tooltip.OpenChangeDetails): void;
}
interface TooltipHook extends ViewHook {
    tooltip: Tooltip;
    context(): tooltip.Context;
}
declare const _default$8: TooltipHook;

declare class Popover extends Component<popover.Context, popover.Api> {
    initService(context: popover.Context): Machine<any, any, any>;
    initApi(): popover.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
}
interface PopoverHook extends ViewHook {
    popover: Popover;
    context(): popover.Context;
}
declare const _default$7: PopoverHook;

declare class PinInput extends Component<pinInput.Context, pinInput.Api> {
    initService(context: pinInput.Context): Machine<any, any, any>;
    initApi(): pinInput.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    clearValue(): void;
    render(): void;
    renderInputs(): void;
}
interface PinInputHook extends ViewHook {
    pinInput: PinInput;
    context(): pinInput.Context;
}
declare const _default$6: PinInputHook;

declare class Menu extends Component<menu.Context, menu.Api> {
    initService(context: menu.Context): Machine<any, any, any>;
    initApi(): menu.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
    renderItemGroupLabels(): void;
    renderItemGroups(): void;
    renderItems(): void;
    renderSeparators(): void;
}
interface MenuHook extends ViewHook {
    menu: Menu;
    context: {
        id: string;
    };
}
declare const _default$5: MenuHook;

declare class Dialog extends Component<dialog.Context, dialog.Api> {
    initService(context: dialog.Context): Machine<any, any, any>;
    initApi(): dialog.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
}
interface DialogHook extends ViewHook {
    dialog: Dialog;
    context(): dialog.Context;
}
declare const _default$4: DialogHook;

type Item = {
    value: string;
    label: string;
};
declare class Combobox extends Component<combobox.Context, combobox.Api> {
    initService(context: combobox.Context): Machine<any, any, any>;
    initApi(): combobox.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>, unknown>;
    render(): void;
    renderItems(): void;
}
interface ComboboxHook extends ViewHook {
    state: any;
    combobox: Combobox;
    attributeCache: any;
    items(): Item[];
    collection(): Collection<Item>;
    context(): combobox.Context;
}
declare const _default$3: ComboboxHook;

declare class Collapsible extends Component<collapsible.Context, collapsible.Api> {
    initService(context: collapsible.Context): Machine<any, any, any>;
    initApi(): collapsible.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
}
interface CollapsibleHook extends ViewHook {
    collapsible: Collapsible;
    context(): collapsible.Context;
}
declare const _default$2: CollapsibleHook;

declare class Clipboard extends Component<clipboard.Context, clipboard.Api> {
    initService(context: clipboard.Context): Machine<any, any, any>;
    initApi(): clipboard.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
}
interface ClipboardHook extends ViewHook {
    clipboard: Clipboard;
    context(): clipboard.Context;
}
declare const _default$1: ClipboardHook;

declare class Accordion extends Component<accordion.Context, accordion.Api> {
    initService(context: accordion.Context): Machine<any, any, any>;
    initApi(): accordion.Api<_zag_js_types.PropTypes<{
        [x: string]: any;
    }>>;
    render(): void;
    renderItems(): void;
    renderItemTrigger(item: HTMLElement, value: string): void;
    renderItemIndicator(item: HTMLElement, value: string): void;
    renderItemContent(item: HTMLElement, value: string): void;
}
interface AccordionHook extends ViewHook {
    accordion: Accordion;
    context(): accordion.Context;
}
declare const _default: AccordionHook;

declare const Hooks: {
    Accordion: AccordionHook;
    Clipboard: ClipboardHook;
    Collapsible: CollapsibleHook;
    Combobox: ComboboxHook;
    Dialog: DialogHook;
    Menu: MenuHook;
    PinInput: PinInputHook;
    Popover: PopoverHook;
    Tooltip: TooltipHook;
};

export { _default as Accordion, _default$1 as Clipboard, _default$2 as Collapsible, _default$3 as Combobox, _default$4 as Dialog, Hooks, _default$5 as Menu, _default$6 as PinInput, _default$7 as Popover, _default$8 as Tooltip };
