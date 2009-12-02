{*********************************************************************
Simple Game Engine
Copyright (C) 2002 Angelo Bertolli

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

For conditions of distribution and use, see GNU license in the
file readme.txt
*********************************************************************}

const

   ROOM_DIR        =  'rooms/';

   TITLE_FILE      =  'data/title.txt';
   PLAYER_FILE     =  'data/p.dat';
   MONST_FILE      =  'data/m.dat';
   ROOM_FILE       =  'data/r.dat';
   SHOP_FILE       =  'data/s.dat';

   NUM_MONST       =  100;
   NUM_ROOMS       =  100;
   NUM_SHOPS       =  10;
   MAX_ITEMS       =  10;
   MAX_HP_LV       =  10;
   MIN_HP_LV       =  1;
   HAND_DMG        =  2;

type
     stringtype    =  string[20];

     itemrecord    =  record
                         name    :  stringtype;
                         v       :  array[0..5] of longint;
                     {
                            all    :  [0] = type (0 = other, 1 = weapon, 2 = armor), [1] = value
                            weapon :  +[2] to hit roll, [3]d[4]+[5] damage
                            armor  :  [2] = AC
                     }
                         magical :  boolean;
                      end;

     itemlist      =  array[1..MAX_ITEMS] of itemrecord;

     playerrecord  =  record
                         name    :  stringtype;
                         lv      :  word;
                         hp      :  word;
                         maxhp   :  word;
                         gold    :  longint;
                         where   :  word;
                         numitems:  word;
                         item    :  itemlist;
                         weapon  :  word;                            { reference item[] }
                         armor   :  word;                            { reference item[] }
                         xp      :  longint;
                      end;

     monsterrecord =  record
                         name     :  stringtype;
                         desc     :  string;
                         autoatt  :  boolean;
                         wander   :  boolean;
                         lv       :  word;
                         hp       :  word;
                         maxhp    :  word;
                         gold     :  word;
                         where    :  word;
                         numitems :  word;
                         item     :  itemlist;
                         weapon   :  word;
                         armor    :  word;
                         xpv      :  word;
                         dmg      :  array[1..3] of integer;
                         alive    :  boolean;
                      end;

     monsterlist   =  array[1..NUM_MONST] of monsterrecord;

     exitdirection =  (n,s,e,w);

     roomrecord    =  record
                         name     :  stringtype;
                         desc     :  stringtype;                     {filename}
                         ex       :  array[n..w] of word;            {0=no exit, #=next room}
                         gold     :  word;                           {amount of gold}
                         numitems :  word;
                         item     :  itemlist;
                      end;

     roomlist      =  array[1..NUM_ROOMS] of roomrecord;             {referenced by room exit}

     shoprecord    =  record
                         name     :  stringtype;
                         desc     :  string;
                         where    :  word;
                         numitems :  word;
                         item     :  itemlist;
                      end;

     shoplist      =  array[1..NUM_SHOPS] of shoprecord;
                  
{--------------------------------------------------------------------------}
function exist(dosname:stringtype) : boolean;

{Returns TRUE if the file exists.}

var
     pasfile        :   text;

begin
     {$I-}
     assign(pasfile,dosname);
     reset(pasfile);
     close(pasfile);
     {$I+}
     exist:=(IoResult=0);
end;

{--------------------------------------------------------------------------}
procedure loadroomlist(filename:string;var r:roomlist);

var
   roomfile      :  file of roomlist;

begin
   if (exist(filename)) then
      begin
         assign(roomfile,filename);
         reset(roomfile);
         read(roomfile,r);
         close(roomfile);
      end
   else
      writeln('Unable to open file: ',filename);
end;
{--------------------------------------------------------------------------}
procedure loadshoplist(filename:string;var s:shoplist);

var
   shopfile      :  file of shoplist;

begin
   if (exist(filename)) then
      begin
         assign(shopfile,filename);
         reset(shopfile);
         read(shopfile,s);
         close(shopfile);
      end
   else
      writeln('Unable to open file: ',filename);
end;
{--------------------------------------------------------------------------}
procedure loadmonsterlist(filename:string;var m:monsterlist);

var
   monsterfile      :  file of monsterlist;

begin
   if (exist(filename)) then
      begin
         assign(monsterfile,filename);
         reset(monsterfile);
         read(monsterfile,m);
         close(monsterfile);
      end
   else
      writeln('Unable to open file: ',filename);
end;
{--------------------------------------------------------------------------}
procedure loadplayer(filename:string;var p:playerrecord);

var
   playerfile      :  file of playerrecord;

begin
   if (exist(filename)) then
      begin
         assign(playerfile,filename);
         reset(playerfile);
         read(playerfile,p);
         close(playerfile);
      end
   else
      writeln('Unable to open file: ',filename);
end;
{--------------------------------------------------------------------------}
procedure writefile2screen(filename:string);

var
   textfile   :  text;
   line       :  string[79];

begin
   if (exist(filename)) then
      begin
         assign(textfile,filename);
         reset(textfile);
         while not(EOF(textfile)) do
            begin
               readln(textfile,line);
               writeln(line);
            end;
         close(textfile);
      end
   else
      writeln('Unable to open file: ',filename);
end;
