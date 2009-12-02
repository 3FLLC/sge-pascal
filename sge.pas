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

program SimpleGE;

uses crt, math;

{$I sge.h}

const

   VERSION         =  '0.0';

   HELP_FILE       =  'docs/help.txt';
   WIZ_HELP        =  'docs/wiz.txt';

   PLAYER_SAVE     =  'save/p.sav';
   MONST_SAVE      =  'save/m.sav';
   ROOM_SAVE       =  'save/r.sav';
   SHOP_SAVE       =  'save/s.sav';

   WANDER_CHANCE   =  20;
   WIZ_LEVEL       =  100;
   XP_MODIFIER     =  1.0;

var
   room            :  roomlist;
   monster         :  monsterlist;
   player          :  playerrecord;
   shop            :  shoplist;

{--------------------------------------------------------------------------}
procedure savegame;

var
   playerfile      :  file of playerrecord;
   roomfile        :  file of roomlist;
   shopfile        :  file of shoplist;
   monsterfile     :  file of monsterlist;

begin

   assign(playerfile,PLAYER_SAVE);
   rewrite(playerfile);
   write(playerfile,player);
   close(playerfile);

   assign(roomfile,ROOM_SAVE);
   rewrite(roomfile);
   write(roomfile,room);
   close(roomfile);

   assign(shopfile,SHOP_SAVE);
   rewrite(shopfile);
   write(shopfile,shop);
   close(shopfile);

   assign(monsterfile,MONST_SAVE);
   rewrite(monsterfile);
   write(monsterfile,monster);
   close(monsterfile);

   writeln('Saved.');
end;
{--------------------------------------------------------------------------}
function CAPITALIZE(capstring:stringtype):stringtype;

var
   loop     : word;

begin
     for loop:=1 to length(capstring) do
          capstring[loop]:=upcase(capstring[loop]);
     capitalize:=capstring;
end;
{--------------------------------------------------------------------------}
procedure displayroom(where:word);

var
   exloop     :  exitdirection;
   loop       :  word;
   numexits   :  word;

begin

   textcolor(lightgray);
   writeln;
   writeln('-');
   writeln(room[where].name);
   writefile2screen(ROOM_DIR + room[where].desc);
   write('Exits: ');
   numexits:=0;
   for exloop:=n to w do
      if (room[where].ex[exloop]<>0) then numexits:=numexits+1;
   if (numexits=0) then write('none');
   for exloop:=n to w do
      case exloop of
         n:if (room[where].ex[exloop]<>0) then write('north ');
         s:if (room[where].ex[exloop]<>0) then write('south ');
         e:if (room[where].ex[exloop]<>0) then write('east ');
         w:if (room[where].ex[exloop]<>0) then write('west ');
      end; {case}
   writeln;

   textcolor(lightmagenta);
   for loop:=1 to NUM_SHOPS do
      if (shop[loop].where=where) then
         writeln(shop[loop].desc);

   textcolor(yellow);
   for loop:=1 to NUM_MONST do
      if (monster[loop].where=where) then
         writeln(monster[loop].desc);

   textcolor(lightgreen);
   for loop:=1 to room[where].numitems do
      writeln('You see ',room[where].item[loop].name,' lying here.');

   textcolor(lightgray);

end;
{--------------------------------------------------------------------------}
procedure levelup;

var
   hpgain    : word;

begin
   with player do
      begin
         hpgain:=random(MAX_HP_LV - MIN_HP_LV + 1) + MIN_HP_LV;
         maxhp:=maxhp + hpgain;
         hp:=hp + hpgain;
         lv:=lv + 1;
      end;
end;
{--------------------------------------------------------------------------}
procedure wizardmode;

var
   pass   :  stringtype;

begin
   textcolor(lightblue);
   write('Attempting to enter Wizard Mode: ');
   readln(pass);
   if (pass='^$&#*') then
      begin
         while (player.lv<WIZ_LEVEL) do levelup;
         player.hp:=player.maxhp;
         writeln('Greetings Wizard.');
      end;
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
procedure move(var where:word;direct:exitdirection);

begin
   textcolor(lightred);
   if (room[where].ex[direct]=0) then
      writeln('That way is blocked.')
   else
      where:=room[where].ex[direct];
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
procedure inventory(numitems:word;item:itemlist);

var
   loop   :  word;

begin
   textcolor(white);
   writeln('Carrying ',numitems,'/',MAX_ITEMS,' items:');
   writeln;
   for loop:=1 to numitems do
      writeln(' ',item[loop].name);
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
function calcxp(level:word):longint;

var
   base      : real;
   stoplevel : word;
   increment : word;

begin
   base:=2.0;
   stoplevel:=7;
   increment:=15000;
   if (level in [1..stoplevel]) then
      calcxp:=trunc((intpower(base,level)*100)*XP_MODIFIER)
   else
      calcxp:=trunc((intpower(base,stoplevel)*100)*XP_MODIFIER) + ((level-stoplevel)*increment)
