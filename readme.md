## MPVShow
An mpv plugin to present videos as slideshows.

MPVShow looks for a filename `yourawesomevideo.mp4.slinfo`
when you play  `youraweomsevideo.mp4`, This
`.slinfo` file contains the information about the 
timestamps in the video as slides , more info on how to make
the `.slinfo` file later

Ideally we want to auto-detect the filename when we
open `yourawesomevideo.mp4`, 
but i could't get that working.
For some reason `mp.getproperty("filename")` just
didnt work :( .
So right now manually setting `fname` in MPVShow.lua is the only way.
The workflow as of now is to make a copy `MPVShow.lua` for every video
with the variable `fname` changed to the video's filename.

If you do get it working
lemme know how .

## Usage
The `.slinfo` file is a list of timestamps to mark 
end of a slide. every line should be of the form
```
num [loop]
```
Where `num` is a timestamp, followed by an optional `loop`.

The video while playing is paused when it reaches `num` timestamp
indicating end of that slide.
If it reaches a `num loop` the player loops that slide infinitely.
Check Keybindings to see how to navigate through slides.

First entry should always be 0 , 
Last entry should always be "end",
end means the ending timestamp of the video,
if you want the last slide to loop you can
have `end loop` too.
Check Example at the end of this file

Make your `yourawesomevideo.mp4.slinfo`, Change `fname` to filename of
the video (`youraweomsevideo.mp4`) in  MPVShow.lua
and run with
```
 mpv --script=MPVShow.lua yourawesomevideo.mp4
```

You may also want to pass --no-osd-bar to avoid annoying
osdbar while seeking , You may also pass --no-osc-bar
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


Any seek without `n`/`b` will mess with internal
state of the plugin , try to use only n and b

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
Save the above in a file named `yourawesomevideo.mp4.slinfo` in the same directory as `yourawesomevideo.mp4`, copy `MPVShow.lua` to your
current directory with `yourawesomevideo.mp4`,
change `fname` in `MPVShow.lua` to the apropriate filename
run
`mpv --script=MPVShow.lua yourawesomevideo.mp4`
* video starts and is paused
* press `m`       -> video is unpaused an plays till timestamp 5 where it pauses
* press `m` again -> video plays but loops from timestamp 5 to 10
* press `m` again -> removes the loop, continues to timestamp 10 and over to next slide and pauses at 16
* press `n` -> moves to timestamp 22 plays to 25 and pauses
* press `b` -> moves to timestamp timestamp 22 and plays to 25 and pauses
