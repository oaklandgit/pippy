PipSqueak is a bespoke game and UI framework for bridging the Pippy with the companion Pippy App for iPad.

It will leverage embedded Lua as a lightweight scripting language driven by a Go runtime. Go will interpret .squeak files and transmit them over the USB Gadget mode (serial) which the iPad app will then render. Inputs and touch events from the iPad will be sent back.

Usage will be like:

```sh
pipsqueak hello.lua
```

which will parse the script and send json across the serial channel.

```json
{"type":"text","data":{"X":20,"Y":30,"Text":"Hello, Pippy!"}}
{"type":"text","data":{"X":30,"Y":40,"Text":"Testing 1, 2, 3."}}
{"type":"rect","data":{"X":10,"Y":50,"W":100,"H":40,"Color":"red"}}
{"type":"rect","data":{"X":10,"Y":1,"W":100,"H":40,"Color":"red"}}
{"type":"rect","data":{"X":10,"Y":2,"W":100,"H":40,"Color":"red"}}
{"type":"rect","data":{"X":10,"Y":3,"W":100,"H":40,"Color":"red"}}
```
