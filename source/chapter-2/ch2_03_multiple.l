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
		// Output summary for current file
		writeln(format('%d characters     %d words     %d lines     %s', [charCount, wordCount, lineCount, paramStr(currentFile)]));
	
		// If there's more than one file, reset and go again
		if currentFile < paramCount then begin
			// Reset counts
			charCount := 0;
			wordCount := 0;
			lineCount := 0;
			
			// Update currentFile to keep track of argument file position
			inc(currentFile);
			
			// Close the current file
			close(srcFile);
		  
		  // Assign next file and reset to place the cursor at the beginning
		  assign(srcFile, paramStr(currentFile));
		  reset(srcFile);

		  // Signal that we're not finished
		  result := false;
  	end else
  		// There were no more files so it's true that we're done
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
	// Set starting counts
	charCount := 0;
	wordCount := 0;
	lineCount := 0;
	currentFile := 1;

	// Assign and reset the first file
	assign(srcFile, ParamStr(1));
	reset(srcFile);

	// Set lexer input to be the file
  yyinput := srcFile;

  // Lex
  yylex();

  // Close the current file
  close(srcFile);
end.