package main

import (
	"github.com/yuin/gopher-lua"
	"pipsqueak/runtime"
)

func main() {
	L := lua.NewState()
	defer L.Close()

	runtime.Register(L) // expose Go draw functions to Lua

	if err := L.DoFile("scripts/hello.lua"); err != nil {
		panic(err)
	}
}
