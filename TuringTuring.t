% TuringTuring Simulation Program [Copyright © 2015 Philip Wipf]


    % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details.
    % 
    % You should have received a copy of the GNU General Public License
    % along with this program.  If not, see <http://www.gnu.org/licenses/>.
     
% 
% This little program first inputs from the user two test files.
% The first is a description of a turing machine, the second is a
% tape to run the machine on.
%
% The text file for the machine description consists of several sections,
% divided by [section title] placeholders. The easiest way to learn how to
% create a machine description file is by looking at the one that is included
% with this program. It is
% a simple machine that inverts each bit of a binary stream, ending at the
% right end of the tape. Here are the sections of the file.
%
% [title]
% a_text_title (no spaces)
% [number of states]
% integer
% [accept state]
% integer
% [reject state]
% integer
% [number of transitions]
% integer
% [transition 1]
% integer    (beginning state)
% character  (input symbol)
% integer    (new state)
% character  (write symbol)
% R or L     (move head left or right)
% [transition 2]
% integer    (beginning state)
% ...
% etc.
%[end]
%
% The tape file is also a text file, this one consists of a single line of
% symbols that match the characters of the input characters of the transitions.
% 
% 
% Note: The tape is filled with blanks in theory, but blanks are difficult
%   to see so this program uses a * symbol for a blank, that is, it initializes
%   the tape with all * so the TM should check for a * rather than a blank to
%   see if it has gone past the end of the input.

type Transition:
    record
        fromState: int
        readSymbol: char
        toState: int
        writeSymbol: char
        leftOrRight: char
    end record
    
type TM:
    record
        title: string
        numStates: int
        numTrans: int
        startState: int
        acceptState: int
        rejectState: int
        trans: array 1..100 of Transition
        trany: Transition
    end record


var tm: TM
var tape: array 1..1000 of char
var tapeLength: int

var c: int
var h: int
var hmax: int:=0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process leaf()
% rotates a maple leaf at cx,cy size s color c
process leaf (cx,cy,s,c:int)
    var x1,y1,x2,y2,sx,cc,t:int
    randint(t,1,360)
    y1:=cy-s y2:=cy+s
    sx:=floor(s*sind(t))
    x1:=cx-sx x2:=cx+sx
    loop
        if(t mod 360) > 180 then cc:= gray else cc:=c end if
        delay(40)
        drawfillmapleleaf(x1,y1,x2,y2,white)
        t:=t+10
        sx:=floor(s*sind(t))
        x1:=cx-sx x2:=cx+sx
        drawfillmapleleaf(x1,y1,x2,y2,cc)
    end loop
end leaf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% readTM
% reads in the turing machine from a file
procedure readTM
    var tmfile: int :=0
    var tmfilename: string
    loop
        locate(whatrow(),10)
        put "Enter name of TM file to load: "..
        get tmfilename
        open : tmfile, tmfilename, get
        if tmfile > 0 then
            locate(whatrow(),10)
            put "Reading in Turing Machine from file ",tmfilename,"..."
            exit
        else
            locate(whatrow(),10)
            put "Can't open ",tmfilename
        end if
    end loop

    var s: string
    get :tmfile, s:*, tm.title
    get :tmfile, s:*,tm.numStates, s:*, tm.startState, s:*
    get :tmfile, tm.acceptState, s:*, tm.rejectState
    get :tmfile, s:*, tm.numTrans
    for i: 1..tm.numTrans
        get :tmfile, s:*, tm.trans(i).fromState
        get :tmfile, tm.trans(i).readSymbol, s:*
        get :tmfile, tm.trans(i).toState, tm.trans(i).writeSymbol, s:*
        get :tmfile, tm.trans(i).leftOrRight, s:*
    end for
    close :tmfile
end readTM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% readTape
% reads in the tape from a file
procedure readTape
    for i: 1..1000  % first must initialize tape to *******....
        tape(i):= '*'
    end for

    var tfile: int :=0
    var tfilename: string:="tape.txt"
    loop
        locate(whatrow(),10)
        put "Enter name of input tape file to run \"",tm.title,"\" on: "..
        get tfilename
        open : tfile, "tape.txt", get
        if tfile > 0 then
            locate(whatrow(),10)
            put "Reading in input tape from file ",tfilename,"..."
            exit
        else
            locate(whatrow(),10)
            put "Can't open ",tfilename
        end if
    end loop
    
    tapeLength:=0
    loop
        var c:char
        get :tfile, c
        exit when c ='\r' or c = chr(0)
        tapeLength:= tapeLength+1
        tape(tapeLength):= c
    end loop
end readTape

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% showTape procedure
% just outputs the current tape, with the head position
% shown by a '>'
proc showTape(headPos:int)
  locate(whatrow(),10)
  put "Tape:  ["..
  for i: 1..hmax
    if headPos = i then
        put ">"..
    end if
    put tape(i)..
  end for
  put"..."
end showTape

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% doTransition function
% makes the changes to the tape and head position.
% returns new state
function doTransition(i: int) :int
    %put "Transition ",i
    tape(h):= tm.trans(i).writeSymbol
    if tm.trans(i).leftOrRight = 'L' and h > 1 then
        h:= h-1
    else
        if tm.trans(i).leftOrRight = 'R' and h <= 1000 then
            h:= h+1
        end if
    end if
    result tm.trans(i).toState
end doTransition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runMachine procedure
% simulates the machine
procedure runMachine
    locate(whatrow(),10)
    put "Running Turing Machine \"",tm.title,"\""
    c:= tm.startState
    h:= 1
    hmax:=tapeLength+3
    var w:char
    loop
        showTape(h)
        for i: 1..tm.numTrans
            if tm.trans(i).fromState = c and
               tm.trans(i).readSymbol = tape(h) then
                c:= doTransition(i)
                exit
            end if
        end for
        
        
        exit when c=tm.acceptState or c=tm.rejectState
    end loop
    if c=tm.acceptState then
        locate(whatrow(),10)
        put "Accept!"
    else
        locate(whatrow(),10)
        put "Reject!"
    end if
end runMachine

%%%%%%%%%%%%%%%%%%%%%%%%%%%% start program %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setscreen("graphics:1000;500,nobuttonbar")
fork leaf(30,30,30,39)
fork leaf(30,maxy-30,30,39)
fork leaf(maxx-30,maxy-30,30,39)
fork leaf(maxx-30,30,30,39)

locate(whatrow(),10)
put "TuringTuring Simulation Program [Copyright © 2015 Philip Wipf]\n"
readTM
readTape
runMachine


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample TM description file
% 
% [title]
% Invert
% [number of states]
% 2
% [start state]
% 1
% [accept state]
% 2
% [reject state]
% 0
% [number of transistions]
% 3
% [transition 1]
% 1
% 0
% 1
% 1
% R
% [transition 2]
% 1
% 1
% 1
% 0
% R
% [transition 3]
% 1
% *
% 2
% *
% L
% [end]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample tape file
% 
% 011000101
