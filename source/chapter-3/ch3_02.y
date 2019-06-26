%{
{
	Chapter 3, Example 02
}
program ch3_02;
 
{$mode objfpc}{$H+}
 
uses SysUtils, yacclib, lexlib;

procedure yyerror(s: string);
begin
  WriteLn(Format('Error: %s', [s]));
end;
 
%}

%token <Integer> NAME NUMBER
%type <Integer> expression

%%

statement: 	NAME	'=' expression
				|		expression						{ writeln(format('= %d' + Chr(13),[$1])); }
				;

expression:	expression '+' NUMBER			{ $$ := $1 + $3; }
				|		expression '-' NUMBER			{ $$ := $1 - $3; }
				|		NUMBER										{ $$ := $1; }
				;

%%
 
{$include ch3_02_l.pas}

begin
  yyparse();
end.