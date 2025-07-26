package main

import (
	"log"
	"os"
	"pipsqueak/runtime"

	lua "github.com/yuin/gopher-lua"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatalln("Usage: go run main.go <script.lua>")
	}
	scriptPath := os.Args[1]

	L := lua.NewState()
	defer L.Close()

	runtime.Register(L) // expose Go draw functions to Lua

	if err := L.DoFile(scriptPath); err != nil {
		log.Fatalf("Lua error: %v\n", err)
	}
}
