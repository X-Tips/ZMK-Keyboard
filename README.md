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

> **修改键位：**

- 支持的键盘：p20n / p31n / p48n / x35n / x36n / x3n2
- 在线改键位：连 USB 打开网站https://zmk.studio/， 实时修改，不用重新编译
- 改代码刷机：可安装本地编译环境，也可使用如下的github Actions方式编译固件
   1. 改键 - 编辑对应键盘的 .keymap 文件。
   2. 编译 - Actions → Run workflow → 选键盘型号。
   3. 下载 - 等待编译完成，下载 .uf2 文件。
   4. 刷入 - 连电脑后，按一下 Bootloader 键，或打开后盖按 Reset 两次，把 .uf2 拖进出现的 U 盘。
- 注：也在Github Codespace的终端运行bash setup.sh安装ZMK编译环境来编辑生成固件。

> **Edit Keymap**

- Supported Keyboards: p20n / p31n / p48n / x35n / x36n / x3n2

- Edit Keymap Online: Connect via USB and open https://zmk.studio/ – modify your keymap in real time, no need to recompile.

- You can build the firmware locally, or use the GitHub Actions workflow below.

   1. Edit keymap – Modify the .keymap file for your keyboard.
   2. Build – Go to Actions → Run workflow → Select your keyboard model.
   3. Download – Wait for the build to finish, then download the .uf2 file.
   4. Flash – Connect to your computer，press the Bootloader key once, or open the back cover and press Reset twice. Drag and drop the .uf2 file into the USB drive that appears.
- Alternatively, you can run `bash setup.sh` in the Github Codespace terminal to install the ZMK build environment for editing and generating firmware.