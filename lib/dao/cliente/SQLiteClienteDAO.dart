import 'package:sqflite/sqflite.dart';

import 'package:flutter_cadastro_cliente_v2/dao/SQLiteBDHelper.dart';
import 'package:flutter_cadastro_cliente_v2/dao/SQLiteDAOFactory.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/ClienteDAO.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/SQLiteClienteMetaDados.dart';
import 'package:flutter_cadastro_cliente_v2/entidade/Cliente.dart';

/**
 *  Implementação do DAO para cliente com SQLite.
 */
class SQLiteClienteDAO extends SQLiteDAOFactory implements ClienteDAO {
  //Instância do SQLiteBDHelper a ser utilizado no DAO
  SQLiteBDHelper dbHelper = new SQLiteBDHelper();

  // Como a chamada dos métodos podem demorar são especificados como Future

  /**
   *   Construtor (atributos privados não podem ser opcionais)
   */
  SQLiteClienteDAO() : super();

  /**
   * Retorna uma lista com os objetos segundo os critérios do filtro e ordem.
   *
   * @param filtros Lista dos campos a serem utilizados no filtro.
   * @param ordem   Ordem dos dados na consulta.
   * @return Lista com os objetos.
   */
  Future<List<Cliente>> select(List<String> filtros, String ordem) async {
    Database db = await dbHelper.getDatabase;
    String sql = 'SELECT ' +
        SQLiteClienteMetaDados.METADADOSSELECT +
        ' FROM ' +
        SQLiteClienteMetaDados.TABLE;
    //Adiciona o where se existir algum filtro
    if (filtros.length != 0) {
      sql = sql + ' WHERE ' + montaFiltro(filtros, 'and');
    }
    //Lista com os objetos clientes
    List<Cliente> lista = [];
    //Executa a consulta
    var cursor = await db.rawQuery(sql);
    //Percorre a consulta
    for (int i = 0; i < cursor.length; i++) {
      //Instancia o objeto cliente com os dados do registro
      Cliente cliente = new Cliente(
          cursor[i][SQLiteClienteMetaDados.colunaClienteId].toString(),
          cursor[i][SQLiteClienteMetaDados.colunaNome],
          cursor[i][SQLiteClienteMetaDados.colunaCPF]);
      //Adiciona o objeto a lista
      lista.add(cliente);
    }
    return lista;
  }

  /**
   * Insere um registro no banco de dados
   */
  Future<int> incluir(Cliente cliente) async {
    Database db = await dbHelper.getDatabase;
    return await db.insert(SQLiteClienteMetaDados.TABLE, cliente.getRow);
  }

  /**
   * Monta uma lista com os filtros para consulta de acordo como preenchimento dos atributos do objeto
   *
   * @param obj Objeto que possui os dados do filtro.
   * @return Uma lista com os dados do filtro.
   */
  Future<List<Cliente>> aplicarFiltro(Cliente cliente) async {
    if (cliente != null) {
      List<String> filtros = [];
      if (cliente.getClienteId != "") {
        filtros.add(SQLiteClienteMetaDados.TABLE +
            "." +
            SQLiteClienteMetaDados.colunaClienteId +
            " = '" +
            cliente.getClienteId.toString() +
            "'");
      }

      if (cliente.getNome != "") {
        filtros.add(SQLiteClienteMetaDados.TABLE +
            "." +
            SQLiteClienteMetaDados.colunaNome +
            " like '" +
            cliente.getNome +
            "'");
      }

      if (cliente.getCpf != "") {
        filtros.add(SQLiteClienteMetaDados.TABLE +
            "." +
            SQLiteClienteMetaDados.colunaCPF +
            " like '" +
            cliente.getCpf +
            "'");
      }
      return select(filtros, SQLiteClienteMetaDados.colunaClienteId);
    } else {
      return null;
    }
  }

  /**
   * Esse método usa uma consulta bruta para fornecer a contagem de registros.
   */
  Future<int> getNumeroRegistros() async {
    Database db = await dbHelper.getDatabase;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM ' + SQLiteClienteMetaDados.TABLE));
  }

  /**
   * Assumimos aqui que a coluna id no objeto está definida. Os outros
   * valores das colunas serão usados para atualizar a linha.
   */
  Future<int> alterar(Cliente cliente) async {
    Database db = await dbHelper.getDatabase;
    String id = cliente.getClienteId;
    return await db.update(SQLiteClienteMetaDados.TABLE, cliente.getRow,
        where: SQLiteClienteMetaDados.colunaClienteId + ' = ?',
        whereArgs: [id]);
  }

  /**
   *  Exclui a linha especificada pelo id. O número de registros afetadas
   *  retornada. Isso deve ser igual a 1, contanto que a linha exista.
   */
  Future<int> excluir(Cliente cliente) async {
    Database db = await dbHelper.getDatabase;
    String id = cliente.getClienteId;
    return await db.delete(SQLiteClienteMetaDados.TABLE,
        where: SQLiteClienteMetaDados.colunaClienteId + ' = ?',
        whereArgs: [id]);
  }
}
