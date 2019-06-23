%{
  {
  	Plex-only wordcount, multiple file arguments
  }
  program wordcounter;

  {$mode objfpc}

  uses sysutils, yacclib, lexlib;

  var
  	charCount, wordCount, lineCount, currentFile: Integer;
  	srcFile: TextFile;

 	function yywrap():Boolean;
	begin
		if currentFile < paramCount then begin
			inc(currentFile);
			Close(srcFile);
		  Assign(srcFile, paramStr(currentFile));
		  reset(srcFile);
		  result := false;
  	end else
  		result := true;
	end;
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
	currentFile := 1;

	Assign(srcFile, ParamStr(1));
	reset(srcFile);
  yyinput := srcFile;
  yylex();

  writeln(format('%d characters, %d words, %d lines', [charCount, wordCount, lineCount]));
end.