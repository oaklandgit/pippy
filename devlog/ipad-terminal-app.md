# Finding the right iPad terminal app for interfacing with the Pi

First tried Termius, which worked ok until I decided I wanted the Pippy ecosystem to support images in the terminal. There's something called the Terminal Image Protocol that allows this, but it must be supported by the terminal. Despite various claims of support, I've only ever had luck in certain MacOS terminals (Kitty, the creator of the protocol, and iTerm2) but not Termius on the iPad.

Luckily, I found a single search result on Y Combinator mentioning this gem: [La Terminal](https://apps.apple.com/us/app/la-terminal-ssh-client/id1629902861), which not only supports the image protocol, but is overall better-implemented than Termius IMO. (One example being more customization options).
