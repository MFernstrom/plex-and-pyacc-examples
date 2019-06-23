%{
  {
  	Plex-only wordcount, single file as second argument
  }
  program wordcounter;

  {$mode objfpc}

  uses sysutils, yacclib, lexlib;

  var
  	charCount, wordCount, lineCount: Integer;
  	srcFile: TextFile;
%}

word [^ \t\n]+
eol \n

%%

{word}			begin inc(wordCount); charCount := charCount + yyleng; end;
{eol}				begin inc(charCount); inc(lineCount); end;
.						begin inc(charCount); end;
%%
begin
	charCount := 0;
	wordCount := 0;
	lineCount := 0;

	Assign(srcFile, ParamStr(1));
	reset(srcFile);
  yyinput := srcFile;
  yylex();

  writeln(format('%d characters, %d words, %d lines', [charCount, wordCount, lineCount]));
end.