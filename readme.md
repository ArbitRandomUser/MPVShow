## MPVShow
An mpv plugin to present videos as slideshows.
Broken af, but works just about enough .

## Usage
MPVShow looks for a filename `yourawesomevideo.mp4.slinfo`
when you try to open `youraweomsevideo.mp4`, This
`.slinfo` file contains the information about the 
timestamps in the video as slides , more info on how to make
the `.slinfo` file later

Ideally we want to auto-detect
`something.mp4.slinfo` when we play `something.mp4`
, but i didn't get that working.
For some reason `mp.getproperty("filename")` just
didnt work :( . So right now manually setting 
`fname` in presentation.lua is the only way. If you do get it working
lemme know how .

Make your `yourawesomevideo.mp4.slinfo`, Change `fname` to filename of
the video (`youraweomsevideo.mp4`) in  presentation.lua
and run with
```
 mpv --script=presentation.lua yourawesomevideo.mp4
```

You may also want to pass --no-osd-bar to avoid annoying
osdbar while seeking , You may also pass --no-osc-bar
to disable the onscreen controller.

Every entry in .slinfo is a timestamp that indicates
the end of the slide. Add additional keyword "loop"
if you want that slide to loop.
when player reaches any of the timestamp in the .slinfo
it pauses if its a non loop entry or loops the slide
infinitely if loop entry.

press `m` to continue to playing slide when paused
at slide . If in a looped slide `m` will remove the loop
smoothly finish the current slide and move onto the next slide
.
("default `m` is to mute/unmute ive overriden that
if you want some other key feel free to change it 
presentation.lua")

`n` will to go to next slide. 

`b` will replay the last slide  if paused at end of a non-loop slide,
or will go to the previous slide if looping the current slide

First entry should always be 0 , 
When started the video pauses at timestamp 0.

Last entry should always be "end",
end means the ending timestamp of the video,
if you want the last slide to loop you can
have `end loop` too

Any seek without n/b will mess with internal
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
save the above in a file named `yourawesomevideo.mp4.slinfo` in the same directory as `yourawesomevideo.mp4`, copy `presentation.lua` to your
current directory with `yourawesomevideo.mp4`,
change `fname` in `presentation.lua` to the apropriate filename
run
`mpv --script=presentation.lua yourawesomevideo.mp4`
* video starts and is paused
* press `m`       -> video is unpaused an plays till timestamp 5 where it pauses
* press `m` again -> video plays but loops from timestamp 5 to 10
* press `m` again -> removes the loop, continues to timestamp 10 and over to next slide and pauses at 16
* press `n` -> moves to timestamp 22 plays to 25 and pauses
* press `b` -> moves to timestamp timestamp 22 and plays to 25 and pauses
