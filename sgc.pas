{*********************************************************************
Simple Game Creator
Copyright (C) 2002 Angelo Bertolli

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

For conditions of distribution and use, see GNU license in the
file readme.txt
*********************************************************************}

program SimpleGC;

uses crt;

{$I sge.h}

const

   VERSION         =  '1.0';

{--------------------------------------------------------------------------}
procedure saveplayer(filename:string;var p:playerrecord);

var
   playerfile      : file of playerrecord;
   ans             : char;

begin
   ans:='Y';
   if (exist(filename)) then
      begin
         writeln('WARNING:  File already exists: ',filename);
         write('Overwrite? (y/n) ');
         readln(ans);
      end;
   if (ans in ['y','Y']) then
      begin
         assign(playerfile,filename);
         rewrite(playerfile);
         write(playerfile,p);
         close(playerfile);
         writeln('Saved.');
      end;
end;
{--------------------------------------------------------------------------}
procedure saveroomlist(filename:string;var r:roomlist);

var
   roomfile      :  file of roomlist;
   ans             : char;

begin
   ans:='Y';
   if (exist(filename)) then
      begin
         writeln('WARNING:  File already exists: ',filename);
         write('Overwrite? (y/n) ');
         readln(ans);
      end;
   if (ans in ['y','Y']) then
      begin
         assign(roomfile,filename);
         rewrite(roomfile);
         write(roomfile,r);
         close(roomfile);
         writeln('Saved.');
      end;
end;
{--------------------------------------------------------------------------}
procedure saveshoplist(filename:string;var s:shoplist);

var
   shopfile      :  file of shoplist;
   ans             : char;

begin
   ans:='Y';
   if (exist(filename)) then
      begin
         writeln('WARNING:  File already exists: ',filename);
         write('Overwrite? (y/n) ');
         readln(ans);
      end;
   if (ans in ['y','Y']) then
      begin
         assign(shopfile,filename);
         rewrite(shopfile);
         write(shopfile,s);
         close(shopfile);
         writeln('Saved.');
      end;
end;
{--------------------------------------------------------------------------}
procedure savemonsterlist(filename:string;var m:monsterlist);

var
   monsterfile      :  file of monsterlist;
   ans             : char;

begin
   ans:='Y';
   if (exist(filename)) then
      begin
         writeln('WARNING:  File already exists: ',filename);
         write('Overwrite? (y/n) ');
         readln(ans);
      end;
   if (ans in ['y','Y']) then
      begin
         assign(monsterfile,filename);
         rewrite(monsterfile);
         write(monsterfile,m);
         close(monsterfile);
         writeln('Saved.');
      end;
end;
{--------------------------------------------------------------------------}
procedure moditems(var numitems:word;var item:itemlist);

var
   done   :  boolean;
   loop   :  word;
   str    :  string;
   int    :  word;
   err    :  word;
   newitem:  itemrecord;
   ans    : char;

