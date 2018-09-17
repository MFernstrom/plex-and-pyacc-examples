%{
{
  Word recognizer with symbol table
}
program recognizer;

{$mode objfpc}

uses sysutils, yacclib, lexlib;

type
  TStateEnum = (LOOKUP = 0, VERB, ADJ, ADV, NOUN, PREP, PRON, CONJ);
	TWord = record
		name: String;
    word_type: TStateEnum;
	end;

var
  state: TStateEnum;
  words: array of TWord;

function lookup_word(text: String): TStateEnum;
var
  words_count, i: Integer;
  tmp: TWord;
begin
  words_count := Length(words)-1;
  for i := 0 to words_count do begin
    tmp := words[i];
    if tmp.name = text then
      exit(tmp.word_type);
  end;

  result := LOOKUP;
end;


procedure add_word(state: TStateEnum; text: String );
var
  count: Integer;
  tmp: TWord;
begin
  if lookup_word(text) = LOOKUP then begin
    count := Length(words)-1;
    SetLength(words, count+2);
    tmp.name := text;
    tmp.word_type := state;
    words[count] := tmp;
  end else
    WriteLn(format('"%s" is already defined', [text]));
end;
  
%}
%%
\n                      state := LOOKUP;

^verb                   state := VERB;
^adj                    state := ADJ;
^adv                    state := ADV;
^noun                   state := NOUN;
^prep                   state := PREP;
^pron                   state := PRON;
^conj                   state := CONJ;

[a-zA-Z]+               begin
                          if state <> LOOKUP then
                            add_word(state, yytext)
                          else begin
                            case lookup_word(yytext) of
                              VERB: WriteLn(format('%s: verb',[yytext]));
                              ADJ: WriteLn(format('%s: adjective',[yytext]));
                              ADV: WriteLn(format('%s: adverb',[yytext]));
                              NOUN: WriteLn(format('%s: noun',[yytext]));
                              PREP: WriteLn(format('%s: preposition',[yytext]));
                              PRON: WriteLn(format('%s: pronoun',[yytext]));
                              CONJ: WriteLn(format('%s: conjunction',[yytext]));
                              else WriteLn(format('%s: doesn''t recognize',[yytext]));
                            end; // End case
                          end; // End else
                        end; // End word match

.                       ;

%%
begin
  SetLength(words, 1);
  yylex();
end.