import 'package:flutter_cadastro_cliente_v2/dao/SQLiteDAOFactory.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/ClienteDAO.dart';

/**
 * Abstrai as fontes de dados do sistema.
 */
abstract class DAOFactory {
  //Retorna a Factory do tipo especificado
  static DAOFactory getDAOFactory() {
    return new SQLiteDAOFactory();
  }

  //Retorna o DAO instanciado
  ClienteDAO getClienteDAO();

//Outros DAOs vão aqui!!!!
}