begin
   done:=false;
   repeat
      writeln;
      writeln('-');
      writeln('Max number of items: ',MAX_ITEMS);
      for loop:=1 to numitems do
         with item[loop] do
            begin
               write(loop:3,')',name:20,',');
               case v[0] of
                  0 :begin
                        write('item,':8);
                        write(v[1]:6,' gp');
                     end;
                  1 :begin
                        write('weapon,':8);
                        write(v[1]:6,' gp,');
                        write(v[2]:3,' + to hit, ');
                        write(v[3]:3,'d',v[4]);
                        if (v[5]>=0) then
                           write('+');
                        write(v[5],' dmg');
                     end;
                  2 :begin
                        write('armor,':8);
                        write(v[1]:6,' gp,');
                        write(v[2]:3,' + AC');
                     end;
               end; {case}
               if (magical) then
                  write('*':3);
               writeln;
            end;
      writeln;
      writeln('(A)dd an item, (R)emove an item, (D)uplicate/add an item,');
      writeln('(C)lear all items, (M)odify an item, (Q)uit');
      write('Selection: ');
      readln(ans);
      writeln;
      case ans of
         'Q','q' :done:=true;
         'A','a' :begin
                     if (numitems=MAX_ITEMS) then
                        writeln('Sorry, you''ve reached your max.')
                     else
                        begin
                           writeln('Creating a new item...');

                           write('Item name: ');
                           readln(str);
                           if not(str='') then
                              newitem.name:=str
                           else
                              newitem.name:='a mysterious item';

                           writeln;
                           writeln('Types: 0 = item, 1 = weapon, 2 = armor');
                           write('Item type: ');
                           readln(str);
                           if not(str='') then
                              val(str,int,err);
                           if (int<0)or(int>2) then int:=0;
                           newitem.v[0]:=int;

                           if (newitem.v[0]=1) then
                              begin
                                 writeln;
                                 write('Weapon to-hit bonus: ');
                                 readln(str);
                                 if not(str='') then
                                    val(str,int,err);
                                 newitem.v[2]:=int;
                                 writeln('Weapon damage XdY+Z');
                                 write('X: ');
                                 readln(str);
                                 if not(str='') then
                                    val(str,int,err);
                                 if (int<0) then int:=0;
                                 newitem.v[3]:=int;
                                 write('Y: ');
                                 readln(str);
                                 if not(str='') then
                                    val(str,int,err);
                                 if (int<0) then int:=0;
                                 newitem.v[4]:=int;
                                 write('Z: ');
                                 readln(str);
                                 if not(str='') then
                                    val(str,int,err);
                                 newitem.v[5]:=int;
                              end;

                           if (newitem.v[0]=2) then
                              begin
                                 writeln;
                                 write('Armor AC: ');
                                 readln(str);
                                 if not(str='') then
                                    val(str,int,err);
                                 newitem.v[2]:=int;
                              end;

                           writeln;
                           write('Item value: ');
                           readln(str);
                           if not(str='') then
                              val(str,int,err);
                           if (int<0) then int:=0;
                           newitem.v[1]:=int;

                           writeln;
                           write('Item magical (y/n): ');
                           readln(ans);
                           newitem.magical:=ans in ['y','Y'];

                           numitems:=numitems+1;
                           item[numitems]:=newitem;
                        end;
                  end;
         'R','r' :begin
                     if (numitems=0) then
                        writeln('There aren''t any items to remove.')
                     else
                        begin
                           write('Remove which item: ');
                           readln(str);
                           if not(str='') then
                              val(str,int,err);
                           if (int>=1)and(int<=numitems) then
                              begin
                                 numitems:=numitems - 1;
                                 for loop:=int to numitems do
                                    item[loop]:=item[loop+1];
                              end;
                        end;
                  end;
         'D','d' :begin
                     if (numitems=MAX_ITEMS)or(numitems=0) then
                        writeln('Either you''ve reached your max, or there are no items to duplicate!')
                     else
                        begin
                           write('Duplicate which item: ');
                           readln(str);
                           if not(str='') then
                              val(str,int,err);
                           if (int>=1)and(int<=numitems) then
                              begin
                                 numitems:=numitems + 1;
                                 item[numitems]:=item[int];
                              end;
                        end;
                  end;
         'C','c' :begin
                     numitems:=0;
                  end;
         'M','m' :begin
                     if (numitems=0) then
                        writeln('There aren''t any items to modify.')
                     else
                        begin
                           write('Modify which item: ');
                           readln(str);
                           if not(str='') then
                              val(str,int,err);
                           if (int>=1)and(int<=numitems) then
                              with item[int] do
                                 begin
                                    write('Changing item stats (enter nothing to keep)...');
                                    writeln;

                                    writeln('Item name: ',name);
                                    write('Change to: ');
                                    readln(str);
                                    if not(str='') then
                                       name:=str;

                                    writeln;
                                    writeln('Types: 0 = item, 1 = weapon, 2 = armor');
                                    writeln('Item type: ',v[0]);
                                    write('Change to: ');
                                    readln(str);
                                    if not(str='') then
                                       val(str,v[0],err);
                                    if (v[0]<0)or(v[0]>2) then int:=0;

                                    if (v[0]=1) then
                                       begin
                                          writeln;
                                          writeln('Weapon to-hit bonus: ',v[2]);
                                          write('Weapon damage: ',v[3],'d',v[4]);
                                          if (v[5]>=0) then write('+');
                                          writeln(v[5]);
                                          write('Change? (y/n) ');
                                          readln(ans);

                                          if (ans in ['y','Y']) then
                                             begin
                                                writeln;
                                                write('Weapon to-hit bonus: ');
                                                readln(str);
                                                if not(str='') then
                                                   val(str,int,err);
                                                v[2]:=int;
                                                writeln('Weapon damage XdY+Z');
                                                write('X: ');
                                                readln(str);
                                                if not(str='') then
                                                   val(str,int,err);
                                                if (int<0) then int:=0;
                                                v[3]:=int;
                                                write('Y: ');
                                                readln(str);
                                                if not(str='') then
                                                   val(str,int,err);
                                                if (int<0) then int:=0;
                                                v[4]:=int;
                                                write('Z: ');
                                                readln(str);
                                                if not(str='') then
                                                   val(str,int,err);
                                                v[5]:=int;
                                             end;
                                       end;

                                    if (v[0]=2) then
                                       begin
                                          writeln;
                                          writeln('Armor AC: ',v[2]);
                                          write('Change to: ');
                                          readln(str);
                                          if not(str='') then
                                             val(str,v[2],err);
                                       end;

                                    writeln;
                                    writeln('Item value: ',v[1]);
                                    write('Change to: ');
                                    readln(str);
                                    if not(str='') then
                                       val(str,v[1],err);
                                    if (v[1]<0) then v[1]:=0;

                                    writeln;
                                    write('Item magical (y/n): ');
                                    readln(ans);
                                    if (ans in ['y','Y']) then
                                       magical:=true;
                                    if (ans in ['n','N']) then
                                       magical:=false;
                                 end;
                        end;
                  end;
      end; {case}
   until (done);


end;
{--------------------------------------------------------------------------}
procedure modplayer(var pl:playerrecord);

var
   done   :  boolean;
   loop   :  word;
   str    :  string;
   int    :  word;
   err    :  word;
   ans             : char;