end;
{--------------------------------------------------------------------------}
procedure viewplayer;

var
   loop     : word;

begin

   textcolor(white);
   with player do
      begin
         writeln(name,', level ',lv);
         writeln('Hp: ',hp,'/',maxhp);
         write('Ready weapon: ');
         if (weapon=0) then
            writeln('hands')
         else
            writeln(item[weapon].name);
         write('Worn armor: ');
         if (armor=0) then
            writeln('none')
         else
            writeln(item[armor].name);
         writeln('Gold: ',gold);
         writeln('Experience: ',xp);
         writeln('Next level:');
         for loop:=(lv) to (lv+3) do
            writeln('level ',(loop+1):3,calcxp(loop):8);
      end;
   textcolor(lightgray);

end;
{--------------------------------------------------------------------------}
procedure removeitem(itemnum:word;var numitems:word;var item:itemlist);

var
   loop    : word;

begin
   numitems:=numitems - 1;
   for loop:=itemnum to numitems do
      item[loop]:=item[loop+1];
end;
{--------------------------------------------------------------------------}
procedure additem(newitem:itemrecord;var numitems:word;var item:itemlist);

begin
   numitems:=numitems + 1;
   item[numitems]:=newitem;
end;
{--------------------------------------------------------------------------}
procedure moveitem(itemnum:word;var from_numitems:word;var from_item:itemlist;
                   var to_numitems:word;var to_item:itemlist);

begin
   additem(from_item[itemnum],to_numitems,to_item);
   removeitem(itemnum,from_numitems,from_item);
end;
{--------------------------------------------------------------------------}
procedure playertake(where:word);

var
   loop   : word;
   str    : string;
   int    : word;
   err    : word;

begin
   textcolor(lightgreen);
   with room[where] do
      begin
         if (numitems=0)or(player.numitems=10) then
            writeln('You can''t.')
         else
            begin
               writeln(0:2,') none');
               for loop:=1 to numitems do
                  writeln(loop:2,') ',item[loop].name);
               writeln;
               write('Take which item: ');
               readln(str);
               writeln;
               val(str,int,err);
               if (int in [1..numitems]) then
                  begin
                     writeln('You take ',item[int].name);
                     moveitem(int,numitems,item,player.numitems,player.item);
                  end;
            end;
      end;
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
procedure playerready;

var
   loop     : word;
   int      : word;
   str      : stringtype;
   err      : word;

begin
   textcolor(white);
   with player do
      begin
         writeln('Carrying ',numitems,'/',MAX_ITEMS,' items:');
         writeln;
         for loop:=1 to numitems do
            writeln(loop:3,') ',item[loop].name);

         writeln;
         write('Equip weapon (0 for none): ');
         readln(str);
         val(str,int,err);
         if (int>numitems) then int:=0;
         if (item[int].v[0]<>1) then int:=0;
         weapon:=int;

         writeln;
         write('Equip armor (0 for none): ');
         readln(str);
         val(str,int,err);
         if (int>numitems) then int:=0;
         if (item[int].v[0]<>2) then int:=0;
         armor:=int;

      end;
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
procedure playerdrop;

var
   loop     : word;
   int      : word;
   str      : stringtype;
   err      : word;

begin
   textcolor(lightgreen);
   with player do
      begin
         writeln('Carrying ',numitems,'/',MAX_ITEMS,' items:');
         writeln;
         for loop:=1 to numitems do
            writeln(loop:3,') ',item[loop].name);

         writeln;
         write('Drop which item: ');
         readln(str);
         writeln;
         val(str,int,err);
         if (int in [1..numitems]) then
            if (room[where].numitems < MAX_ITEMS) then
               begin
                  if (armor=int) then armor:=0;
                  if (weapon=int) then weapon:=0;
                  writeln('You dropped ',item[int].name);
                  moveitem(int,numitems,item,room[where].numitems,room[where].item);
               end
            else
               begin
                  writeln('There is no room to drop.');
                  writeln('This item will be gone forever.');
                  write('Are you sure? (y/n) ');
                  readln(str);
                  if (str[1] in ['y','Y']) then
                     begin
                        if (armor=int) then armor:=0;
                        if (weapon=int) then weapon:=0;
                        writeln('You dropped ',item[int].name);
                        removeitem(int,numitems,item);
                     end;
               end;
      end;
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
procedure rest;

var
   price      : word;
   str        : stringtype;

begin
   price:=1;
   writeln('A night''s rest will cost you ',price,' gp.');
   write('Stay the night? (y/n) ');
   readln(str);
   writeln;
   if (str[1] in ['y','Y']) then
      if (player.gold >= price) then
         begin
            writeln('You rest and gain health.');
            player.gold:=player.gold - price;
            player.hp:=player.hp + random(4)+1;
            if (player.hp>player.maxhp) then player.hp:=player.maxhp;
         end
      else
         writeln('You don''t have enough money.');
end;
{--------------------------------------------------------------------------}
procedure shopat(shopnum:word);

var
   done         : boolean;

