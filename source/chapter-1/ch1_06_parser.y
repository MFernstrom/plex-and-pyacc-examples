%{
{
	Chapter 1 - 06 parser
}
program ch1_06;
 
{$mode objfpc}{$H+}
 
uses SysUtils, yacclib, lexlib;

type
	TStateEnum = (LOOKUP = 0);
	TWord = record
		name: String;
		word_type: SmallInt;
	end;

var
	srcFile: TextFile;
	state: SmallInt;
	words: array of TWord;

procedure yyerror(s: string);
begin
  WriteLn(Format('Error: %s', [s]));
end;

function lookup_word(text: String): SmallInt;
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

	result := ord(LOOKUP);
end;

procedure add_word(state: SmallInt; text: String);
var
	count: Integer;
	tmp: TWord;
begin
	if lookup_word(text) = ord(LOOKUP) then begin
		writeln(format('Adding word %s of type %d', [text, state]));
		count := Length(words)-1;
		SetLength(words, count+2);
		tmp.name := text;
		tmp.word_type := state;
		words[count] := tmp;
	end else
		WriteLn(format('%s is already defined', [text]));
end;
 
%}
 
%token <Integer> VERB ADJECTIVE ADVERB NOUN PREPOSITION PRONOUN CONJUNCTION
 
%%
sentence: simple_sentence { writeln('Parsed a simple sentence') }
			|		compound_sentence { writeln('Parsed a compound sentence') }
			;

simple_sentence: 	subject verb object
			|						subject verb object prep_phrase
			;

compound_sentence: 	simple_sentence CONJUNCTION simple_sentence
			|							compound_sentence CONJUNCTION simple_sentence
			;

subject: 	NOUN
			|		PRONOUN
			|		ADJECTIVE subject
			;

verb:			VERB
			|		ADVERB VERB
			|		verb VERB
			;

object:		NOUN
			|		ADJECTIVE object
			;

prep_phrase:		PREPOSITION NOUN
			;
%%
 

{$include ch1_06_lexer.pas}
 
begin
	setlength(words, 1);
	Assign(srcFile, ParamStr(1));
	reset(srcFile);
  yyinput := srcFile;
  yyparse();
end.