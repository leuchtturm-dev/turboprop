# Changelog

## Unreleased

## Added

- New hook: `Turboprop.Hooks.Clipboard`.
- New hook: `Turboprop.Hooks.Collapsible`.

## 0.4.1 - 2024-06-19

## Fixed

- Fixed npm config.

## 0.4.0 -- 2024-06-19

## Breaking Changes

- Variants declarations are now using keyword maps everywhere instead of a mix of maps and keyword lists.
- Hooks no longer come with helper functions in Elixir. These have been removed.
- PinInput events now send the full details object given by Zag.

## Added

- New hook: `Turboprop.Hooks.Accordion`.
- New hook: `Turboprop.Hooks.Combobox`.
- Hooks are now written in TypeScript and are fully typed.
- Hook attributes are now properly validated and any errors output in the browser console.
- Hooks no longer come with helper functions in Elixir. These have been removed.
- PinInput events now send the full details object given by Zag.
- Hook examples no longer include styling.

## Changed

- Variants declarations are now using keyword maps everywhere instead of a mix of maps and keyword lists.

## 0.3.1 -- 2024-06-16

## Fixed

- Add forgotten `start_link/1` method to cache.

## 0.3.0 -- 2024-06-15

## Changed

- Use ETS for caching. This requires adding `Turboprop.Cache` to the supervision tree.
- Updated Zag

## 0.2.1 -- 2024-06-14

### Fixed

- Do not raise when a non-existent variant option is passed as string.
- Apply class overrides last

## 0.2.0 - 2024-06-12

### Added

- New hook: `Turboprop.Hooks.Dialog`
- New tool: `Turboprop.Variants`

### Changed

- Updated Zag

## 0.1.4 - 2024-06-11

### Added

- New hook: `Turboprop.Hooks.PinInput`

## 0.1.3 - 2024-06-10

Initial release.
