%{
	{ Chapter 3, Example 03
		Variables and Types tokens }
%}

%%

([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)		begin yylval.yyDouble := StrToFloat(yytext); return(NUMBER); end;

[ \t]																					; {Ignore whitespace}

[a-z]																					begin yylval.yyDouble := ord(yytext[0]) - ord('a'); return(NAME); end;

"$"																						return(0);

\n 																						return(ord(yytext[1]));
. 																						return(ord(yytext[1]));

%%