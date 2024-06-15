# Changelog

## Unreleased

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
