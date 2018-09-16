%{
  {
    Simple word recognizer for more word types
  }
  program words;

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

very |
simply |
gently |
quietly |
calmly |
angrily                 begin WriteLn(format('"%s" is an adverb', [yytext])) end;

to |
from |
behind |
above |
below |
between                 begin WriteLn(format('"%s" is a preposition', [yytext])) end;

if |
then |
and |
but |
or                      begin WriteLn(format('"%s" is a conjunction', [yytext])) end;

their |
my |
your |
his |
her |
its                     begin WriteLn(format('"%s" is an adjective', [yytext])) end;

I |
you |
he |
she |
we |
they                    begin WriteLn(format('"%s" is a pronoun', [yytext])) end;

[a-zA-Z]+               begin WriteLn(format('"%s" doesn''t recognize', [yytext])) end;

%%
begin
  yylex();
end.