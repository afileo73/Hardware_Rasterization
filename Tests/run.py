#!/usr/bin/env python3

"""
Run all VUnit VHDL unit tests in this folder
"""

from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv(compile_builtins=False)
VU.add_vhdl_builtins()
p = Path(__file__).parent
p = p.parent
VU.add_library("lib").add_source_files(p / "source" / "Loader" / "*.vhd")
VU.add_library("lib_tb").add_source_files(Path(__file__).parent / "*.vhd")
VU.main()
