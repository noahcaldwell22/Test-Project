# Project: Medieval Roguelike (Godot 4)

## Overview
A medieval-themed roguelike built in Godot 4 with GDScript.
Targets: Steam (desktop) and web export.

## Conventions
- GDScript only. Use static typing (`var hp: int = 10`, `func hit(dmg: int) -> void:`).
- One script per scene, named to match (`player.tscn` -> `player.gd`).
- Communicate between nodes with signals, not hard node-path references.
- Game data (items, enemies, loot tables) lives in `data/` as Resources or JSON, not hard-coded.
- Keep functions short and single-purpose.
- Web export has limits: avoid threads and heavy per-frame allocations.

## Folder layout
- `scenes/`   scenes (.tscn)
- `scripts/`  shared scripts and tools
- `data/`     items, enemies, loot tables
- `tests/`    GUT tests (files named `test_*.gd`)
- `addons/gut/` GUT test framework (do not edit)

## Running tests (Windows / PowerShell)
    ./scripts/run_tests.ps1

## Workflow
1. Work on a feature branch, never directly on main.
2. After any code change, run the tests and fix failures before finishing.
3. Add or update a test for every new system or bug fix.
4. Before asking for review, summarize what changed and why.

## Rules
- Do not edit `.godot/`, `addons/`, or `project.godot` unless asked.
- Never delete files without asking.
