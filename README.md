HammerBlade Examples
====================

This is a collection of self-contained, hackable, documented examples for running on HammerBlade on F1.


Running the Examples
--------------------

Then, the best way to actually run the examples is with [Chazz][].
Set it up, then do something like this to send this repository to the server:

    $ chazz -i v1.0.0 sync -w . mystuff

Then, in another terminal, type `chazz -i v1.0.0 ssh` and then:

    $ cd mystuff
    $ make -C noop run

Each example comes with a `run` target in its Makefile, so just type `make run` to build and execute the example.
The current version of the HammerBlade image (v1.0.0) has a bug where, after running a program on the device, it locks up and you can't run another program.
That's while you'll see an `fpga-load-local-image` command in each `run` recipe: this resets the FPGA so another program can execute.

[chazz]: https://github.com/cucapra/chazz


The Examples
------------

The examples are arranged in order of increasing complexity:

- `noop`: Just execute a function on the device that does literally nothing at all.
- `add`: Add together two integers passed via DRAM. Shows how to "malloc" space on the device, "memcpy" input data into this space, pass arguments to device-side functions, and copy outputs back out from the device.
- `report`: Get the SPMD-style identifying information for every tile in a group. Demonstrates such mysterious magic as `__bsg_id` and `__bsg_grid_dim_x`.


Tips for Hacking Locally
------------------------

For more enjoyable hacking, you'll want to get [HammerBlade F1 headers][hbf1lib] and [manycore headers][mclib] and set your editor's include path to point to them.
These examples currently target v1.0.0, so do something like this:

    $ git clone https://github.com/bespoke-silicon-group/bsg_f1.git
    $ cd bsg_f1
    $ git checkout 92643b8
    $ cd ..
    $ git clone https://github.com/bespoke-silicon-group/bsg_manycore.git
    $ cd bsg_manycore
    $ git checkout 8241449

On a Mac, I had to make a few changes to make things compile: within `bsg_f1/cl_manycore/libraries`, delete the entire contents of `bsg_manycore_features.h`, leaving an empty file, and change every occurrence of `#include <endian.h>` to `#include <machine/endian.h>`.

Then, configure your editor to add these include paths (starting from wherever you checked out the two repositories):

    bsg_f1/cl_manycore/libraries
    bsg_manycore/software/bsg_manycore_lib

The former has headers for host code, and the latter has headers for device code.

[hbf1lib]: https://github.com/bespoke-silicon-group/bsg_f1/tree/master/cl_manycore/libraries
[mclib]: https://github.com/bespoke-silicon-group/bsg_manycore/tree/master/software/bsg_manycore_lib
