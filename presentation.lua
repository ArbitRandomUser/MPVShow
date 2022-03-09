require 'mp'
local utils = require("mp.utils")
--fname = mp.get_property("filename")
--Never figured out how to set fname from the mpv
--lua api , `mp.get_property("filename")` simply never workd
--so we have to set it manually here, if you got this working
--please make a PR.

--SET SLIDESHOW INFORMATION FILE HERE
fname="con2022.mp4"
slide = 1

local function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local function read_file(path)
    print(path..".slinfo")
    local file = io.open(path..".slinfo", "r") -- r read mode and b binary mode
    if not file then
        return  nil
    end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    local retval = {}
    linesplits = mysplit(content,'\n')
    for i,ent in ipairs(linesplits) do
        table.insert(retval,mysplit(ent))
        --ll = mysplit(ent)
        --retval[tonumber(ll[1])] = ll[2]
    end
    return retval 
end

slidedat = read_file(fname);

slide_t = tonumber(slidedat[slide][1])
slide_l = slidedat[slide][2]

function getslideno(t)
    for i,v in ipairs(slidedat) do
        if tonumber(v[1]) > tonumber(t) then
            return i
        end
    end
end

function seekend()
    mp.command("seek " .. slidedat[slide][1] .. " absolute")
    mp.set_property_native("pause",false) 
end

function seekprev()
    if slide==2 then
        mp.command("seek " .. slidedat[1][1] .. " absolute")
        mp.set_property_native("pause",false) 
    elseif slide==1 then 
        mp.command("seek " .. 0 .. " absolute")
        mp.set_property_native("pause",false) 
    else
        mp.command("seek " .. slidedat[slide-2][1] .. " absolute")
        mp.set_property_native("pause",false) 
    end
end

function pause_on_slide(name,value)
    --print(value)
    --if slidedat[tonumber(value)] > "noloop" then 
    --end
    if value==nil then 
        return nil
    else
        --print(value)
    end
    --next_slide_t = tonumber(slidedat[next_slide][1])
    if value >= tonumber(slidedat[slide][1])  then
        --mp.command("seek " .. slidedat[slide][1] ..  " absolute")
        mp.set_property_native("pause",true)
        if slide_l ~= nil then
            mp.set_property_native("ab-loop-a",tonumber(slidedat[slide-1][1]))
            mp.set_property_native("ab-loop-b",tonumber(slidedat[slide][1]))
            mp.set_property_native("pause",false)
        else
            mp.set_property_native("ab-loop-a","no")
            mp.set_property_native("ab-loop-b","no")
        end
        inc_slide(1)
        print("slide is now",slide)
        --mp.command("seek " .. next_slide_t .. " absolute")
    end
end

function nextslide()
   mp.unobserve_property(pause_on_slide)
   seekend()
   inc_slide(1)
   print("slide is now",slide)
   --we really dont check if the word is "loop" just that its
   --not a whitespace after timestamp, but user needn't know ;)
   if slide_l ~=nil then
       mp.set_property_native("ab-loop-a",tonumber(slidedat[slide-1][1]))
       mp.set_property_native("ab-loop-b",tonumber(slidedat[slide][1]))
       mp.set_property_native("pause",false) 
   else
           mp.set_property_native("ab-loop-a","no")
           mp.set_property_native("ab-loop-b","no")
           mp.set_property_native("pause",false) 
   end
   mp.observe_property("time-pos","native",pause_on_slide)
end

function prevslide()
   mp.unobserve_property(pause_on_slide)
   seekprev()
   inc_slide(-1)
   print("slide is now",slide)
   if slide_l ~=nil then
        mp.set_property_native("ab-loop-a",tonumber(slidedat[slide-1][1]))
        mp.set_property_native("ab-loop-b",tonumber(slidedat[slide][1]))
        mp.set_property_native("pause",false) 
    else
        mp.set_property_native("ab-loop-a","no")
        mp.set_property_native("ab-loop-b","no")
        mp.set_property_native("pause",false) 
    end
   mp.observe_property("time-pos","native",pause_on_slide)
end


function inc_slide(n)
   slide=slide+n
   if slide<1 then
       slide=1
   end
   if slidedat[slide] == nil then
       return
   elseif slidedat[slide][1] == "end" then
      print("set end ",slide_t) 
      slidedat[slide][1] = tonumber(mp.get_property("duration"))
      slide_t = tonumber(mp.get_property("duration")) 
      slide_l = slidedat[slide][2]
   else
      slide_t = tonumber(slidedat[slide][1])
      slide_l = slidedat[slide][2]
  end
end

function unpause()
    mp.set_property_native("ab-loop-a","no")
    mp.set_property_native("ab-loop-b","no")
    mp.set_property_native("pause",false)
end

mp.observe_property("time-pos","native",pause_on_slide)
mp.add_key_binding("n",nextslide)
mp.add_key_binding("b",prevslide)
mp.remove_key_binding("m")
mp.add_forced_key_binding("m",unpause)
