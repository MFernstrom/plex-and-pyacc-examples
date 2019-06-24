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
^[ \t]*"/*".*"*/"[ \t]*\n			inc(comments);
<COMMENT>"*/"[ \t]*\n					begin start(0); inc(comments); end;
<COMMENT>"*/"									start(0);
<COMMENT>\n										inc(comments);

^[ \t]*\n											inc(whiteSpace);

.+"/*".*"*/".*\n							inc(code);
.+"/*".*"*/".+\n							inc(code);
.+"/*".*\n										begin inc(code); start(COMMENT) end;
.\n														inc(code);

.															{Do nothing};
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