begin
   done:=false;
   repeat
      clrscr;
      writeln('The following are the starting defaults for new players...');
      writeln;
      with pl do
         begin
            writeln('(1)','Name:  ':16,name);
            writeln('(2)','Level:  ':16,lv);
            writeln('(3)','Hp:  ':16,hp);
            writeln('(4)','Max hp:  ':16,maxhp);
            writeln('(5)','Gold:  ':16,gold);
            writeln('(6)','Room #:  ':16,where);
            writeln('(7)','Items:  ':16,numitems);
            writeln('--');
            for loop:=1 to numitems do
               with item[loop] do
                  begin
                     write(loop:2,'.',name:20,',');
                     case v[0] of
                        0 :begin
                              write('item,':8);
                              write(v[1]:6,' gp');
                           end;
                        1 :begin
                              write('weapon,':8);
                              write(v[1]:6,' gp,');
                              write(v[2]:3,' + to hit, ');
                              write(v[3]:3,'d',v[4]);
                              if (v[5]>=0) then
                                 write('+');
                              write(v[5],' dmg');
                           end;
                        2 :begin
                              write('armor,':8);
                              write(v[1]:6,' gp,');
                              write(v[2]:3,' + AC');
                           end;
                     end; {case}
                     if (magical) then
                        write('*':3);
                     writeln;
                  end;
            writeln('--');
            writeln('(8)','Experience:  ':16,xp);
         end;
      writeln;
      writeln('Equipped weapon: ',pl.weapon);
      writeln('Equipped armor:  ',pl.armor);
      writeln;
      writeln('Modify: (1) to (8), (L)oad, (S)ave, (E)quip items, (Q)uit');
      write('Selection: ');
      readln(ans);
      writeln;
      case ans of
         'S','s' :saveplayer(PLAYER_FILE,pl);
         'L','l' :loadplayer(PLAYER_FILE,pl);
         'Q','q' :done:=true;
         '1'     :begin
                     writeln('Name: ',pl.name);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        pl.name:=str;
                  end;
         '2'     :begin
                     writeln('Level: ',pl.lv);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,pl.lv,err);
                     if (pl.lv<1) then pl.lv:=1;
                  end;
         '3'     :begin
                     writeln('Hp: ',pl.hp);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,pl.hp,err);
                     if (pl.hp<1) then pl.hp:=1;
                  end;
         '4'     :begin
                     writeln('Max hp: ',pl.maxhp);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,pl.maxhp,err);
                     if (pl.maxhp<1) then pl.maxhp:=1;
                  end;
         '5'     :begin
                     writeln('Gold: ',pl.gold);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,pl.gold,err);
                     if (pl.gold<0) then pl.gold:=0;
                  end;
         '6'     :begin
                     writeln('Room #: ',pl.where);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,pl.where,err);
                     if (pl.where<1) then pl.where:=1;
                     if (pl.where>NUM_ROOMS) then pl.where:=NUM_ROOMS;
                  end;
         '7'     :begin
                     moditems(pl.numitems,pl.item);
                     pl.weapon:=0;
                     pl.armor:=0;
                  end;
         '8'     :begin
                     writeln('Experience: ',pl.xp);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,pl.xp,err);
                     if (pl.xp<0) then pl.xp:=0;
                  end;
         'E','e' :begin
                     writeln;
                     write('Equip weapon (0 for none): ');
                     readln(str);
                     val(str,int,err);
                     if (int>pl.numitems) then int:=0;
                     if (pl.item[int].v[0]<>1) then int:=0;
                     pl.weapon:=int;

                     writeln;
                     write('Equip armor (0 for none): ');
                     readln(str);
                     val(str,int,err);
                     if (int>pl.numitems) then int:=0;
                     if (pl.item[int].v[0]<>2) then int:=0;
                     pl.armor:=int;
                  end;
      end; {case}
   until (done);

end;
{--------------------------------------------------------------------------}
procedure displaymn(monster:monsterrecord);

var
   loop      : word;

begin
      with monster do
         begin
            writeln('(1)','Name:  ':16,name);
            writeln('(2)','Level:  ':16,lv);
            writeln('(3)','Hp:  ':16,hp);
            writeln('(4)','Max hp:  ':16,maxhp);
            writeln('(5)','Gold:  ':16,gold);
            writeln('(6)','Room #:  ':16,where);
            writeln('(7)','Items:  ':16,numitems);
            writeln('--');
            for loop:=1 to numitems do
               with item[loop] do
                  begin
                     write(loop:2,'.',name:20,',');
                     case v[0] of
                        0 :begin
                              write('item,':8);
                              write(v[1]:6,' gp');
                           end;
                        1 :begin
                              write('weapon,':8);
                              write(v[1]:6,' gp,');
                              write(v[2]:3,' + to hit, ');
                              write(v[3]:3,'d',v[4]);
                              if (v[5]>=0) then
                                 write('+');
                              write(v[5],' dmg');
                           end;
                        2 :begin
                              write('armor,':8);
                              write(v[1]:6,' gp,');
                              write(v[2]:3,' + AC');
                           end;
                     end; {case}
                     if (magical) then
                        write('*':3);
                     writeln;
                  end;
            writeln('--');
            writeln('(8)','Xp value:  ':16,xpv);
            writeln('(9)','Description:  ':16,desc);
            write('(A)','Auto attack:  ':16);
            if (autoatt) then writeln('T') else writeln('F');
            write('(B)','Wander:  ':16);
            if (wander) then writeln('T') else writeln('F');
            write('(C)','Damage:  ':16,dmg[1],'d',dmg[2]);
            if (dmg[3]>=0) then write('+');
            writeln(dmg[3]);
         end;
