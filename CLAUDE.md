# CLAUDE.md — EdgeTX FltWgt
# Version: 1.0.00 — 23 May 2026
# Universal flight widget for RadioMaster TX16S MK3 running EdgeTX 2.11+

## Project
- Widget folder on TX: /WIDGETS/FLTWGT/
- Entry point: main.lua
- Display name: FltWgt
- Two screens (swipe): Screen 1 Power, Screen 2 Flight Data
- Plan document: edgetx_widget_plan.md

## Hardware
- Radio: RadioMaster TX16S MK3 / MK3 MAX
- Screen: 800x480 IPS, landscape
- EdgeTX: 2.11+ (LVGL required)
- Telemetry: RadioMaster sensors + oXs (mstrens, RP2040-based)

## Gitea repo
- http://192.168.2.7:3000/kees/edgetx-fltwgt

## Development sequence
1. Skeleton widget — LVGL structure, two screens, grid renderer, static placeholders
2. Sensor wiring — real sensor reads, graceful absent-sensor handling
3. Visual refinement — fonts, spacing, color thresholds on hardware
4. Config table — all layout params in one table at top of file
5. Field test

## Before Step 2
Confirm actual sensor names from oXs output in EdgeTX telemetry sensor list.
Expected: VFAS/Volt, Curr, Capa, Alt, GSpd/ASpd, VSpd — verify before coding.

## Key references
- LVGL API: https://luadoc.edgetx.org/lua-api-reference/lvgl-for-lua/api
- Widget scripts: https://luadoc.edgetx.org/overview/script-types/widget-scripts
- oXs project: https://github.com/mstrens/oXs_on_RP2040
