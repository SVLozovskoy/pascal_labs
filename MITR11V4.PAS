program Mitr11;
uses crt, Dos;
type  inf_o_lek=record
           naz_lek,naz_firm:string[15];
           kollek,price:integer;
           end;
function getNumber:integer;
var value:integer;
begin
  window(10,6,70,25);
  textbackground(0);
  textcolor(3);
  clrscr;
  write('Введите количество лекарств в аптечке: ');
  readln(value);
  getNumber:=value;
end;
procedure inputData(var i:inf_o_lek);
begin
  write('Введите название лекарства: ');
  readln(i.naz_lek);
  write('Введите название фирмы-производителя: ' );
  readln(i.naz_firm);
  write('Введите стоимость лекарства в рублях: ');
  readln(i.price);
  write('Введите количество ',i.naz_lek,' в штуках: ');
  readln(i.kollek);
end;
procedure showHeader;
begin
  window(10,6,70,25);
  clrscr;
  textcolor(6);
  write('Стоимость автомобильной аптечки: ');
  window(10,7,70,25);
  textbackground(6);
  textcolor(4);
  clrscr;
  write('Наименование');
  gotoxy(16,1);
  write('Производитель');
  gotoxy(32,1);
  write('Количество');
  gotoxy(44,1);
  write('Цена');
  gotoxy(32,2);
  write('Шт');
  gotoxy(44,2);
  write('Руб');
  gotoxy(50,2);
  write('Руб');
  gotoxy(50,1);
  write('Сумма');
  textcolor(4);
end;
procedure showResults(var i:inf_o_lek; var cnt:byte);
begin
  gotoxy(1,cnt+2);
  write(i.naz_lek);
  gotoxy(16,cnt+2);
  write(i.naz_firm);
  gotoxy(32,cnt+2);
  write(i.kollek);
  gotoxy(44,cnt+2);
  write(i.price);
  gotoxy(50,cnt+2);
  write(i.price*i.kollek);
end;
procedure showMainMenu;
begin
  window(10,3,70,4);
  textbackground(0);
  textcolor(2);
  gotoxy(1,1);
  writeln('alt+i - Ввод данных | alt+r - Вывод данных | alt+e - Выход');
end;
function getFileName:string;
   var value:string;
begin
  textbackground(0);
  textcolor(15);
  clrscr;
  write('Введите имя файла для ваших данных: ');
  readln(value);
  getFileName:=value;
end;
function FileExists(FileName : string) : boolean;
var FileParameters : SearchRec;
begin
  FindFirst(FileName,AnyFile,FileParameters);
  if (DosError = 0)
   then
  FileExists := True
   else
  FileExists := False;
end;
var i:integer;
    cn,flag:byte;
    summa:array[1..15] of integer;
    q_ty,quantity,totalprice:integer;
    inf:array[1..15] of inf_o_lek;
    oldTextAttr:byte;
    dataFile:FILE OF inf_o_lek;
    fileName:string;
begin
  clrscr;
  oldTextAttr:=TextAttr;
  flag:=0;
repeat
  showMainMenu;
  case ReadKey of
    #0: case ReadKey of
      #23: begin             {'alt+i'}
             if flag = 0 then
             begin
               fileName:=getFileName;
               Assign(dataFile, fileName);
               flag:=1;
               if not fileexists(fileName)
                then
                begin
                  Rewrite(dataFile);
                  q_ty:=1;
                end;
             end;
             reset(dataFile);
             Seek(dataFile,Filesize(datafile));
             for i:=q_ty to q_ty+getNumber-1 do
               begin
                 q_ty:=q_ty+1;
                 inputData(inf[i]);
                 summa[i]:=inf[i].price*inf[i].kollek;
                 totalprice:=totalprice+summa[i];
                 write(dataFile, inf[i]);
               end;
               Close(dataFile);
               flag:=1;
               clrscr;
             end;
          #19: begin                 { 'alt+r'}
                 if flag = 0 then
                 begin
                   totalprice:=0;
                   q_ty:=1;
                   flag:=1;
                   fileName:=getFileName;
                   Assign(dataFile, fileName);
                   if not fileexists(fileName)
                     then begin
                       Rewrite(dataFile);
                     end
                   else
                     begin
                      reset(dataFile);
                      repeat
                        Read(dataFile, inf[q_ty]);
                        summa[q_ty]:=inf[q_ty].price*inf[q_ty].kollek;
                        totalprice:=totalprice+summa[q_ty];
                        q_ty:=q_ty+1;
                      until eof(dataFile);
                     end;
                   end
                   else
                   begin
                     q_ty:=1;
                     totalprice:=0;
                     Assign(dataFile, fileName);
                     reset(dataFile);
                      repeat
                        Read(dataFile, inf[q_ty]);
                        summa[q_ty]:=inf[q_ty].price*inf[q_ty].kollek;
                        totalprice:=totalprice+summa[q_ty];
                        q_ty:=q_ty+1;
                      until eof(dataFile);
                   end;
                   Close(dataFile);
                   showHeader;
                   for i:=1 to q_ty-1 do
                   begin
                     cn:=i+1;
                     showResults(inf[i],cn);
                   end;
                   writeln;
                   writeln('Итого: ',totalprice,' Руб');
                 end;
          #18: begin              { 'alt+e}
                 TextAttr:=oldTextAttr;
                 clrscr;
                 halt;
               end;
        end;
   end;
until q_ty=0;
   TextAttr:=oldTextAttr;
   clrscr;
end.



