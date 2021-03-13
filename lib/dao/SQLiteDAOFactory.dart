import 'package:flutter_cadastro_cliente_v2/dao/DAOFactory.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/ClienteDAO.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/SQLiteClienteDAO.dart';

/**
 * Fábrica do banco SQLite.
 */
class SQLiteDAOFactory extends DAOFactory {
  /**
   * Retorna uma Cliente DAO.
   *
   * @return ClienteDAO Um DAO para cliente.
   */
  @override
  ClienteDAO getClienteDAO() {
    return new SQLiteClienteDAO();
  }

  /**
   * Monta a string do filtro.
   *
   * @param lista     Lista dos campos do filtro.
   * @param separador Separador os dados do filtro.
   * @return Retorna uma string com os dados do filtro.
   */
  String montaFiltro(List<String> lista, String separador) {
    String filtro = "";
    var filtroIt = lista.iterator;
    while (filtroIt.moveNext()) {
      String texto = filtroIt.current;
      filtro = filtro + texto;
      if (filtroIt.moveNext()) {
        filtro = filtro + " " + separador + " ";
      }
    }
    return filtro;
  }
}