end;
{--------------------------------------------------------------------------}
procedure modmon(var monster:monsterrecord);

var
   done   :  boolean;
   loop   :  word;
   str    :  string;
   int    :  word;
   err    :  word;
   ans             : char;

begin
   done:=false;
   monster.alive:=true;
   repeat
      clrscr;
      writeln;
      displaymn(monster);
      writeln;
      writeln('Equipped weapon: ',monster.weapon);
      writeln('Equipped armor:  ',monster.armor);
      writeln;
      writeln('Modify: (1) to (C), (E)quip items, (Q)uit');
      write('Selection: ');
      readln(ans);
      writeln;
      case ans of
         'Q','q' :done:=true;
         '1'     :begin
                     writeln('Name: ',monster.name);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        monster.name:=str;
                  end;
         '2'     :begin
                     writeln('Level: ',monster.lv);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,monster.lv,err);
                     if (monster.lv<1) then monster.lv:=1;
                  end;
         '3'     :begin
                     writeln('Hp: ',monster.hp);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,monster.hp,err);
                     if (monster.hp<1) then monster.hp:=1;
                  end;
         '4'     :begin
                     writeln('Max hp: ',monster.maxhp);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,monster.maxhp,err);
                     if (monster.maxhp<1) then monster.maxhp:=1;
                  end;
         '5'     :begin
                     writeln('Gold: ',monster.gold);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,monster.gold,err);
                     if (monster.gold<0) then monster.gold:=0
                  end;
         '6'     :begin
                     writeln('Room #: ',monster.where);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,monster.where,err);
                     if (monster.where<1) then monster.where:=1;
                     if (monster.where>NUM_ROOMS) then monster.where:=NUM_ROOMS;
                  end;
         '7'     :begin
                     moditems(monster.numitems,monster.item);
                     monster.weapon:=0;
                     monster.armor:=0;
                  end;
         '8'     :begin
                     writeln('Experience: ',monster.xpv);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,monster.xpv,err);
                     if (monster.xpv<0) then monster.xpv:=0;
                  end;
         '9'     :begin
                     writeln('Name: ',monster.desc);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        monster.desc:=str;
                  end;
         'A','a' :begin
                     write('Monster automatically attacks? (y/n): ');
                     readln(ans);
                     monster.autoatt:=ans in ['y','Y'];
                  end;
         'B','b' :begin
                     write('Monster wanders between rooms? (y/n): ');
                     readln(ans);
                     monster.wander:=ans in ['y','Y'];
                  end;

         'C','c' :begin
                     writeln('Natural damage XdY+Z');
                     write('X: ');
                     readln(str);
                     if not(str='') then
                        val(str,int,err);
                     if (int<0) then int:=0;
                     monster.dmg[1]:=int;
                     write('Y: ');
                     readln(str);
                     if not(str='') then
                        val(str,int,err);
                     if (int<0) then int:=0;
                     monster.dmg[2]:=int;
                     write('Z: ');
                     readln(str);
                     if not(str='') then
                        val(str,int,err);
                     monster.dmg[3]:=int;
                  end;
         'E','e' :begin
                     writeln;
                     write('Equip weapon (0 for none): ');
                     readln(str);
                     val(str,int,err);
                     if (int>monster.numitems) then int:=0;
                     if (monster.item[int].v[0]<>1) then int:=0;
                     monster.weapon:=int;

                     writeln;
                     write('Equip armor (0 for none): ');
                     readln(str);
                     val(str,int,err);
                     if (int>monster.numitems) then int:=0;
                     if (monster.item[int].v[0]<>2) then int:=0;
                     monster.armor:=int;
                  end;
      end; {case}
   until (done);

end;
{--------------------------------------------------------------------------}
procedure multimn(var monster:monsterlist);

var
   start       : word;
   stop        : word;
   str         : string;
   err         : word;
   loop        : word;
   int         : word;
   newmonster  : monsterrecord;

