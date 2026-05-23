# EdgeTX LVGL Lua API Reference
# Saved: 23 May 2026
# Source: https://luadoc.edgetx.org/lua-api-reference/lvgl-for-lua/api

## Widget declaration

```lua
return {
  name    = "MyWidget",
  create  = create,
  update  = update,
  refresh = refresh,
  background = background,
  useLvgl = true   -- required to activate lvgl object
}
```

## Function lifecycle

- `create(zone, options)` — initialize widget table; call update() to build initial UI
- `update(widget, options)` — **primary place for LVGL object construction**; call lvgl.clear() first then rebuild
- `refresh(widget, event, touchState)` — runtime value updates only (lbl:set()); NO object creation here
- `background(widget)` — called when widget not visible

## Coordinate system

- Origin (0,0) = top-left of widget zone, NOT full screen
- zone.w × zone.h = widget area

## Object creation syntax

```lua
lvgl.function([parent], {settings})
-- parent optional; if omitted, created in widget's top-level window
```

## Common settings (all objects)

| Name    | Type     | Default        |
|---------|----------|----------------|
| x       | number   | 0              |
| y       | number   | 0              |
| w       | number   | auto (content) |
| h       | number   | auto (content) |
| color   | color    | theme default  |
| pos     | function | nil            |
| size    | function | nil            |
| visible | function | nil            |

Settings defined as functions are called periodically — UI auto-updates when return value changes.

## Object types

LABEL, RECTANGLE, CIRCLE, ARC, HLINE, VLINE, LINE, TRIANGLE, IMAGE, QRCODE,
BOX, BUTTON, MOMENTARY_BUTTON, TOGGLE, TEXT_EDIT, NUMBER_EDIT, CHOICE,
SLIDER, VERTICAL_SLIDER, PAGE, FONT, ALIGN, COLOR, TIMER, SWITCH, SOURCE,
FILE, SETTING

## Label

```lua
local lbl = lvgl.label({
  x=10, y=10,
  text="Hello",
  font=MIDSIZE,    -- SMLSIZE STDSIZE MIDSIZE DBLSIZE XXLSIZE
  color=WHITE,
})

-- Runtime update:
lbl:set({ text="Updated", color=RED })
```

## Rectangle (filled)

```lua
lvgl.rectangle({
  x=0, y=0, w=100, h=40,
  color=BLACK, filled=true,
  -- also: thickness, rounded, opacity
})
```

## UI rebuild pattern

```lua
local function update(widget, options)
  widget.options = options
  lvgl.clear()      -- destroy all previous objects (avoids duplicates)
  buildUI(widget)   -- recreate from scratch
end

local function create(zone, options)
  local widget = { zone=zone, options=options }
  update(widget, options)  -- builds initial UI
  return widget
end
```

## Layout helpers

```lua
lvgl.LCD_SCALE        -- scale factor vs default 480x272
lvgl.PERCENT_SIZE     -- e.g. lvgl.PERCENT_SIZE+80 = 80% of parent (needs parent w/h defined)
lvgl.UI_ELEMENT_HEIGHT
lvgl.PAGE_BODY_HEIGHT
```

## Dynamic query

```
GET https://luadoc.edgetx.org/lua-api-reference/lvgl-for-lua/api.md?ask=<question>
```
