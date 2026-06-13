# X.Tips

> 愿小键盘给你带来大快乐

原创小键盘工匠室 ｜ 专注硬件极简，好用可靠的原创小键盘。
两年闲鱼 90+产品，**3000+ 单**，500+ 粉丝，L6升L7。不靠营销，只靠口碑。
https://www.goofish.com/personal?userId=137976734


> May a small keyboard bring you great joy

Original mini keyboards. Minimal hardware, built to last.
**3,000+ orders** on Xianyu in two years, L6 → L7. Word of mouth only.
URL: www.umux.com


-----------------------
# X.Tips · ZMK Firmware

> 两种进入**DFU**的方法:
- keymap里设置了Bootloader按键，按一下即可进入bl状态；
- 也可以打开后盖，快速短接两次Reset和gnd，进入bl。

> 2 ways to enter the **DFU**:
- The keymap has a Bootloader button—press it once to enter bootloader mode.
- Alternatively, open the back cover and quickly short Reset and GND twice to enter bootloader mode.

-----------------------

# ZMK Keyboard

A collection of custom keyboard definitions for ZMK firmware.

## Supported Keyboards

- p20n
- p31n
- p48n
- x35n
- x36n
- x3n2

## Firmware Build Guide

### 1. Preparation

1. **Fork this repository**: Click the Fork button in the top right corner

2. **Edit your keymap**:
   - Navigate to `p31n/p31n.keymap` or `p48n/p48n.keymap` ...
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
   - **Select keyboard to build**: Choose your keyboard (p31n or p48n)
   - **Board type**: Keep default `nrfmicro/nrf52840/zmk`

5. Click the green **Run workflow** button

### 3. Download the Firmware

1. Wait 3-5 minutes for the build to complete

2. Click on the workflow run (yellow dot ?ú green check = finished)

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
  - p31n
  - p48n
  - your_keyboard_name   # add yours here