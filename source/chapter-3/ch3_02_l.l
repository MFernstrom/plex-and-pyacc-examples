%{
	{ Chapter 3, Example 02
		Variables and Types tokens }
%}

%%

[0-9]+			begin yylval.yyInteger := StrToInt(yytext); return(NUMBER); end;
[ \t]				; {Ignore whitespace}
\n 					return(0);
.						returnc(yytext[1]);

%%