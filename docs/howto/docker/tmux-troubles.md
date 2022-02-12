# Tmux Troubleshooting

Try to log trouble what i stumble on.

## Docker shortcuts

When you notice that you bash prompt do not accept inputs, thats probably beacuase you have accedental turn off flow control by keyboard shortcuts `Ctrl + q`

You can turn on flow control by pressing `Ctrl + q`, which will allow you to see what you are typing again.

> I had to allow tty to disable flow control and that in this turn of the functionality to exit docker container with `Ctrl + q`
> You need to type exit in shell to terminate the docker container or just use `<tmux prefix> + d`