begin
   writeln('Enter the range of monsters you want to create out of (1) to (',NUM_MONST,')');
   write('Start: ':8);
   readln(str);
   val(str,start,err);
   write('Stop: ':8);
   readln(str);
   val(str,stop,err);
   writeln;
   if (start in [1..NUM_MONST])and(stop in [1..NUM_MONST])and(start<=stop) then
      begin
         with newmonster do
            begin
               write('Monster name: ':20);
               readln(name);
               write('Description: ':20);
               readln(desc);
               write('Auto attacks? (y/n) ':20);
               readln(str);
               autoatt:=str[1] in ['y','Y'];
               write('Wanders? (y/n) ':20);
               readln(str);
               wander:=str[1] in ['y','Y'];
               write('Level: ':20);
               readln(str);
               val(str,lv,err);
               if (lv < 0) then lv:=0;
               write('Hit points: ':20);
               readln(str);
               val(str,maxhp,err);
               if (maxhp < 1) then maxhp:=1;
               hp:=maxhp;
               write('Gold: ':20);
               readln(str);
               val(str,gold,err);
               if (gold < 0) then gold:=0;
               write('Location: ':20);
               readln(str);
               val(str,where,err);
               if not(where in [1..NUM_ROOMS]) then where:=0;
               numitems:=0;
               moditems(numitems,item);
               write('Equip weapon: ':20);
               readln(str);
               val(str,int,err);
               if (int>numitems) then int:=0;
               if (item[int].v[0]<>1) then int:=0;
               weapon:=int;
               write('Equip armor: ':20);
               readln(str);
               val(str,int,err);
               if (int>numitems) then int:=0;
               if (item[int].v[0]<>2) then int:=0;
               armor:=int;
               writeln('Natural damage XdY+Z');
               write('X: ':20);
               readln(str);
               val(str,int,err);
               if (int<0) then int:=0;
               dmg[1]:=int;
               write('Y: ':20);
               readln(str);
               val(str,int,err);
               if (int<0) then int:=0;
               dmg[2]:=int;
               write('Z: ':20);
               readln(str);
               val(str,int,err);
               dmg[3]:=int;
               write('Xp value: ':20);
               readln(str);
               val(str,xpv,err);
               if (xpv < 0) then xpv:=0;
               alive:=true;
               displaymn(newmonster);
               writeln;
            end;
         write('Copy these stats into monsters (',start,') to (',stop,')? (y/n) ');
         readln(str);
         if (str[1] in ['y','Y']) then
            for loop:=start to stop do
               monster[loop]:=newmonster;
      end
   else
      writeln('Invalid range.');

end;
{--------------------------------------------------------------------------}
procedure modmonsters(var mn:monsterlist);

var
   done   :  boolean;
   loop   :  word;
   str    :  string;
   int    :  word;
   err    :  word;
   ans             : char;

begin
   done:=false;
   clrscr;
   writeln('Number of monsters: ',NUM_MONST);
   writeln;
   repeat
      writeln;
      writeln('(0) List monsters, Modify: (1) to (',NUM_MONST,'), (M)ulti-create,');
      writeln('(L)oad, (S)ave, (Q)uit');
      write('Selection: ');
      readln(str);
      ans:=str[1];
      case ans of
         '0'     :for loop:=1 to NUM_MONST do
                     begin
                        writeln(' (',loop,') ',mn[loop].name);
                        if ((loop MOD 21)=0) then
                           begin
                              writeln;
                              write('Press <enter> to continue...');
                              readln;
                           end;
                     end;
         'M','m' :multimn(mn);
         'S','s' :savemonsterlist(MONST_FILE,mn);
         'L','l' :loadmonsterlist(MONST_FILE,mn);
         'Q','q' :done:=true;
      end; {case}
      val(str,int,err);
      if (int in [1..NUM_MONST]) then
         modmon(mn[int]);
   until (done);
end;
{--------------------------------------------------------------------------}
procedure displayrm(room:roomrecord);

var
   loop     : word;

begin
      with room do
         begin
            writeln('(1)','Name:  ':16,name);
            writeln('(2)','Desc file:  ':16,desc);
            writeln('--');
            writefile2screen(ROOM_DIR + desc);
            writeln('--');
            writeln('(3)','North:  ':16,ex[n]);
            writeln('(4)','South:  ':16,ex[s]);
            writeln('(5)','East:  ':16,ex[e]);
            writeln('(6)','West:  ':16,ex[w]);
            writeln('(7)','Items:  ':16,numitems);
            writeln('--');
            for loop:=1 to numitems do
               with item[loop] do
                  begin
                     write(loop:2,'.',name:20,',');
                     case v[0] of
                        0 :begin
                              write('item,':8);
                              write(v[1]:6,' gp');
                           end;
                        1 :begin
                              write('weapon,':8);
                              write(v[1]:6,' gp,');
                              write(v[2]:3,' + to hit, ');
                              write(v[3]:3,'d',v[4]);
                              if (v[5]>=0) then
                                 write('+');
                              write(v[5],' dmg');
                           end;
                        2 :begin
                              write('armor,':8);
                              write(v[1]:6,' gp,');
                              write(v[2]:3,' + AC');
                           end;
                     end; {case}
                     if (magical) then
                        write('*':3);
                     writeln;
                  end;
            writeln('--');
            writeln('(8)','Gold:  ':16,gold);
         end;
end;
{--------------------------------------------------------------------------}
procedure modrm(var room:roomrecord);

var
   done   :  boolean;
   str    :  string;
   int    :  word;
   err    :  word;
   ans    : char;

