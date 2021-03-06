/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%
%unicode

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

	private boolean flag = false;
    private int curr_lineno = 1;
    int get_curr_lineno() {
    	if(flag){
    		flag=false;
    		return (curr_lineno-1);
    	}
		return curr_lineno;
    }
    // Definisco nuova variabile per tenere conto del numero di parentesi aperte
    private int numeroParentesi = 0;

    private AbstractSymbol filename;

    void set_filename(String fname) {
		filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
		return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

//Come da manuale, definisco i casi di errore quando trovo un EOF nel mezzo di un commento o di una stringa
    switch(zzLexicalState) {
    case YYINITIAL:
		/* nothing special to do in the initial state */
		break;
	case COMMENT:
		yybegin(YYINITIAL);
		return new Symbol(TokenConstants.ERROR, "EOF in comment");
	case STRING:
		if (string_buf.length()>=MAX_STR_CONST){
			yybegin(YYINITIAL);
			return new Symbol(TokenConstants.ERROR, "String constant too long");}
		yybegin(DUMP);
		return new Symbol(TokenConstants.ERROR, "EOF in string constant");
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

//Definisco due nuovi stati: Commento e Stringa
%class CoolLexer
%state COMMENT
%state STRING
%state DUMP
%cup
%line

//Definisco tutte le parole chiave del linguaggio come specificato nel manuale di cool
LineEndTags = \n|\r\n
IdObj = [a-z][a-zA-Z0-9_]*
IdType = [A-Z][a-zA-Z0-9_]*
Number = [0-9]+
WhiteSpacesTags = {LineEndTags}|[ \t\f\v]|\r
TRUE = t[rR][uU][eE]
FALSE = f[aA][lL][sS][eE]
SELF = self
IF = [iI][fF]
FI = [fF][iI]
THEN = [tT][hH][eE][nN]
ELSE = [eE][lL][sS][eE]
INHERITS = [iI][nN][hH][eE][rR][iI][tT][sS]
LOOP = [lL][oO][oO][pP]
POOL = [pP][oO][oO][lL]
CASE = [cC][aA][sS][eE]
ESAC = [eE][sS][aA][cC]
NOT = [nN][oO][tT]
IN = [iI][nN]
WHILE = [wW][hH][iI][lL][eE]
NEW = [nN][eE][wW]
CLASS = [cC][lL][aA][sS][sS]
LET = [lL][eE][tT]
OF = [oO][fF]
ISVOID = [iI][sS][vV][oO][iI][dD]
FOR = [Ff][Oo][Rr]
ROF = [Rr][Oo][Ff]

%%
//Per ogni simbolo riconosciuto, definisco le operazioni da eseguire
<YYINITIAL> {
	"=>"						{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  return new Symbol(TokenConstants.DARROW); }
	"(*" 			{ yybegin(COMMENT); numeroParentesi=1; }
	"--".*{LineEndTags} 		{ curr_lineno++;}
	"\"" 			{ yybegin(STRING); string_buf=new StringBuffer();}
	"\n" 			{ curr_lineno++; }
	"*)"			{ yybegin(YYINITIAL);
					return new Symbol(TokenConstants.ERROR,"Unmatched *)");}
/* OPERATOR */
	"="			{return new Symbol(TokenConstants.EQ);}
	"+"			{ return new Symbol(TokenConstants.PLUS);}
	"-"			{ return new Symbol(TokenConstants.MINUS);}
	"*"			{ return new Symbol(TokenConstants.MULT);}
	"/"			{ return new Symbol(TokenConstants.DIV);}
	"<"			{ return new Symbol(TokenConstants.LT);}
	"<="			{ return new Symbol(TokenConstants.LE);}
	"not"			{ return new Symbol(TokenConstants.NOT);}
	"in"			{ return new Symbol(TokenConstants.IN);}
	"<-"			{ return new Symbol(TokenConstants.ASSIGN);}
	"~"			{ return new Symbol(TokenConstants.NEG);}
	"@"			{ return new Symbol(TokenConstants.AT);}
/*PARENTHESIS*/
 	"("		{  return new Symbol(TokenConstants.LPAREN);}
 	")"		{  return new Symbol(TokenConstants.RPAREN);}
 	"{"		{  return new Symbol(TokenConstants.LBRACE);}
 	"}"		{  return new Symbol(TokenConstants.RBRACE);}
 
 /*PUNCTUATION*/
	 "."		{  return new Symbol(TokenConstants.DOT);}
 	","		{  return new Symbol(TokenConstants.COMMA);}
 	";"		{  return new Symbol(TokenConstants.SEMI);}
 	":"		{  return new Symbol(TokenConstants.COLON);}
/* RESTO */
	{FOR}		{ return new Symbol(TokenConstants.LET_STMT); }
	{ROF}		{ return new Symbol(TokenConstants.POOL); }
	{SELF}	 		{ return new Symbol(TokenConstants.OBJECTID,AbstractTable.idtable.addString("self"));}
	{ELSE}						{return new Symbol(TokenConstants.ELSE);}
	{WHILE}						{return new Symbol(TokenConstants.WHILE);}
	{ESAC}						{return new Symbol(TokenConstants.ESAC);}
	{LET}						{return new Symbol(TokenConstants.LET);}
	{THEN}						{return new Symbol(TokenConstants.THEN);}
	{CLASS}						{return new Symbol(TokenConstants.CLASS);}
	{NOT}						{return new Symbol(TokenConstants.NOT);}
	{IN}						{return new Symbol(TokenConstants.IN);}
	{FI}						{return new Symbol(TokenConstants.FI);}
	{LOOP}						{return new Symbol(TokenConstants.LOOP);}
	{IF}						{return new Symbol(TokenConstants.IF);}
	{OF}						{return new Symbol(TokenConstants.OF);}
	{NEW}						{return new Symbol(TokenConstants.NEW);}
	{ISVOID}					{return new Symbol(TokenConstants.ISVOID);}
	{POOL}						{return new Symbol(TokenConstants.POOL);}
	{CASE}						{return new Symbol(TokenConstants.CASE);}
	{INHERITS}					{return new Symbol(TokenConstants.INHERITS);}
	{TRUE}						{return new Symbol(TokenConstants.BOOL_CONST,"true");}
	{FALSE} 					{return new Symbol(TokenConstants.BOOL_CONST,"false");}
	{Number}					{return new Symbol(TokenConstants.INT_CONST,
										AbstractTable.inttable.addString(yytext()));}
	{IdObj}						{return new Symbol(TokenConstants.OBJECTID,
										AbstractTable.idtable.addString(yytext()));}
	{IdType}					{return new Symbol(TokenConstants.TYPEID,
										AbstractTable.idtable.addString(yytext()));}
	\r\n						{curr_lineno++;}
	{WhiteSpacesTags}			{}
	.							{return new Symbol(TokenConstants.ERROR,yytext());} /*Quest'ultimo controllo segnala come errore qualsiasi input che non viene riconosciuto dalle altre regole */
	
}
//In questo stato l'unica cosa di rilievo è il conteggio delle parentesi
<COMMENT>{
	"(*"						{numeroParentesi++;}
	"*)"						{if(--numeroParentesi == 0){yybegin(YYINITIAL);}}/*Se il numero di parentesi riconosciute è pari, si ritorna nello stato iniziale*/
	\n							{curr_lineno++;}
	.							{}
}

<STRING>{	
	\"				{	
					yybegin(YYINITIAL);
					if (string_buf.length()>=MAX_STR_CONST){
						return new Symbol(TokenConstants.ERROR, "String constant too long");}
						
									return new Symbol(TokenConstants.STR_CONST,
									AbstractTable.stringtable.addString(string_buf.toString()));
								} /*Questa regola verifica se la stringa letta ha lunghezza maggiore della massima accettata, e in tal caso restituisce errore. Altrimenti restituisce la stringa letta in input*/
	\0							{
									yybegin(DUMP);
									if (string_buf.length()>=MAX_STR_CONST)
										return new Symbol(TokenConstants.ERROR, "String constant too long");
									return new Symbol(TokenConstants.ERROR, "String contains null character.");
								}/*Questa regola restituisce errore quando incontra il carattere di fine stringa*/
	\n				{
									curr_lineno++;
									yybegin(YYINITIAL);
									
									if (string_buf.length()>=MAX_STR_CONST){
										flag = true;
										return new Symbol(TokenConstants.ERROR, "String constant too long"); }
									return new Symbol(TokenConstants.ERROR, "Unterminated string constant");
								}/*Questa regola restituisce errore nel caso in cui vi sia nella stringa un ritorno a capo definito in modo errato*/
	
	\\n							{	string_buf.append('\n'); }					
	
	\\t							{string_buf.append('\t'); }
	\\b							{if (string_buf.length()>=MAX_STR_CONST){
									yybegin(YYINITIAL);
										return new Symbol(TokenConstants.ERROR, "String constant too long");}	string_buf.append('\b'); }
	\\f							{if (string_buf.length()>=MAX_STR_CONST){
									yybegin(YYINITIAL);
										return new Symbol(TokenConstants.ERROR, "String constant too long");}	string_buf.append('\f'); }
	\\0							{if (string_buf.length()>=MAX_STR_CONST){
									yybegin(DUMP);
										return new Symbol(TokenConstants.ERROR, "String constant too long");}
							string_buf.append('0');	 }
									
	\\\0						{
									yybegin(DUMP);
									return new Symbol(TokenConstants.ERROR, "String contains escaped null character.");
								}
	\\\\						{	string_buf.append('\\'); }
	\\\"						{	string_buf.append('\"'); }
	\\\n						{ if (string_buf.length()>=MAX_STR_CONST){
									yybegin(YYINITIAL);
										return new Symbol(TokenConstants.ERROR, "String constant too long");}  curr_lineno++; string_buf.append('\n');}
	[ \f\t\v]					{ 	string_buf.append(yytext()); }
	\\							{}
	[^\n\r\"\\\0]+					{string_buf.append(yytext()); }
	\r							{}		
	
	
}

<DUMP>{
	\"							{	yybegin(YYINITIAL);	}
	\n				{
									yybegin(YYINITIAL);
									curr_lineno++;
								}
	 
	 .							{}
}

/* Questo ultimo controllo risulta superfluo perchè il lexer riesce a catturare e a segnalare con un errore qualsiasi tipo di input. Siccome questo controllo era presente all'inizio, l'ho lasciato invariato
*/
	.                           { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }


