# EdgeTX Universal Flight Widget Plan
**Version: 1.1.00**
**Date: 23 May 2026**
**Purpose: Plan for a universal flight widget for TX16S MK3, covering all model types**

---

## Hardware Context

| Property | Value |
|---|---|
| Radio | RadioMaster TX16S MK3 / MK3 MAX |
| Screen | 800x480 IPS, landscape |
| EdgeTX version | 2.11+ (LVGL required) |
| Telemetry sources | RadioMaster sensors + oXs (mstrens, RP2040-based) |
| Link protocol | TBD per model — assume CRSF/ExpressLRS |

---

## Design Philosophy

- Dark background, high-contrast bright text — sunlight readability over aesthetics
- No bling, no gradients, no decorative elements
- Large fonts for primary values, smaller for secondary
- Graceful degradation: if a sensor is absent, that cell is blank or shows "---"
- Voice announcements handled separately via EdgeTX Special Functions — not in the widget
- One universal widget, fixed folder name, works across all model types
- Layout is grid-based with configurable cell positions and font sizes (future-proof)

---

## Widget Identity

| Property | Value |
|---|---|
| Folder | `/WIDGETS/FLTWGT/` |
| File | `main.lua` |
| Display name | `FltWgt` |
| Screens | 2 (swipe between them in EdgeTX main views) |

The widget is placed on two separate EdgeTX main views. Each view is a separate
widget instance, both using the same `main.lua`, distinguished by an option setting.

---

## Screen 1 — Power

Primary screen. Always the first thing visible when you pick up the radio.

| Cell | Value | Font size | Notes |
|---|---|---|---|
| Top-left large | Flight battery voltage | Large | Highest priority |
| Top-right | Current (Amps) | Medium | Hidden if sensor absent |
| Bottom-left | Consumed mAh | Medium | Hidden if sensor absent |
| Bottom-right | (reserved) | — | Future use |

**Design detail to discuss:** voltage display — total pack voltage, or per-cell average?
Both useful, total is simpler, per-cell is more meaningful for LiPo health.

---

## Screen 2 — Flight Data

Secondary screen. Timer lives here.

| Cell | Value | Font size | Notes |
|---|---|---|---|
| Top-left large | Altitude | Large | GPS or baro, whichever is present |
| Top-right | Speed | Medium | GPS groundspeed or airspeed |
| Bottom-left | Variometer | Medium | Climb/sink rate — gliders especially |
| Bottom-right | Timer | Medium | EdgeTX Timer 1 |

---

## Sensor Handling

The widget reads sensors by name at startup and stores references.
If a sensor is not found, the corresponding cell displays `---` and does not error.

Sensor names to be confirmed against actual oXs output and RadioMaster sensor list.
Likely candidates (subject to change):

| Data | Expected sensor name | Source |
|---|---|---|
| Pack voltage | `VFAS` or `Volt` | ESC / oXs |
| Current | `Curr` | ESC / oXs |
| Consumed mAh | `Capa` | ESC / oXs |
| Altitude | `Alt` | oXs baro |
| Speed | `GSpd` or `ASpd` | oXs GPS / pitot |
| Variometer | `VSpd` | oXs |

**Action before coding:** connect oXs, check actual sensor names in EdgeTX
telemetry sensor list, and update this table.

---

## Grid Layout System

Each screen is treated as a grid. Cell position and font size are defined in a
configuration table at the top of `main.lua`, not hardcoded in the drawing logic.

This means:
- Moving a value to a different position = change one line in the config table
- Changing font size = change one line in the config table
- No hunting through drawing code to adjust layout

Example config structure (not final):

```lua
local SCREEN1 = {
  { id="volt",  row=1, col=1, span=2, font=DBLSIZE, label="V"   },
  { id="curr",  row=1, col=3, span=1, font=MIDSIZE, label="A"   },
  { id="capa",  row=2, col=1, span=1, font=MIDSIZE, label="mAh" },
}
```

Font sizes available in EdgeTX Lua: `SMLSIZE`, `STDSIZE`, `MIDSIZE`, `DBLSIZE`, `XXLSIZE`

Grid dimensions and cell pixel sizes will be calculated from `zone.w` and `zone.h`
multiplied by `lvgl.LCD_SCALE` — no hardcoded pixel values.

---

## What We Still Need to Discuss (per screen, per value)

Before writing layout code, for each cell we need to agree on:

1. Font size
2. Show label/unit alongside value, or not (e.g. "12.4V" vs just "12.4")
3. Color coding — e.g. voltage turns red below threshold
4. Warning thresholds — at what voltage/mAh do we want visual alert
5. Number of decimal places per value
6. Whether per-cell average voltage is shown instead of (or alongside) pack total

This is a short conversation per screen, not a long one.

---

## Development Sequence

### Step 1 — Skeleton widget
- LVGL structure, two-screen option, grid renderer, no real sensors
- Displays static placeholder values
- Confirms layout and font sizes look right on hardware

### Step 2 — Sensor wiring
- Connect real sensor reads
- Graceful handling of absent sensors
- Test with actual oXs output

### Step 3 — Visual refinement
- Adjust font sizes, spacing, color thresholds based on what you see on hardware
- Sunlight readability check

### Step 4 — Config table
- Move all layout parameters into config table at top of file
- Verify moving a cell or changing font size is a one-line change

### Step 5 — Field test
- Fly, check readability and usefulness
- Adjust thresholds and layout based on actual use

---

## Out of Scope (for now)

- Voice announcements — handled by EdgeTX Special Functions, not the widget
- Link quality display
- Third screen
- Model-specific configuration files
- oXs configuration — separate project, must align sensor names with EdgeTX expectations

---

## Reference

- LVGL API: https://luadoc.edgetx.org/lua-api-reference/lvgl-for-lua/api
- Widget Scripts overview: https://luadoc.edgetx.org/overview/script-types/widget-scripts
- oXs project: https://github.com/mstrens/oXs_on_RP2040
- EdgeTX lua-scripts gallery: https://github.com/EdgeTX/lua-scripts
