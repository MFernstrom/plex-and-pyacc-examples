%{
{ Chapter 3, Example 03
	Variables and Types tokens }

program ch3_03;
 
{$mode objfpc}{$H+}
 
uses SysUtils, yacclib, lexlib;

var
	vbltable: array[0..26] of Double;

procedure yyerror(s: string);
begin
  WriteLn(Format('Error: %s', [s]));
end;
 
%}

%token <Integer> NAME
%token <Double> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <Double> expression
%%

statement_list:		statement '\n'
				|					statement_list statement '\n'
				;

statement: 				NAME	'=' expression					{ vbltable[$1] := $3 }
				|					expression										{ writeln(format('= %f' + Chr(13),[$1])); }
				;

expression:				expression '+' NUMBER					{ $$ := $1 + $3; }
				|					expression '-' NUMBER					{ $$ := $1 - $3; }
				|					expression '*' NUMBER					{ $$ := $1 * $3; }
				|					expression '/' NUMBER					{ begin
																									if $3 = 0.0 then
																										yyerror('divide by zero')
																									else
																										$$ := $1 / $3;
																								end;}
				|					'-' expression %prec UMINUS		{ $$ := -$2 }
				|					'(' expression ')'						{ $$ := $2 }
				|					NUMBER												
				|					NAME													{ $$ := vbltable[$1] }
				;

%%
 
{$include ch3_03_l.pas}

begin
  yyparse();
end.