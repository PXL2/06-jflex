// Token.java

public class Token {
    private String tipo;
    private String lexema;
    private int linha;
    private int coluna;

    public Token(String tipo, String lexema, int linha, int coluna) {
        this.tipo = tipo;
        this.lexema = lexema;
        this.linha = linha;
        this.coluna = coluna;
    }

    // O método toString() formata a saída como você deseja
    @Override
    public String toString() {
        return "<Token: " + tipo +
               ", Lexema: " + lexema +
               ", Tamanho: " + lexema.length() +
               ", Linha: " + linha +
               ", Coluna: " + coluna + ">";
    }
}