begin
   done:=false;
   repeat
      clrscr;
      writeln;
      displayrm(room);
      writeln;
      writeln('Modify: (1) to (8), (Q)uit');
      write('Selection: ');
      readln(ans);
      writeln;
      case ans of
         'Q','q' :done:=true;
         '1'     :begin
                     writeln('Name: ',room.name);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        room.name:=str;
                  end;
         '2'     :begin
                     writeln('Description file: ',room.desc);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        room.desc:=str;
                  end;
         '3'     :begin
                     writeln('North to room #: ',room.ex[n]);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,room.ex[n],err);
                     if (room.ex[n]<0)or(room.ex[n]>NUM_ROOMS) then room.ex[n]:=0;
                  end;
         '4'     :begin
                     writeln('South to room #: ',room.ex[s]);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,room.ex[s],err);
                     if (room.ex[s]<0)or(room.ex[s]>NUM_ROOMS) then room.ex[s]:=0;
                  end;
         '5'     :begin
                     writeln('East to room #: ',room.ex[e]);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,room.ex[e],err);
                     if (room.ex[e]<0)or(room.ex[e]>NUM_ROOMS) then room.ex[e]:=0;
                  end;
         '6'     :begin
                     writeln('West to room #: ',room.ex[w]);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,room.ex[w],err);
                     if (room.ex[w]<0)or(room.ex[w]>NUM_ROOMS) then room.ex[w]:=0;
                  end;
         '7'     :begin
                     moditems(room.numitems,room.item);
                  end;
         '8'     :begin
                     writeln('Gold: ',room.gold);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,room.gold,err);
                     if (room.gold<0) then room.gold:=0;
                  end;
      end; {case}
   until (done);

end;
{--------------------------------------------------------------------------}
procedure multirm(var room:roomlist);

var
   start       : word;
   stop        : word;
   str         : string;
   err         : word;
   loop        : word;
   newroom     : roomrecord;

begin
   writeln('Enter the range of rooms you want to create out of (1) to (',NUM_ROOMS,')');
   write('Start: ':8);
   readln(str);
   val(str,start,err);
   write('Stop: ':8);
   readln(str);
   val(str,stop,err);
   writeln;
   if (start in [1..NUM_ROOMS])and(stop in [1..NUM_ROOMS])and(start<=stop) then
      begin
         with newroom do
            begin
               write('Room name: ':20);
               readln(name);
               write('Description: ':20);
               readln(desc);
               writeln('Exits to room #, enter 0 for none');
               write('North: ':20);
               readln(str);
               val(str,ex[n],err);
               if (ex[n] < 0) then ex[n]:=0;
               write('South: ':20);
               readln(str);
               val(str,ex[s],err);
               if (ex[s] < 0) then ex[s]:=0;
               write('East: ':20);
               readln(str);
               val(str,ex[e],err);
               if (ex[e] < 0) then ex[e]:=0;
               write('West: ':20);
               readln(str);
               val(str,ex[w],err);
               if (ex[w] < 0) then ex[w]:=0;
               write('Gold: ':20);
               readln(str);
               val(str,gold,err);
               if (gold < 0) then gold:=0;
               numitems:=0;
               moditems(numitems,item);
               displayrm(newroom);
               writeln;
            end;
         write('Copy these stats into rooms (',start,') to (',stop,')? (y/n) ');
         readln(str);
         if (str[1] in ['y','Y']) then
            for loop:=start to stop do
               room[loop]:=newroom;
      end
   else
      writeln('Invalid range.');

end;
{--------------------------------------------------------------------------}
procedure modrooms(var rm:roomlist);

var
   done   :  boolean;
   loop   :  word;
   str    :  string;
   int    :  word;
   err    :  word;
   ans    : char;

begin
   done:=false;
   clrscr;
   writeln('Number of rooms: ',NUM_ROOMS);
   writeln;
   repeat
      writeln;
      writeln('(0) List rooms, Modify: (1) to (',NUM_ROOMS,'), (M)ulti-create,');
      writeln('(L)oad, (S)ave, (Q)uit');
      write('Selection: ');
      readln(str);
      ans:=str[1];
      case ans of
         '0'     :for loop:=1 to NUM_ROOMS do
                     begin
                        writeln(' (',loop,') ',rm[loop].name);
                        if ((loop MOD 21)=0) then
                           begin
                              writeln;
                              write('Press <enter> to continue...');
                              readln;
                           end;
                     end;
         'M','m' :multirm(rm);
         'S','s' :saveroomlist(ROOM_FILE,rm);
         'L','l' :loadroomlist(ROOM_FILE,rm);
         'Q','q' :done:=true;
      end; {case}
      val(str,int,err);
      if (int in [1..NUM_ROOMS]) then
         modrm(rm[int]);
   until (done);
end;
{--------------------------------------------------------------------------}
procedure displaysh(shop:shoprecord);

var
   loop     : word;

begin
   with shop do
      begin
         writeln('(1)','Name:  ':16,name);
         writeln('(2)','Description:  ':16,desc);
         writeln('(3)','Room #:  ':16,where);
         writeln('(4)','Items:  ':16,numitems);
         writeln('--');
         for loop:=1 to numitems do
            with item[loop] do
               begin
                  write(loop:2,'.',name:20,',');
                  case v[0] of
                     0 :begin
                           write('item,':8);
                           write(v[1]:6,' gp');
                        end;
                     1 :begin
                           write('weapon,':8);
                           write(v[1]:6,' gp,');
                           write(v[2]:3,' + to hit, ');
                           write(v[3]:3,'d',v[4]);
                           if (v[5]>=0) then
                              write('+');
                           write(v[5],' dmg');
                        end;
                     2 :begin
                           write('armor,':8);
                           write(v[1]:6,' gp,');
                           write(v[2]:3,' + AC');
                        end;
                  end; {case}
                  if (magical) then
                     write('*':3);
                  writeln;
               end;
         writeln('--');
      end;
