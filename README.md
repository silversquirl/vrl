# vrl

Because I couldn't come up with a better name.

## What?

vrl is a roguelike I'm writing for fun. It also sort of turned into me
learning how to use [Cython][cython].

[cython]: http://cython.org/

## Why?

Because I felt like it.

## How do I run it?

Don't. It's in a very early stage of development and might eat your
laundry. However, if you're feeling brave and have your clean underwear
safely stashed out of sight, you can try this on a system with `apt`:

```bash
# Install dependencies
sudo apt install cython3 python3-numpy libtcod-dev
# Build Cython
python3 setup.py build_ext -i
# Run the game
python3 .
```

Beware that this procedure is untested and may well not work at all. At
present, the only supported platform for vrl is my development box.
