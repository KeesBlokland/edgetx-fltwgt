# EdgeTX Widget Scripts Reference
# Saved: 23 May 2026
# Source: https://luadoc.edgetx.org/overview/script-types/widget-scripts

## File location

/WIDGETS/<foldername>/main.lua
- Folder name: max 8 characters
- Folder name = FLTWGT for this project

## Required return table

```lua
return {
  name       = "FltWgt",    -- max 10 chars, shown in widget menu
  options    = options,
  create     = create,
  update     = update,
  refresh    = refresh,
  background = background,
  useLvgl    = true,        -- add for LVGL widgets
}
```

## Functions

### create(zone, options) — REQUIRED
- Called once when widget instance registers
- zone: { x, y, w, h } — widget area; full screen = LCD_W × LCD_H
- options: initial settings table
- Returns: widget table (add instance vars here)

### refresh(widget, event, touchState) — REQUIRED
- Called periodically when visible
- event: 0 normally; key/touch events in full-screen mode only
- For LVGL: update label values here, no object creation

### update(widget, options) — optional
- Called when user changes widget settings
- For LVGL: clear and rebuild LVGL objects here

### background(widget) — optional
- Called periodically when widget is not visible

## Options table

```lua
local options = {
  { "Label", TYPE, default, [min], [max] },
}
-- Types: SOURCE, BOOL, VALUE, COLOR, STRING
-- VALUE example: { "Screen", VALUE, 1, 1, 2 }
```

User changes trigger update(). Lua modifications to options don't persist.

## Zone

- Normal: zone.w × zone.h (updates if screen layout changes)
- Full screen: LCD_W × LCD_H
- For LVGL: coordinates (0,0) = top-left of zone

## Variable scope

Local vars outside functions are **shared across all widget instances**.
Instance-specific vars must go in the widget table returned by create().
