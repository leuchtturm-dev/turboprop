import type { Machine } from "@zag-js/core";

interface ComponentInterface<Api> {
  el: HTMLElement;
  service: ReturnType<any>;
  api: Api;

  init(): void;
  destroy(): void;
  render(): void;
}

export abstract class Component<Context, Api> implements ComponentInterface<Api> {
  el: HTMLElement;
  service: ReturnType<any>;
  api: Api;

  abstract initService(context: Context): Machine<any, any, any>;
  abstract initApi(): Api;
  abstract render(): void;

  constructor(el: HTMLElement, context: Context) {
    this.el = el;
    this.service = this.initService(context);
    this.api = this.initApi();
  }

  init = () => {
    this.render();
    this.service.subscribe(() => {
      this.api = this.initApi();
      this.render();
    });
    this.service.start();
  };

  destroy = () => {
    this.service.stop();
  };
}
