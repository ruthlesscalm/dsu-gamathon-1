# DSU Gamathon — Game1

Short Godot demo game built during the DSU Gamathon. This repository contains the Godot project, scenes, scripts, and assets for a small action/adventure prototype.

## Table of Contents

- Overview
- Status
- Features
- Gameplay & Controls
- Project structure
- How to run (development)
- How to contribute
- Known issues & TODO
- Credits

## Overview

`Game1` is a small 2D action prototype made with Godot (engine config indicates Godot 4.x / 4.5 features). The project demonstrates basic player movement, attacks, enemy interactions, chest pickups, UI menus (main, pause, death), and a simple game manager autoload.

This README documents what exists in the repo and how to run and extend the project.

## Status

- Work in progress — playable prototype.
- Key systems implemented: player movement & attack, enemy scene, three chest types, menus (main/pause/death), GameManager autoload, basic HUD elements.

## Features

- Player movement and attack
- Enemies with simple behavior
- Chests: `bronze_chest`, `silver_chest`, `gold_chest`
- Menus: main menu, pause menu, death menu
- Progress / health UI assets
- Project configured for a 1280x720 window with a 480x270 viewport stretch
- Autoload `GameManager` (`scripts/game_manager.gd`)

## Gameplay & Controls

- Movement: `W`/`A`/`S`/`D` and arrow keys
- Attack: `Space` or `J`
- Pause / Menu: `Esc`

Controls are defined in `project.godot` input map (see `up`, `down`, `left`, `right`, `attack`, `esc`).

## Project structure (high level)

Top-level files and folders of interest:

- `project.godot` — Godot project config (engine version, input map, autoloads)
- `icon.svg` — project icon
- `scenes/` — main scenes and menu scenes
	- `main.tscn` — main game scene
	- `player.tscn` — player scene
	- `enemy.tscn` — enemy scene
	- `game_over.tscn` — game over / death scene
	- `chests/bronze_chest.tscn`, `silver_chest.tscn`, `gold_chest.tscn`
	- `menus/*` — UI menus (`main_menu.tscn`, `pause_menu.tscn`, `death_menu.tscn`)
- `scripts/` — GDScript source files
	- `player.gd` — player behaviour and input handling
	- `enemy.gd` — enemy logic
	- `game_manager.gd` — autoloaded game manager
	- `gold_chest.gd`, `silver_chest.gd`, `bronze_chest.gd` — chest logic
	- `progress_bar.gd`, `game_over.gd`, menu scripts
- `Assets/` — imported assets (sprites, tilesets, music)
	- `tilesets/`, `Player/`, `Enemy/`, `chest/`, `menus/`, `music/`

If you need a full file map, list the folders in your shell or file explorer.

## How to run (development)

Prerequisites:

- Godot 4.5 (project file references `4.5` in features). Using Godot 4.x is recommended.

Open and run in the Godot editor:

1. Launch Godot (4.x).
2. Open the project by selecting the folder containing `project.godot`.
3. Set the `main.tscn` (or the project default main scene) and press Play to run.

From the command line (export/run) — example on Windows (PowerShell):

```
cd "d:\Programming\Gameverse\dsu-gamathon-1"
# Open the project in Godot (adjust path to godot executable)
"C:\Program Files\Godot\Godot_v4.5-stable_win64.exe" .
```

Note: replace the Godot executable path with your local installation.

## Running an exported build

Export templates and create your build from the Godot editor using the Export menu. This repo does not currently include exported binaries.

## How to contribute

- Fork the repository and create feature branches for changes.
- Keep scripts small and focused; add descriptive names to nodes in scenes.
- If adding art or audio, include source attribution and file licenses.
- Suggested areas for help: enemy AI, level design, sound/music, polish to menus and HUD.

## Known issues & TODO

- Prototype polish needed: audio mixing, attack feedback, particle effects.
- Add unit/integration tests (Godot tests or editor tests) if desired.
- Improve enemy AI and add more diverse enemy types.
- Add README screenshots and a short demo GIF (place in `Assets/menus/` and reference here).

## Credits

- Project created during DSU Gamathon.
- Code: local team contributors.
- Assets: included in `Assets/` (check file metadata for authors and licenses).

---

If you'd like, I can also:

- Add example screenshots into the repo and reference them here.
- Create a short CONTRIBUTING.md with contribution guidelines.
- Prepare a small export profile for a Windows build.

To proceed, tell me which of the extra items you'd like me to add next.
