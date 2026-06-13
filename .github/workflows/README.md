# ZMK Keyboard

A collection of custom keyboard definitions for ZMK firmware.

## Supported Keyboards

- p20n
- p31n

## Firmware Build Guide

### 1. Preparation

1. **Fork this repository**: Click the Fork button in the top right corner

2. **Edit your keymap**:
   - Navigate to `p20n/p20n.keymap` or `p31n/p31n.keymap`
   - Click the pencil icon to edit
   - Modify the keymap to your preference
   - Click **Commit changes** to save

> ? Need help with keymaps? Check out the [ZMK Keymap Documentation](https://zmk.dev/docs/keymaps)

### 2. Build the Firmware

1. Go to your forked repository and click the **Actions** tab

2. Find **Build ZMK Firmware** in the left sidebar and click it

3. Click the **Run workflow** dropdown button

4. In the popup window:
   - **Branch**: Keep `main` (default)
   - **Select keyboard to build**: Choose your keyboard (p20n or p31n)
   - **Board type**: Keep default `nrfmicro/nrf52840/zmk`

5. Click the green **Run workflow** button

### 3. Download the Firmware

1. Wait 3-5 minutes for the build to complete

2. Click on the workflow run (yellow dot ¡ú green check = finished)

3. Scroll down and download the zip file from **Artifacts**

4. Unzip to get the `.uf2` firmware file

### 4. Flash the Firmware

1. **Enter bootloader mode**:
   - Hold the **RESET** button while connecting USB
   - Or quickly press RESET twice
   - A USB drive named `NICENANO` or `RPI-RP2` will appear

2. **Flash**: Drag and drop the `.uf2` file into that USB drive

3. **Done**: Your keyboard will reboot with the new keymap

### 5. ZMK Studio Support

This firmware includes ZMK Studio support for live keymap editing:

1. Flash the firmware and connect via USB
2. Open [https://zmk.studio](https://zmk.studio)
3. Click connect - edit your keymap instantly, no recompilation needed!

### 6. Adding a New Keyboard

Add your keyboard to `.github/workflows/build.yml` under `options`:

```yaml
options:
  - p20n
  - p31n
  - your_keyboard_name   # add yours here