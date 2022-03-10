## MPVShow
An mpv plugin to present videos as slideshows.

Clone the repo and copy MPVShow.lua to 
`.config/mpv/scripts` folder (if it doesnt exist make it),
alternatively one can specify the location using `--script` 
when calling `mpv`

MPVShow looks for a filename `yourawesomevideo.mp4.slinfo` in the current directory
when you play  `youraweomsevideo.mp4`, This
`.slinfo` file contains the information about the 
timestamps in the video as slides,if `.slifno` file is not found it plays the file like a 
normal video, Info on how to make
the `.slinfo` file follows...


## Usage
The `.slinfo` file is a list of timestamps to mark 
end of a slide. Every line should be of the form
```
num [loop]
```
Where `num` is a timestamp (a number), followed by an optional keyword `loop`.

The video while playing is paused when it reaches `num` timestamp
indicating end of that slide.
If it reaches a `num loop` the player loops that slide infinitely.
Check Keybindings to see how to navigate through slides.

First entry should always be 0 , 
Last entry should always be "end",
end means the ending timestamp of the video,

For some reason , right now the end slide cannot have `loop`
there is also a bug where hitting `b` when the video has finished
playing causes it to go the beginning of the previous slide
(as opposed to the normal behaviour of going to begining of the
current slide that just played)

Check Example at the end of this file

Make your `yourawesomevideo.mp4.slinfo` in the same directory
as `yourawesomevideo.mp4`.

__The `.slinfo` file must be in the current directory where `mpv` is being run.__

```
 mpv  yourawesomevideo.mp4
```

You may also want to pass `--no-osd-bar` to avoid annoying
osdbar while seeking , You may also pass `--no-osc-bar`
to disable the onscreen controller.

## Keybindings
Press `m` to continue to playing slide when paused
at slide . If in a looped slide `m` will remove the loop
smoothly finish the current slide and move onto the next slide
.
("default `m` is to mute/unmute ive overriden that
if you want some other key feel free to change it 
MPVShow.lua")

`n` will to go to next slide. 

`b` will replay the last slide  if paused at end of a non-loop slide,
or will go to the previous slide if looping the current slide


__Any seek (for example with arrow keys) except `n`/`b` will mess with internal
state of the plugin , you must use only `n` and `b` to navigate the video__

## Example

```
0 
5 
10 loop
16 
22 loop
25
end
```
Save the above in a file named `yourawesomevideo.mp4.slinfo` in the same directory as `yourawesomevideo.mp4`,
run
`mpv yourawesomevideo.mp4`
* video starts and is paused
* press `m`       -> video is unpaused an plays till timestamp 5 where it pauses
* press `m` again -> video plays but loops from timestamp 5 to 10
* press `m` again -> removes the loop, continues to timestamp 10 and over to next slide and pauses at 16
* press `n` -> moves to timestamp 22 plays to 25 and pauses
* press `b` -> moves to timestamp timestamp 22 and plays to 25 and pauses
