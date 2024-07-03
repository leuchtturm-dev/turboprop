import type { ViewHook } from "phoenix_live_view";

class Portal {
  el: HTMLElement;
  parent: HTMLElement | null;
  target: string | null;
  screen = 0;
  mediaQuery: MediaQueryList | null = null;

  constructor(el: HTMLElement, target: string, { screen }: { screen?: number }) {
    this.el = el;
    this.parent = el.parentElement;
    this.target = target;
    if (screen) this.screen = screen;
  }

  update() {
    if (this.mediaQuery) {
      this.mediaQuery.removeEventListener("change", this.onResize);
      this.mediaQuery = null;
    }

    if (this.screen === 0) return;

    this.mediaQuery = window.matchMedia(`(${this.screen > 0 ? "min" : "max"}-width: ${Math.abs(this.screen)}px)`);
    this.mediaQuery?.addEventListener("change", this.onResize);
  }

  onResize(e: MediaQueryList | MediaQueryListEvent) {
    console.log("resizing");
    if (this.target && e.matches) {
      document.querySelector(this.target)?.appendChild(this.el);
    } else {
      this.parent?.appendChild(this.el);
    }
  }

  destroy() {
    if (this.mediaQuery) {
      this.mediaQuery.removeEventListener("change", this.onResize);
      this.mediaQuery = null;
    }
  }
}

export interface PortalHook extends ViewHook {
  portal: Portal;
}

export default {
  mounted() {
    if (!this.el.dataset.target) return;
    this.portal = new Portal(this.el, this.el.dataset.target, { screen: 400 });
    this.portal.update();
    if (this.portal.mediaQuery) this.portal.onResize(this.portal.mediaQuery);
  },

  updated() {
    this.portal.update();
    if (this.portal.mediaQuery) this.portal.onResize(this.portal.mediaQuery);
  },

  beforeDestroy() {
    this.portal.destroy();
  },
} as PortalHook;
