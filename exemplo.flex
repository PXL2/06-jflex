// exemplo.flex

import java.io.FileReader;

%%

// --- Configurações do JFlex ---
%class Scanner
%public
%unicode // << 1. HABILITA SUPORTE A UNICODE (para 'ã', 'ç', etc.)
%line
%column
%eofval{
  System.out.println("\nFim da análise.");
  return null;
%eofval}

%{
  // Ponto de entrada (main) para testar o analisador
  public static void main(String[] args) {
    if (args.length == 0) {
        System.err.println("Uso: java Scanner <arquivo_de_entrada>");
        return;
    }
    try {
      Scanner scanner = new Scanner(new FileReader(args[0]));
      while (true) {
        Token token = scanner.yylex();
        if (token == null) {
          break;
        }
        System.out.println(" -> Encontrei um " + token);
      }
    } catch (Exception e) {
      System.err.println("Erro: " + e.getMessage());
    }
  }
%}

// --- Expressões Regulares (Definições) ---
// \p{L} -> Qualquer letra Unicode
// \p{N} ou \d -> Qualquer número Unicode
LETRA      = [\p{L}]
DIGITO_    = [\d]

// Regras mais específicas
DATA      = {DIGITO_}{2}\/{DIGITO_}{2}\/{DIGITO_}{4}
HORA      = {DIGITO_}{2}:{DIGITO_}{2}
TELEFONE  = {DIGITO_}{1,3}\+\s\({DIGITO_}{3}\)\s{DIGITO_}\s{DIGITO_}{4}-{DIGITO_}{4}
CPF       = {DIGITO_}{3}\.{DIGITO_}{3}\.{DIGITO_}{3}-{DIGITO_}{2}
// << 2. AJUSTE SUTIL: Garantir que o ponto/hífen não faça parte de um identificador
EMAIL     = [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
URL       = (https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})*(\/[^\s]*)?


// Regras mais gerais
IDENTIFICADOR = {LETRA}({LETRA}|{DIGITO_})*
DIGITO        = {DIGITO_}+

WHITESPACE = [ \t\r\n]+

%%
// --- Regras Léxicas e Ações ---
// **A ORDEM AQUI É FUNDAMENTAL**
{
  // 1. As regras mais específicas e longas devem vir primeiro
  {DATA}        { return new Token("DATA", yytext(), yyline, yycolumn); }
  {HORA}        { return new Token("HORA", yytext(), yyline, yycolumn); }
  {TELEFONE}    { return new Token("TELEFONE", yytext(), yyline, yycolumn); }
  {CPF}         { return new Token("CPF", yytext(), yyline, yycolumn); }
  {EMAIL}       { return new Token("EMAIL", yytext(), yyline, yycolumn); }
  {URL}         { return new Token("URL", yytext(), yyline, yycolumn); }

  // 2. As regras mais gerais e curtas vêm por último
  {IDENTIFICADOR} { return new Token("IDENTIFICADOR", yytext(), yyline, yycolumn); }
  {DIGITO}        { return new Token("DIGITO", yytext(), yyline, yycolumn); }

  // Ignora espaços em branco
  {WHITESPACE} { /* Não faz nada */ }

  // Caracteres não reconhecidos são marcados como ERRO
  [^]           { return new Token("ERRO", yytext(), yyline, yycolumn); }
}