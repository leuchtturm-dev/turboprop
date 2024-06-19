import * as _zag_js_types from '@zag-js/types';
import * as pinInput from '@zag-js/pin-input';
import { Machine } from '@zag-js/core';
import { ViewHook } from 'phoenix_live_view';
import * as menu from '@zag-js/menu';
import * as dialog from '@zag-js/dialog';
import * as combobox from '@zag-js/combobox';
import { Collection } from '@zag-js/collection';
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
declare const _default$4: PinInputHook;

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
declare const _default$3: MenuHook;

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
declare const _default$2: DialogHook;

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
declare const _default$1: ComboboxHook;

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
    Combobox: ComboboxHook;
    Dialog: DialogHook;
    Menu: MenuHook;
    PinInput: PinInputHook;
};

export { _default as Accordion, _default$1 as Combobox, _default$2 as Dialog, Hooks, _default$3 as Menu, _default$4 as PinInput };
