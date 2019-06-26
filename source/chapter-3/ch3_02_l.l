%{
%}

%%

[0-9]+			begin yylval.yyInteger := StrToInt(yytext); return(NUMBER); end;
[ \t]				; {Ignore whitespace}
[+-]				returnc(yytext[1]);
\n 					return(0);
.						return(StrToInt(yytext));

%%