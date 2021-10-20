program tic_tac_toe;

uses
  sysUtils, classes, fgl;

type
    (*for parameter*)
    TArr2D = array of array of integer;

(*procedure/function*)
procedure display(board:TArr2D);
(*print board*)
var
i, j: integer;
begin
    for i := 0 to 2 do
    begin
        writeln('+-------+-------+-------+');
        writeln('|       |       |       |');
        for j := 0 to 2 do
        begin
            if board[i, j] = 10 then
                write('|   O   ')
            else if board[i, j] = 11 then
                write('|   X   ')
            else
                write('|   ', board[i, j], '   ');
        end;
        writeln('|');
        writeln('|       |       |       |');
    end;
    writeln('+-------+-------+-------+');
end;

function find(board:TArr2D):specialize TFPGList<integer>;
(*find placeble positions*)
var
    result: specialize TFPGList<integer>;
    i: integer;
    row, col: integer;
begin
    result := specialize TFPGList<integer>.create;
    for i := 1 to 9 do
    begin
        row := (i-1) div 3;
        col := (i-1) mod 3;
        if board[row, col] in [1..9] then
            result.add(i);
    end;
    find := result;
end;

procedure move(var board:TArr2D);
(*computer randomly choose a free space to place O*)
var
    flist: specialize TFPGList<integer>;
    place: integer;
    row, col: integer;
begin
    randomize();
    flist := find(board);
    place := flist.items[random(flist.count-1)];
    writeln(place);
    row := (place-1) div 3;
    col := (place-1) mod 3;
    board[row, col] := 10;
    flist.free;
end;

procedure enter(var board:TArr2D);
(*user places X*)
var
    place: integer;
    row, col: integer;
begin
    repeat
        write('Enter your move: ');
        readln(place);
    until (find(board).indexof(place) <> -1); 
    row := (place-1) div 3;
    col := (place-1) mod 3;
    board[row, col] := 11;
end;

procedure judge(var board:TArr2D; var sign:boolean);
(*check whether user or computer wins*)
var
    i: integer;
begin
    for i := 0 to 2 do
    begin
        if (board[i, 0] = board[i, 1]) and (board[i, 1] = board[i, 2]) then sign := true;
        if (board[0, i] = board[1, i]) and (board[1, i] = board[2, i]) then sign := true;
    end;
    if (board[0, 0] = board[1, 1]) and (board[1, 1] = board[2, 2]) then sign := true;
    if (board[0, 2] = board[1, 1]) and (board[1, 1] = board[2, 0]) then sign := true;
end;

(*main*)
var
i, j: integer;
board: TArr2D;
turn, sign: boolean;
begin
    (*initialization*)
    turn := false;
    sign := false;
    setlength(board, 3, 3);
    for i := 0 to 2 do
        for j := 0 to 2 do
            board[i, j] := i * 3 + j + 1;

    (*game*)
    repeat
        display(board);
        if turn then move(board)
        else enter(board);
        judge(board, sign);
        if sign then
        begin
            display(board);
            if turn then writeln('The player using Os has won the game!')
            else writeln('The player using Xs has won the game!');
        end;
        turn := not turn;
    until sign;
end.
