# gdb snap

This snap encapsulates gdb as a snap so it can be used in Ubuntu Core
systems. It needs to be installed with `--devmode` for the moment.

To use it, run

`sudo abeato-gdb.gdb /snap/bin/<program_to_debug>`

As this command actually runs "`snap run ...`", then `snap-confine`, it
cannot load initially the symbols from `<program_to_debug>`, but you can
still set breakpoints in the target, just make sure to answer `y` when
gdb asks:

`Make breakpoint pending on future shared library load? (y or [n])`

It is also possible to use it with executables not installed by a snap.
In that case, `sudo` is not necessary, and you can simply run

`abeato-gdb.gdb <program_to_debug>`.

The snap includes the symbols for glibc for core16, core18, and core20
bases. The right symbols get automatically loaded when necessary.
