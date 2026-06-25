#!/bin/bash
# Build Celeste ELF binary for the ESP32-P4 (RISC-V).

set -e

TC="$HOME/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin"
GCC="$TC/riscv32-esp-elf-gcc"
STRIP="$TC/riscv32-esp-elf-strip"
NM="$TC/riscv32-esp-elf-nm"

MARCH=rv32imafc_zicsr_zifencei
MABI=ilp32f

echo "Building celeste.elf..."

"$GCC" \
  -march=$MARCH -mabi=$MABI \
  -O2 \
  -DESP_PLATFORM \
  -I local_include \
  -Dmain=app_main \
  -nostartfiles -nostdlib \
  -fPIC -shared \
  -fvisibility=hidden \
  -Wl,-e,app_main \
  -Wl,--gc-sections \
  main.c player.c level.c vfx.c gfx_esp32.c sprites.c \
  -o celeste.elf

echo "Stripping..."
"$STRIP" --strip-all -o celeste-stripped.elf celeste.elf

echo "Potential required exports:"
"$NM" -u celeste.elf
