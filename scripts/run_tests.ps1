# Runs GUT tests headless. Exits non-zero if any test fails.
# Set the GODOT env var to your Godot exe if "godot" isn't on your PATH, e.g.:
#   $env:GODOT = "C:\Tools\Godot\Godot_v4.3-stable_win64.exe"

$godot = if ($env:GODOT) { $env:GODOT } else { "godot" }

& $godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
exit $LASTEXITCODE
