import 'package:flutter_cadastro_cliente_v2/entidade/Cliente.dart';

/**
 * Classe abstrata dos métodos do DAO para cliente
 */
abstract class ClienteDAO {
  // Como a chamada dos métodos podem demorar são especificados como Future

  Future<int> incluir(Cliente cliente);

  Future<int> alterar(Cliente cliente);

  Future<int> excluir(Cliente cliente);

  Future<List<Cliente>> aplicarFiltro(Cliente cliente);

  Future<int> getNumeroRegistros();
}
