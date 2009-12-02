{*********************************************************************
Wizard Password Creator
Copyright (C) 2002 Angelo Bertolli

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

For conditions of distribution and use, see GNU license in the
file readme.txt
*********************************************************************}

program WizPasswd;

uses crt;

const

   VERSION         =  '1.0';
   WIZ_FILE        =  'passwd.wiz';
   CHUNK           =  4;

type

   crypt_matrix_t  =  array[1..CHUNK,1..CHUNK] of shortint;
   encrypt_msg     =  array[0..255] of integer;

var

   passwd          :  string;
   encrypted_passwd:  encrypt_msg;
   A               :  crypt_matrix_t;
   loop            :  byte;

{--------------------------------------------------------------------------}
function get_matrix(i:integer):crypt_matrix_t;

var
   A       : crypt_matrix_t;

begin

A[1,1]:=1;
A[1,2]:=0;
A[1,3]:=0;
A[1,4]:=0;
A[2,1]:=0;
A[2,2]:=1;
A[2,3]:=0;
A[2,4]:=0;
A[3,1]:=0;
A[3,2]:=0;
A[3,3]:=1;
A[3,4]:=0;
A[4,1]:=0;
A[4,2]:=0;
A[4,3]:=0;
A[4,4]:=1;

{ Encrypting Matrix
  1  -2  -1  -2
  3  -5  -2  -3
  2  -5  -2  -5
 -1   4   4  11
}

if (i>0) then
   begin
      A[1,1]:=1;
      A[1,2]:=-2;
      A[1,3]:=-1;
      A[1,4]:=-2;
      A[2,1]:=3;
      A[2,2]:=-5;
      A[2,3]:=-2;
      A[2,4]:=-3;
      A[3,1]:=2;
      A[3,2]:=-5;
      A[3,3]:=-2;
      A[3,4]:=-5;
      A[4,1]:=-1;
      A[4,2]:=4;
      A[4,3]:=4;
      A[4,4]:=11;
   end;

{ Decrypting Matrix
-24   7   1  -2
-10   3   0  -1
-29   7   3  -2
 12  -3  -1   1
}

if (i<0) then
   begin
      A[1,1]:=-24;
      A[1,2]:=7;
      A[1,3]:=1;
      A[1,4]:=-2;
      A[2,1]:=-10;
      A[2,2]:=3;
      A[2,3]:=0;
      A[2,4]:=-1;
      A[3,1]:=-29;
      A[3,2]:=7;
      A[3,3]:=3;
      A[3,4]:=-2;
      A[4,1]:=12;
      A[4,2]:=-3;
      A[4,3]:=-1;
      A[4,4]:=1;
   end;

end;
{--------------------------------------------------------------------------}
function encrypt(A:crypt_matrix_t;s:string):encrypt_msg;

var
   msg   : encrypt_msg;
   loop  : byte;
   count : byte;

begin
   msg[0]:=length(s);
   for loop:=1 to msg[0] do
      for count:=1 to CHUNK do

end;
{--------------------------------------------------------------------------}


BEGIN

   writeln('Wizard Password Creator ',VERSION);
   writeln('Copyright (C) 2002 Angelo Bertolli');

   writeln;
   write('Input Wizard Password: ');
   readln(passwd);

   A:=get_matrix(1);
   encrypted_passwd:=encrypt(A,passwd);

   writeln;
   writeln('Password:  ',passwd);
   writeln('Encryption: ');
   for loop:=1 to encrypted_password[0] do
      writeln(encrypted_passwd[loop]);


END.


