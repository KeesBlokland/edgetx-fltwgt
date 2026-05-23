-- FltWgt main.lua — Universal Flight Widget for TX16S MK3
-- Version: 0.1.00 — 23 May 2026
-- Step 1: LVGL skeleton — static placeholder values, confirms layout

local WIDGET_NAME = "FltWgt"
local COLS = 3
local ROWS = 2

-- Layout config — change col/row/span/font here, not in drawing code
-- Step 2 will add sensor reads; Step 4 moves this table to top of file
local SCREENS = {
  [1] = {  -- Power
    { row=1, col=1, span=2, font=DBLSIZE, text="12.6V"   },
    { row=1, col=3, span=1, font=MIDSIZE, text="18.4A"   },
    { row=2, col=1, span=1, font=MIDSIZE, text="1240mAh" },
  },
  [2] = {  -- Flight Data
    { row=1, col=1, span=2, font=DBLSIZE, text="142m"    },
    { row=1, col=3, span=1, font=MIDSIZE, text="87km/h"  },
    { row=2, col=1, span=1, font=MIDSIZE, text="+2.4m/s" },
    { row=2, col=3, span=1, font=MIDSIZE, text="04:32"   },
  },
}

local function buildUI(widget)
  local z   = widget.zone
  local cw  = z.w / COLS
  local rh  = z.h / ROWS
  local scr = SCREENS[widget.options.Screen] or SCREENS[1]

  -- Black background fills widget zone
  lvgl.rectangle({ x=0, y=0, w=z.w, h=z.h, color=BLACK, filled=true })

  -- One label per cell; refs stored for Step 2 live updates
  widget.labels = {}
  for _, cell in ipairs(scr) do
    local cx = (cell.col - 1) * cw
    local cy = (cell.row - 1) * rh
    local cw_cell = cw * cell.span
    local lbl = lvgl.label({
      x     = math.floor(cx + cw_cell * 0.1),
      y     = math.floor(cy + rh * 0.25),
      text  = cell.text,
      font  = cell.font,
      color = WHITE,
    })
    table.insert(widget.labels, { obj=lbl, cell=cell })
  end
end

local function update(widget, options)
  widget.options = options
  lvgl.clear()    -- destroy previous objects before rebuild
  buildUI(widget)
end

local function create(zone, options)
  local widget = { zone=zone, options=options }
  update(widget, options)
  return widget
end

local function background(widget) end

local function refresh(widget, event, touchState)
  -- Step 1: static text, nothing to update
  -- Step 2: update widget.labels[i].obj:set({text=...}) from sensors here
end

return {
  name       = WIDGET_NAME,
  options    = { { "Screen", VALUE, 1, 1, 2 } },
  create     = create,
  update     = update,
  background = background,
  refresh    = refresh,
  useLvgl    = true,
}
