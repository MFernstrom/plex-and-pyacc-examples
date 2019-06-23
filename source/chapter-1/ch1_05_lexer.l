{
	Chapter 1 - 05 Lexer
}
 
%{
%}
%%
 
\n					state := ord(LOOKUP);

\.\n				begin
							state := ord(LOOKUP);
							return(0);
						end;

^verb				state := ord(VERB);
^adj				state := ord(ADJECTIVE);
^adv				state := ord(ADVERB);
^noun				state := ord(NOUN);
^prep				state := ord(PREPOSITION);
^pron				state := ord(PRONOUN);
^conj				state := ord(CONJUNCTION);

[a-zA-Z]+		begin
							if state <> ord(LOOKUP) then
								add_word(state, yytext)
							else begin
								case lookup_word(yytext) of
									ord(VERB): return(VERB);
									ord(ADJECTIVE): return(ADJECTIVE);
									ord(ADVERB): return(ADVERB);
									ord(NOUN): return(NOUN);
									ord(PREPOSITION): return(PREPOSITION);
									ord(PRONOUN): return(PRONOUN);
									ord(CONJUNCTION): return(CONJUNCTION);
								else
									writeln(format('Don''t recognize %s', [yytext]));
								end;
							end;
						end;

.						{Ignoring other characters};

%%