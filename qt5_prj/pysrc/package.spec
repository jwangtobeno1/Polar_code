#!/usr/bin/env python
# coding=utf-8

block_cipher = None

file = [
    'Call_Ui_SerialPort.py',
    'Ui_serial_main.py'
]

a = Analysis(file,
             pathex = '/hdd/Projects/Polar_code/qt5_prj/pysrc',
             binaries = None,
             datas = None,
             hiddenimports = [],
             hookspath = None,
             runtime_hooks = None,
             excludes = [],
             win_no_prefer_redirects = False,
             win_private_assemblies = False,
             cipher = block_cipher,
             noarchive = False
            )

pyz = PYZ(a.pure, a.zipped_data, cipher = block_cipher)

exe = EXE(
          pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          [],
          name='serial',
          debug = False,
          bootloader_ignore_signals = False,
          strip = False,
          upx = True,
          upx_exclude = [],
          runtime_tmpdir = None,
          console = False
         )

