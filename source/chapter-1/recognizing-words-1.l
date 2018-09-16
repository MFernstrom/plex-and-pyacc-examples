%{
  {
    Simple verb/not-verb recognizer
  }
  program verbs;

  {$mode objfpc}

  uses sysutils, yacclib, lexlib;
%}
%%
[\t ]+                  {Ignore whitespace};

is |
am |
are |
were |
was |
be |
being |
been |
do |
does |
did |
should |
can |
could |
has |
have |
had |
go                      begin WriteLn(format('"%s" is a verb', [yytext])) end;

[a-zA-Z]+               begin WriteLn(format('"%s" is not a verb', [yytext])) end;

%%
begin
  yylex();
end.