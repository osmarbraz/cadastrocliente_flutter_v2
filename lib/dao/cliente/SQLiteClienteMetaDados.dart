/**
 * Armazena os metadados para a implementação da tabela cliente.
 */
class SQLiteClienteMetaDados {
  /**
   * String com o nome da tabela usada no banco
   */
  static final TABLE = 'CLIENTE';

  /**
   * Strings com as colunas da tabela
   */
  static final colunaClienteId = 'CLIENTEID';
  static final colunaNome = 'NOME';
  static final colunaCPF = 'CPF';

  /**
   * Retorna uma string com os campos para serem utilizados com select
   */
  static String METADADOSSELECT = TABLE +
      "." +
      colunaClienteId +
      ", " +
      TABLE +
      "." +
      colunaNome +
      ", " +
      TABLE +
      "." +
      colunaCPF;

  /**
   * String de criação da tabela cliente
   */
  static final METADADOSCREATE = 'CREATE TABLE ' +
      TABLE +
      ' ( ' +
      colunaClienteId +
      ' INTEGER PRIMARY KEY, ' +
      colunaNome +
      ' varchar(100) NOT NULL, ' +
      colunaCPF +
      ' varchar(11) ' +
      ')';
}
