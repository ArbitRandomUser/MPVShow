## MPVShow
An mpv plugin to present videos as slideshows

##Usage
Make a file with .slinfo extension,(or any name
and set `fname` in presentation.lua to it)

Ideally we want soemthing.mp4 to auto-detect
something.mp4.slinfo , but i didnt get that working
for some reason `mp.getproperty("filename")` just
didnt work :( . So right now manually setting 
`fname` in presentation.lua . If you do get it working
lemme know how .

Change "fname" to apropriate .slinfo file
in  presentation.lua and run with

`$ mpv --script=presentation.lua yourawesomevideo.mp4`
you may also want to pass --no-osd-bar to avoid

Every entry in .slinfo is a timestamp that indicates
the end of the slide. Add additional keyword "loop"
if you want that slide to loop.
when player reaches any of the timestamp in the .slinfo
it pauses if its a non loop entry or loops the slide
infinitely if loop entry.

press "n" to go to next slide and "b" to go to previous

first entry should always be 0 , 
slide 1 is always from 0 -> 0 , so when started
the video "plays first frame" and pauses at 0