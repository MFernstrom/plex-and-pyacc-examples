%{
  {
  	C Source code analyzer
  }
  program source_code_analyzer;

  {$mode objfpc}

  uses sysutils, lexlib;

  var
  	comments, whiteSpace, code: Integer;
  	srcFile: TextFile;

%}

%s COMMENT

%%

^[ \t]*"/*"										begin start(COMMENT) end;
^[ \t]*"/*".*"*/"[ \t]*\n			begin inc(comments); end;
<COMMENT>"*/"[ \t]*\n					begin start(0); inc(comments); end;
<COMMENT>"*/"									begin start(0); end;
<COMMENT>\n										begin inc(comments); end;

^[ \t]*\n											begin inc(whiteSpace) end;

.+"/*".*"*/".*\n							begin inc(code); end;
.+"/*".*"*/".+\n							begin inc(code); end;
.+"/*".*\n										begin inc(code); start(COMMENT) end;
.\n														begin inc(code); end;

.															begin { Anything else } end;
%%

begin
	// Set starting counts
	comments := 0;
	code := 0;
	whiteSpace := 0;

	// Assign and reset the first file
	assign(srcFile, ParamStr(1));
	reset(srcFile);	

	// Set lexer input to be the file
  yyinput := srcFile;

  // Lex
  yylex();

  writeln(format('Comments: %d, Whitespace: %d, Code: %d', [comments, whiteSpace, code]));
end.