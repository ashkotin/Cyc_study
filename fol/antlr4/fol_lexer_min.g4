// ================================================================
// ЛЕКСЕР ДЛЯ ЯЗЫКА ТЕОРИЙ, АС и запросов (ANTLR4)
// ================================================================

lexer grammar fol_lexer_min;

// ---------- КЛЮЧЕВЫЕ СЛОВА ----------

TYPE    : 'type' ;
PRED    : 'pred' ;
FUNC    : 'func' ;
CONST   : 'const' ;
PRIMARY : 'primary' ;

// ---------- ОПЕРАТОРЫ И СИМВОЛЫ ----------

DEF     : '≝' ;
DOT     : '.' ;
LPAREN  : '(' ;
RPAREN  : ')' ;
COLON   : ':' ;
EQ      : '=' ;
NEQ     : '≠' ;
NOT     : '¬' ;
AND     : '∧' ;
OR      : '∨' ;
IMPL    : '→' ;
FORALL  : '∀' ;
EXISTS  : '∃' ;
EXISTS1 : '∃!' ;
LABR    : '<' ;
RABR    : '>' ;
LCBR	: '{' ;
RCBR	: '}' ;
DQM		: '"' ;
QS		: '?' ;
COMMA	: ',' ;

// ---------- ИДЕНТИФИКАТОРЫ ----------

ID : Letter (Letter | Digit | '_' | '-')* ;

fragment Letter : 
    'A'..'Z' 
  | 'a'..'z' 
  | '\u00C0'..'\u00D6' 
  | '\u00D8'..'\u00F6' 
  | '\u00F8'..'\u02FF' 
  | '\u0370'..'\u037D' 
  | '\u037F'..'\u1FFF' 
  | '\u200C'..'\u200D' 
  | '\u2070'..'\u218F' 
  | '\u2C00'..'\u2FEF' 
  | '\u3001'..'\uD7FF' 
  | '\uF900'..'\uFDCF' 
  | '\uFDF0'..'\uFFFD'
  ;

fragment Digit : '0'..'9' ;

// ---------- ЭО  ---------- 
BASE_EL : DQM (Letter | Digit | '_' | '-')* DQM ; //для эо должно хватить! base element

// ---------- ПРОБЕЛЫ И КОММЕНТАРИИ ----------

WS : [ \t\r\n]+ -> skip ;

LINE_COMMENT : '--' ~[\r\n]* -> skip ;