end;
{--------------------------------------------------------------------------}
procedure modsh(var shop:shoprecord);

var

   done   :  boolean;
   str    :  string;
   int    :  word;
   err    :  word;
   ans    : char;

begin
   done:=false;
   repeat
      clrscr;
      writeln;
      displaysh(shop);
      writeln;
      writeln('Modify: (1) to (8), (Q)uit');
      write('Selection: ');
      readln(ans);
      writeln;
      case ans of
         'Q','q' :done:=true;
         '1'     :begin
                     writeln('Name: ',shop.name);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        shop.name:=str;
                  end;
         '2'     :begin
                     writeln('Description: ',shop.desc);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        shop.desc:=str;
                  end;
         '3'     :begin
                     writeln('Room #: ',shop.where);
                     write('Change to: ');
                     readln(str);
                     if not(str='') then
                        val(str,shop.where,err);
                     if (shop.where<0)or(shop.where>NUM_ROOMS) then shop.where:=0;
                  end;
         '4'     :begin
                     moditems(shop.numitems,shop.item);
                  end;
      end; {case}
   until (done);

end;
{--------------------------------------------------------------------------}
procedure multish(var shop:shoplist);

var
   start       : word;
   stop        : word;
   str         : string;
   err         : word;
   loop        : word;
   newshop     : shoprecord;

begin
   writeln('Enter the range of shops you want to create out of (1) to (',NUM_SHOPS,')');
   write('Start: ':8);
   readln(str);
   val(str,start,err);
   write('Stop: ':8);
   readln(str);
   val(str,stop,err);
   writeln;
   if (start in [1..NUM_SHOPS])and(stop in [1..NUM_SHOPS])and(start<=stop) then
      begin
         with newshop do
            begin
               write('Shop name: ':20);
               readln(name);
               write('Description: ':20);
               readln(desc);
               write('Location: ':20);
               readln(str);
               val(str,where,err);
               if (where < 0) then where:=0;
               numitems:=0;
               moditems(numitems,item);
               displaysh(newshop);
               writeln;
            end;
         write('Copy these stats into shops (',start,') to (',stop,')? (y/n) ');
         readln(str);
         if (str[1] in ['y','Y']) then
            for loop:=start to stop do
               shop[loop]:=newshop;
      end
   else
      writeln('Invalid range.');

end;
{--------------------------------------------------------------------------}
procedure modshops(var sh:shoplist);

var
   done   :  boolean;
   loop   :  word;
   str    :  string;
   int    :  word;
   err    :  word;
   ans    : char;

begin
   done:=false;
   clrscr;
   writeln('Number of shops: ',NUM_SHOPS);
   writeln;
   repeat
      writeln;
      writeln('(0) List shops, Modify: (1) to (',NUM_SHOPS,'), (M)ulti-create,');
      writeln('(L)oad, (S)ave, (Q)uit');
      write('Selection: ');
      readln(str);
      ans:=str[1];
      case ans of
         '0'     :for loop:=1 to NUM_SHOPS do
                     begin
                        writeln(' (',loop,') ',sh[loop].name);
                        if ((loop MOD 21)=0) then
                           begin
                              writeln;
                              write('Press <enter> to continue...');
                              readln;
                           end;
                     end;
         'M','m' :multish(sh);
         'S','s' :saveshoplist(SHOP_FILE,sh);
         'L','l' :loadshoplist(SHOP_FILE,sh);
         'Q','q' :done:=true;
      end; {case}
      val(str,int,err);
      if (int in [1..NUM_SHOPS]) then
         modsh(sh[int]);
   until (done);
end;
{--------------------------------------------------------------------------}
procedure create;

var
   rm   :  roomlist;
   mn   :  monsterlist;
   pl   :  playerrecord;
   sh   :  shoplist;
   done :  boolean;
   ans    : char;
   loop    : word;

begin

if (exist(PLAYER_FILE)) then
   loadplayer(PLAYER_FILE,pl)
else
   with pl do
      begin
         name:='Conan';
         lv:=1;
         hp:=MAX_HP_LV;
         maxhp:=MAX_HP_LV;
         gold:=20;
         where:=1;
         numitems:=3;
         item[1].name:='Crom''s Sword';
         item[1].v[0]:=1;
         item[1].v[1]:=1000;
         item[1].v[2]:=18;
         item[1].v[3]:=1;
         item[1].v[4]:=10;
         item[1].v[5]:=3;
         item[1].magical:=true;
         item[2].name:='skins';
         item[2].v[0]:=2;
         item[2].v[1]:=5;
         item[2].v[2]:=3;
         item[2].magical:=false;
         item[3].name:='a copper amulet';
         item[3].v[0]:=0;
         item[3].v[1]:=10;
         item[3].magical:=false;
         weapon:=1;
         armor:=2;
         xp:=0;
      end;

