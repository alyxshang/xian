# XIÀN :thread: :lizard:

![Zhangshield CI](https://github.com/alyxshang/xian/actions/workflows/zig.yml/badge.svg)

***A light string library for Zig. :thread: :lizard:***

## ABOUT :books:

This repository contains the source code for a package for the Zig
programming language to provide various functionality for working with
strings and string slices. ***Xiàn (线)*** is the Chinese word for "string".

## INSTALLATION :inbox_tray:

### Adding `xian` to your `build.zig.zon`

To use the ***Xiàn*** package in your Zig project, run the following command
from the root of your Zig project:

```bash
zig fetch --save git+https://github.com/alyxshang/xian
``` 

This will add the ***Xiàn*** package to your `build.zig.zon` file.

### Using `xian` in your `build.zig`

To declare the ***Xiàn*** module in your `build.zig`, the following Zig
code is required:

```Zig
const xian = b.dependency("xian", .{});
const xian_mod = xian.module("xian");
```

Depending on which modules are declared in your `build.zig` and which modules
you want to add ***Xiàn*** to, the following line is required:

```Zig
exe_mod.addImport("xian", xian_mod);
```

`exe_mod` is representative for a module for an executable you have previously
declared in your `build.zig`. Please note the following: The name used for importing
***Xiàn*** into your code corresponds to the string slice used in the function call
`addImport`.

## USAGE :hammer:

To view this package's API please clone this repository and run the command 
`zig build-lib -femit-docs src/root.zig` from the repository's root or 
view them [here](https://alyxshang.github.io/xian).

## CHANGELOG :black_nib:

### Version 0.1.0

- Initial release.
- Upload to GitHub.

## NOTE :scroll:

- *Xiàn :thread: :lizard:* by *Alyx Shang :black_heart:*.
- Licensed under the [FSL v1](https://github.com/alyxshang/fair-software-license).
