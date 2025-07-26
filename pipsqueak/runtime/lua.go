package runtime

import (
	lua "github.com/yuin/gopher-lua"
)

func Register(L *lua.LState) {
	L.SetGlobal("draw_text", L.NewFunction(func(L *lua.LState) int {
		text := L.CheckString(1)
		x := L.CheckInt(2)
		y := L.CheckInt(3)
		DrawText(text, x, y)
		return 0
	}))

	L.SetGlobal("draw_rect", L.NewFunction(func(L *lua.LState) int {
		x := L.CheckInt(1)
		y := L.CheckInt(2)
		w := L.CheckInt(3)
		h := L.CheckInt(4)
		color := L.CheckString(5)
		DrawRect(x, y, w, h, color)
		return 0
	}))
}
