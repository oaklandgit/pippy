package runtime

import (
	"encoding/json"
	"fmt"
)

type Command struct {
	Type string				`json:"type"`
	Data interface{}	`json:"data"`
}

type Text struct {
	X, Y int
	Text string
}

type Rect struct {
	X, Y, W, H 	int
	Color	string
}

func DrawText(text string, x, y int) {
	cmd := Command{
		Type: "text",
		Data: Text{X: x, Y: y, Text: text},
	}
	Emit(cmd)
}

func DrawRect(x, y, w, h int, color string) {
	cmd := Command{
		Type: "rect",
		Data: Rect{X: x, Y: y, W: w, H: h, Color: color},
	}
	Emit(cmd)
}

func Emit(cmd Command) {
	bytes, _ := json.Marshal(cmd)
	fmt.Println(string(bytes))
}
