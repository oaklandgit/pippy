PipSqueak is a bespoke game and UI framework for bridging the Pippy with the companion Pippy App for iPad.

It will leverage embedded Lua as a lightweight scripting language driven by a Go runtime. Go will interpret .squeak files and transmit them over the USB Gadget mode (serial) which the iPad app will then render. Inputs and touch events from the iPad will be sent back.
