
type pos = {
	pmin : int;
	pmax : int;
	pfile : string;
}

type constant =
	| True
	| False
	| Int of int
	| Float of string
	| String of string
	| Ident of string
	| Constr of string

type keyword =
	| Var
	| If
	| Else
	| Fun
	| Try
	| Catch

type token =
	| Eof
	| Semicolon
	| Dot
	| Comma
	| Arrow
	| BraceOpen
	| BraceClose
	| ParentOpen
	| ParentClose
	| BracketOpen
	| BracketClose
	| Const of constant
	| Keyword of keyword
	| Binop of string
	| Comment of string
	| CommentLine of string

type expr_decl =
	| EConst of constant
	| EBlock of expr list
	| EParenthesis of expr
	| EField of expr * string
	| ECall of expr * expr list
	| EArray of expr * expr	
	| EVars of (string * expr) list
	| EIf of expr * expr * expr option
	| EFunction of string list * expr
	| EBinop of string * expr * expr

and expr = expr_decl * pos

let pos = snd

let null_pos = { pmin = -1; pmax = -1; pfile = "<null pos>" }

let punion p p2 =
	{
		pfile = p.pfile;
		pmin = min p.pmin p2.pmin;
		pmax = max p.pmax p2.pmax;
	}

let escape s =
	let b = Buffer.create (String.length s) in
	for i = 0 to (String.length s) - 1 do
		match s.[i] with
		| '\n' -> Buffer.add_string b "\\n"
		| '\t' -> Buffer.add_string b "\\t"
		| '\r' -> Buffer.add_string b "\\r"
		| c -> Buffer.add_char b c
	done;
	Buffer.contents b

let s_constant = function
	| True -> "true"
	| False -> "false"
	| Int i -> string_of_int i
	| Float s -> s
	| String s -> "\"" ^ escape s ^ "\""
	| Ident s -> s
	| Constr s -> s

let s_keyword = function
	| Var -> "var"
	| If -> "if"
	| Else -> "else"
	| Fun -> "fun"
	| Try -> "try"
	| Catch -> "catch"

let s_token = function
	| Eof -> "<eof>"
	| Semicolon -> ";"
	| Dot -> "."
	| Comma -> ","
	| Arrow -> "=>"
	| BraceOpen -> "{"
	| BraceClose -> "}"
	| ParentOpen -> "("
	| ParentClose -> ")"
	| BracketOpen -> "["
	| BracketClose -> "]"
	| Const c -> s_constant c
	| Keyword k -> s_keyword k
	| Binop s -> s
	| Comment s -> "/*" ^ s ^ "*/"
	| CommentLine s -> "//" ^ s
