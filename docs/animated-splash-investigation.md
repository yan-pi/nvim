# Animated Splash Investigation

Notes on options for the Neovim start-screen splash animation, written while
swapping between [`milli.nvim`](https://github.com/Amansingh-afk/milli.nvim)
and a hypothetical port of
[`amp-animator`](https://github.com/sollus-labs/amp-animator).

## Status

milli.nvim is wired but currently commented out in
`lua/plugins/mini.lua` (look for the `Animated splash` block). The
`amansingh-afk/milli.nvim` plugin is still declared as a dependency of
`mini.nvim`, so re-enabling is just uncommenting.

## What we tried first: milli.nvim

milli ships pre-rendered ASCII frames (generated offline from images / GIFs
via the `milli` CLI) and paints them into a buffer using extmarks. Twenty-nine
splashes bundled. It plumbs into `dashboard-nvim`, `alpha-nvim`,
`snacks.nvim`, `mini.starter`, and raw `VimEnter` via small autocmd presets.

Pros:

- Drop-in. No build toolchain, no runtime cost beyond extmark painting.
- Custom splashes via `milli export <image>.gif -t lua -w 60`.

Cons:

- Frame dimensions are baked at export time. `cols` / `rows` come from the
  source asset; **no proportional resize at runtime.**
- Loop length is fixed by the source GIF — animations repeat.
- To shrink a bundled splash you have to regenerate from the original asset
  via the CLI, which means having that asset.

We hit (2) and (3) trying to fit the `shader` splash on a smaller window;
the fix was to pick a smaller bundled splash (`blackhole`, 50×14) rather
than resize.

## The amp-animator angle

[`amp-animator`](https://github.com/sollus-labs/amp-animator) is a Rust
binary — *not* a Neovim plugin. It renders a procedural orb live in the
terminal: 2D OpenSimplex noise sampled into an intensity grid, mapped to an
ASCII ramp `" .:-=+*#%@"` and an orange gradient. Press any key to exit.

The crate's architecture is a clean separation that's relevant to us:

```
src/
├── orb.rs       simplex noise -> Vec<Vec<Cell { ch, color }>>   (pure)
├── palette.rs   intensity -> Rgb gradient                        (pure)
├── fetch.rs     fastfetch cache + ANSI shifting                  (pure)
└── ui.rs        terminal driver (alt-screen, raw mode, paint)    (side-effects)
```

`orb.rs` and `palette.rs` are pure, deterministic given config + time, and
property-tested. The "screensaver" concern (raw mode, keypress dismissal,
terminal ownership) lives entirely in `ui.rs`. So the procedural part *can*
in principle be reused outside the binary's terminal-driver context.

`OrbConfig` exposes `width`, `height`, `scale`, `speed`, `seed` — which
incidentally solves the proportional-resize gap milli has.

## Integration paths

Three ways to get the procedural orb into a Neovim start screen, ordered
by effort:

### 1. Lua port of `orb.rs` + `palette.rs` *(recommended)*

Port the pure modules to Lua. ~150 LOC total:

- OpenSimplex 2D noise. Existing pure-Lua ports exist (love2d / libtcod
  community); audit for license + correctness.
- Intensity ramp + char mapping (trivial).
- Orange gradient palette (trivial linear interpolation).
- Render loop driven by `vim.uv.new_timer`; each tick computes a frame and
  writes it to the buffer with extmarks (same trick milli uses), then
  schedules the next.

Pros:

- No build toolchain. Pure Lua, portable.
- `width` / `height` are runtime parameters — proportional resize falls out
  for free.
- True procedural infinite animation (no looping).
- Dimensions / seed / speed all configurable per-machine via
  `vim.g.amp_animator_*`.

Cons:

- Have to write or vet a Lua simplex implementation.
- Per-frame Lua math: ~`width * height` calls into noise + char/colour
  mapping. For the default 30×15 grid at ~15 FPS that's 6,750 noise samples
  per second — should be fine but worth measuring before committing.
- License attribution: amp-animator is MIT, port is fine, must credit.

### 2. Compile the crate as `cdylib`, call via FFI

Use mlua / nvim-rs to bind the Rust crate. Keeps the noise math in Rust.

Pros: keeps proven Rust impl; fastest.

Cons: requires Rust toolchain on every machine that loads the config;
upstream crate currently builds only as a binary, would need a fork or PR
adding `[lib] crate-type = ["cdylib"]`; FFI marshalling overhead per frame;
Lua↔Rust ABI fragility across versions.

Verdict: too heavy for what is effectively decoration.

### 3. Modify upstream to export pre-rendered frames

Add a `--export frames.lua` mode to amp-animator that emits the same
`{ cols, rows, frames, colors }` shape milli uses. Then it becomes just
another milli splash.

Pros: zero new infra in the nvim config; reuses milli's painter.

Cons: loses the live-procedural property — animation cycles instead of
flowing forever; still doesn't get runtime resize (output dims are fixed
at export time, same problem we already had with milli); needs upstream
PR or fork.

Verdict: not aligned with what makes amp-animator interesting in the first
place.

## Recommendation

Park it. The procedural orb is a nice idea but the value is decorative,
and option 1 — the only one worth doing — is ~150 LOC of Lua plus a
simplex noise audit. Worth doing if and when there's appetite; not worth
doing because the current splash is "still too big".

If we revisit: start by measuring whether a pure-Lua simplex impl can
sustain 15 FPS at 30×15 in Neovim. If yes, the rest is trivial. If no,
abandon and just regenerate a smaller milli splash from a source asset.

## Re-enabling milli in the meantime

In `lua/plugins/mini.lua`, uncomment the `Animated splash` block. Set
`vim.g.milli_splash` in `init.lua` if you want a splash other than
`blackhole`. List bundled options:

```vim
:lua print(vim.inspect(require('milli').list()))
```

Preview before committing:

```vim
:MilliPreview <name>
```

## Links

- milli.nvim: https://github.com/Amansingh-afk/milli.nvim
- milli engine: https://github.com/Amansingh-afk/milli
- amp-animator: https://github.com/sollus-labs/amp-animator