begin
   done:=false;
   with shop[shopnum] do
      begin







      end;
end;
{--------------------------------------------------------------------------}
procedure goshopping;

var
   localshops     : set of byte;
   loop           : word;
   restarea       : boolean;
   numshops       : byte;
   str            : stringtype;
   err            : word;
   int            : word;

begin
   textcolor(lightmagenta);
   localshops:=[];
   restarea:=false;
   numshops:=0;
   writeln('0':3,') none');
   for loop:=1 to NUM_SHOPS do
      if (shop[loop].where=player.where) then
         begin
            writeln(loop:3,') ',shop[loop].name);
            localshops:=localshops + [loop];
            numshops:=numshops+1;
         end;
   restarea:=numshops>1;
   if (restarea) then
      writeln('R':3,') Rest at an Inn');
   writeln;
   write('Shop where: ');
   readln(str);
   writeln;
   if (restarea)and(str[1] in ['r','R']) then
      rest
   else
      begin
         val(str,int,err);
         if (int in localshops) then
            shopat(int);
      end;
   textcolor(lightgray);
end;
{--------------------------------------------------------------------------}
procedure game;

var
   loop            :  word;
   done            :  boolean;
   cmd             :  char;
   ch              :  char;
   valid           :  boolean;
   str             :  stringtype;

begin

   loadplayer(PLAYER_FILE,player);
   loadroomlist(ROOM_FILE,room);
   loadshoplist(SHOP_FILE,shop);
   loadmonsterlist(MONST_FILE,monster);

   writefile2screen(TITLE_FILE);
   writeln;
   writeln('                                                 Press <enter> to continue...');
   readln;

   writeln;
   writeln;
   write('Enter your character''s name: ');
   readln(str);
   if (str<>'') then
      player.name:=str;
   writeln;
   writeln;

   displayroom(player.where);
   done:=false;
   repeat
      writeln;
      with player do
         write(name,' (',hp,'/',maxhp,' hp)');
      cmd:=readkey;
      writeln;
      writeln;
      valid:=true;
      case cmd of
         'S'     :savegame;
         'L'     :begin
                     if ((exist(PLAYER_SAVE))and(exist(MONST_SAVE))
                         and(exist(ROOM_SAVE))and(exist(SHOP_SAVE))) then
                        begin
                           writeln('Current character will be lost.');
                           write('Load anyway? (y/n)');
                           ch:=readkey;
                           writeln;
                           writeln;
                           if (ch in ['y','Y']) then
                                 begin
                                    loadplayer(PLAYER_SAVE,player);
                                    loadmonsterlist(MONST_SAVE,monster);
                                    loadroomlist(ROOM_SAVE,room);
                                    loadshoplist(SHOP_SAVE,shop);
                                    writeln('Character loaded: ',player.name);
                                 end;
                        end
                     else
                        writeln('No game saved.');
                     displayroom(player.where);
                  end;
         'Q'     :begin
                     write('Are you sure you want to quit? (y/n)');
                     ch:=readkey;
                     done:=ch in ['y','Y'];
                  end;
         '?'     :begin
                     textcolor(white);
                     writefile2screen(HELP_FILE);
                     if (player.lv>=WIZ_LEVEL) then
                        begin
                           writeln;
                           textcolor(lightblue);
                           writefile2screen(WIZ_HELP);
                        end;
                     textcolor(lightgray);
                  end;
         'l'     :displayroom(player.where);
         '8'     :begin
                     move(player.where,n);
                     displayroom(player.where);
                  end;
         '2'     :begin
                     move(player.where,s);
                     displayroom(player.where);
                  end;
         '6'     :begin
                     move(player.where,e);
                     displayroom(player.where);
                  end;
         '4'     :begin
                     move(player.where,w);
                     displayroom(player.where);
                  end;
         'i'     :inventory(player.numitems,player.item);
         'v'     :viewplayer;
         't'     :playertake(player.where);
         'r'     :playerready;
         'd'     :playerdrop;
         's'     :goshopping;
         'a'     :{attack};
         'p'     :{pillage};

         'W'     :wizardmode;
         'P'     :if (player.lv<WIZ_LEVEL) then
                     valid:=false
                  else
                     begin
                        {
                        peek at an room, monster, or shop in current room
                        }
                     end;
         'G'     :if (player.lv<WIZ_LEVEL) then
                     valid:=false
                  else
                     begin
                        {
                        go to a room by room, monster, or shop #
                        }
                     end;
         'K'     :if (player.lv<WIZ_LEVEL) then
                     valid:=false
                  else
                     begin
                        {
                        kill a monster in the current room
                        }
                     end;
      else
         valid:=false;
      end; {case}
      if not(valid) then
         writeln('Invalid command, type ? for help.');

      {monsters turn}

   until done;

end;
{--------------------------------------------------------------------------}


BEGIN

   randomize;

   writeln('Simple Game Engine ',VERSION);
   writeln('Copyright (C) 2002 Angelo Bertolli');

   game;

END.
