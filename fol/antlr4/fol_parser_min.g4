// ================================================================
// ANTLR4 ПАРСЕР ДЛЯ ЯЗЫКА ТЕОРИЙ И АС минимальное оформление Менд и Барв. 
// КАНОНИЧЕСКАЯ ФОРМА ПРАВИЛ см. ???
// ================================================================
//DO
//+выделение +*-списков для правильного построения детей отца!!! это зависит от сем-кода!!! см. ниже комм для text == может оказаться не обязательным!!!
//заполнение эо - это лексика!!! +У:а ведь и ID хватит!
//WFC - куча?!! так в фиг-скобках не должно быть повторов!
parser grammar fol_parser_min;
options { tokenVocab = fol_lexer_min; }
text : ( decl | prop | as | query)+ EOF # textR; //+У:это правило должно быть последним но оно стартовое!!! ++У:стартовое правило пп указывается при вызове парсера!?!
// Вспомогательные конструкции
quantifier : (FORALL | EXISTS | EXISTS1) # Quant ; //скобки нужны чтобы метка приклеилась ко всей правлй части!
idplus	: ID+ 		# L_idpl ;
form_par : LPAREN idplus RPAREN 			# R_fp ;
type_f   : LPAREN idplus COLON ID RPAREN 	# R_tf ;
type_p   : LPAREN idplus RPAREN 			# R_tp ;
comma_id : ID (COMMA ID)* 					# Ls_ci ; //особый вид канон послед - с разделителем!
// ДЕКЛАРАЦИИ
decl : TYPE  comma_id PRIMARY DOT                       # TypeDecl
     | PRED  comma_id type_p  PRIMARY DOT    			# PredDeclP
     | PRED  ID type_p form_par DEF formula DOT    		# PredDeclD
     | FUNC  comma_id type_f PRIMARY DOT    			# FuncDeclP
     | FUNC  ID type_f form_par DEF formula DOT    		# FuncDeclD
     | CONST comma_id ID PRIMARY DOT  					# ConstDeclP
     | CONST ID ID DEF formula DOT  					# ConstDeclDf //ID-2 - тип для наглядности и должен совпадать и типом заданным формулой!
     | CONST ID ID DEF ID DOT  							# ConstDeclDId //!определение через сущ-ед: ID-3 - метка формулы сущ-ед!!! ID-2 - тип для наглядности и должен совпадать и типом заданным формулой!
     ;
// Термы
term : ID                         # VarOrConst
     | ID LPAREN trmpl RPAREN     # FuncApp
     ;
trmpl : term+ 	#L_trm ;
// Формулы. +У:formula нарушает ссылкум вперёд!!! !!!приоритет операций см. antrl4 гудок. 
formula :  ID 						  # Propos //утверждение может входить в формулу!!!
		|  term EQ term               # Equality
        |  term NEQ term              # Inequality
		|  NOT formula                # Negation
        |  formula AND formula        # Conjunction
        |  formula OR formula         # Disjunction
		|  formula IMPL formula  	  # Implication
        | LPAREN term EQ term RPAREN              # P_Equality //группа правил операций со скобками!
        | LPAREN term NEQ term RPAREN             # P_Inequality
		| LPAREN NOT formula RPAREN               # P_Negation
        | LPAREN formula AND formula RPAREN       # P_Conjunction
        | LPAREN formula OR formula RPAREN        # P_Disjunction
		| LPAREN formula IMPL formula RPAREN 	  # P_Implication
        | ID LPAREN trmpl RPAREN 	# PredApp //+У:это одинаково с FuncApp!!! различие - требование в ID!!! =пп объединить в одно правило call!!!
		| LPAREN quantifier comma_id COLON ID formula RPAREN  # withQuantifier
        ;
// Утверждение. proposition. Аксиомы, теоремы...
prop 	: ID formula DOT # R_prop;
// АС. +У:не написан ссылками вперёд!
as			: ID LABR setRelList RABR DOT # R_as ; 
setRelList 	: sr+ # L_sr;	
sr 			: set 	# setR
			| rel	# relR
			;
set 		: ID LCBR strList0 RCBR # R_set ; //тут может быть и пусто!!!
rel 		: ID LCBR nkList RCBR # R_rel ;
nkList 		: nk* # L_nk ;	
nk 			: LABR strList1 RABR # R_nk; //тут не может быть пусто! +У:пп можно допустить и пусто - проверка будет сем-прогой а не синтаксисом!
strList0 	: BASE_EL* # L_0str; 
strList1 	: BASE_EL+ # L_1str; 

//ЗАПРОС
query : QS ID ID QS # R_Q; //ид-1 - ид аксиомы, ид-2 - ид АС.