if (exist(MONST_FILE)) then
   loadmonsterlist(MONST_FILE,mn)
else
   for loop:=1 to 10 do
      with mn[loop] do
         begin
            name:='a rabbit';
            desc:='A cute little rabbit is sniffing around for food.';
            autoatt:=false;
            wander:=true;
            lv:=0;
            hp:=2;
            maxhp:=2;
            gold:=0;
            where:=loop;
            numitems:=0;
            weapon:=0;
            armor:=0;
            dmg[1]:=0;
            dmg[2]:=0;
            dmg[3]:=0;
            alive:=true;
            xpv:=2;
         end;
   
if (exist(MONST_FILE)) then
   loadmonsterlist(MONST_FILE,mn)
else
   for loop:=11 to NUM_MONST do
      with mn[loop] do
         begin
            name:='a guard';
            desc:='A typical dumb guard is guarding his post.';
            autoatt:=false;
            wander:=false;
            lv:=2;
            hp:=20;
            maxhp:=20;
            gold:=100;
            where:=loop;
            numitems:=2;
            item[1].name:='a sword';
            item[1].v[0]:=1;
            item[1].v[1]:=10;
            item[1].v[2]:=0;
            item[1].v[3]:=1;
            item[1].v[4]:=8;
            item[1].v[5]:=0;
            item[1].magical:=false;
            item[2].name:='plate mail';
            item[2].v[0]:=2;
            item[2].v[1]:=500;
            item[2].v[2]:=30;
            item[2].magical:=false;
            weapon:=1;
            armor:=2;
            dmg[1]:=1;
            dmg[2]:=2;
            dmg[3]:=0;
            alive:=true;
            xpv:=20;
         end;
   
if (exist(ROOM_FILE)) then
   loadroomlist(ROOM_FILE,rm)
else
   for loop:=1 to NUM_ROOMS do
      with rm[loop] do
         begin
            name:='Just another room.';
            desc:='default.txt';
            ex[n]:=0;
            ex[s]:=0;
            ex[e]:=0;
            ex[w]:=0;
            if (loop<NUM_ROOMS) then
               ex[n]:=loop+1
            else
               ex[w]:=1;
            gold:=0;
            numitems:=1;
            item[1].name:='a pebble';
            item[1].v[0]:=0;
            item[1].v[1]:=0;
            item[1].magical:=false;
         end;

if (exist(SHOP_FILE)) then
   loadshoplist(SHOP_FILE,sh)
else
   for loop:=1 to NUM_SHOPS do
      with sh[loop] do
         begin
            name:='A typical shop.';
            desc:='"Please view my fine wares," asks the shopkeeper.';
            where:=loop + (NUM_ROOMS DIV NUM_SHOPS);
            numitems:=2;
            item[1].name:='a pole axe';
            item[1].v[0]:=1;
            item[1].v[1]:=15;
            item[1].v[2]:=0;
            item[1].v[3]:=1;
            item[1].v[4]:=10;
            item[1].v[5]:=0;
            item[1].magical:=false;
            item[2].name:='chain mail';
            item[2].v[0]:=2;
            item[2].v[1]:=300;
            item[2].v[2]:=20;
            item[2].magical:=false;
         end;
   
done:=false;
repeat
   writeln;
   writeln('-');
   writeln('Main Menu:');
   writeln('(1) View/modify player stats');
   writeln('(2) View/modify monsters');
   writeln('(3) View/modify rooms');
   writeln('(4) View/modify shops');
   writeln;
   writeln('(L)oad all');
   writeln('(S)ave all');
   writeln('(Q)uit');
   writeln;
   write('Selection: ');
   readln(ans);
   writeln;
   case ans of
      'Q','q' :begin
                  write('Would you like to save before quitting? (y/n) ');
                  readln(ans);
                  if (ans in ['y','Y']) then
                     begin
                        saveplayer(PLAYER_FILE,pl);
                        savemonsterlist(MONST_FILE,mn);
                        saveroomlist(ROOM_FILE,rm);
                        saveshoplist(SHOP_FILE,sh);
                     end;
                  done:=true;
               end;
      'L','l' :begin
                  loadplayer(PLAYER_FILE,pl);
                  loadmonsterlist(MONST_FILE,mn);
                  loadroomlist(ROOM_FILE,rm);
                  loadshoplist(SHOP_FILE,sh);
               end;
      'S','s' :begin
                  saveplayer(PLAYER_FILE,pl);
                  savemonsterlist(MONST_FILE,mn);
                  saveroomlist(ROOM_FILE,rm);
                  saveshoplist(SHOP_FILE,sh);
               end;
      '1'     :modplayer(pl);
      '2'     :modmonsters(mn);
      '3'     :modrooms(rm);
      '4'     :modshops(sh);
   else
      writeln('Please choose from the menu below.');
   end;{case}
until (done);

writeln('Good bye!');

end;
{--------------------------------------------------------------------------}


BEGIN

   writeln('Simple Game Creator ',VERSION);
   writeln('Copyright (C) 2002 Angelo Bertolli');

   create;

END.
