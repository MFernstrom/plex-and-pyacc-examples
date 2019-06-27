%{
{
	Chapter 3, Example 03
	First example with precedence.
}
program ch3_03;
 
{$mode objfpc}{$H+}
 
uses SysUtils, yacclib, lexlib;

procedure yyerror(s: string);
begin
  WriteLn(Format('Error: %s', [s]));
end;
 
%}

%token <Integer> NAME NUMBER
%type <Integer> expression
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%%

statement: 	NAME	'=' expression
				|		expression						{ writeln(format('= %d' + Chr(13),[$1])); }
				;

expression:	expression '+' NUMBER					{ $$ := $1 + $3; }
				|		expression '-' NUMBER					{ $$ := $1 - $3; }
				|		expression '*' NUMBER					{ $$ := $1 * $3; }
				|		expression '/' NUMBER					{ begin
																						if $3 = 0 then
																							yyerror('divide by zero')
																						else
																							$$ := round($1 / $3);
																					end;}
				|		'-' expression %prec UMINUS		{ $$ := -$2 }
				|		'(' expression ')'						{ $$ := $2 }
				|		NUMBER												{ $$ := $1; }
				;

%%
 
{$include ch3_02_l.pas}

begin
  yyparse();
end.