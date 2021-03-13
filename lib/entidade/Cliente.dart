import 'package:flutter_cadastro_cliente_v2/dao/DAOFactory.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/ClienteDAO.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/SQLiteClienteMetaDados.dart';

/**
 * Classe do Modelo a ser persistido no banco de dados
 */
class Cliente {
  // Atributos
  String _clienteId;
  String _nome;
  String _cpf;

  /**
   *  Construtor com parâmetros
   */
  Cliente(this._clienteId, this._nome, this._cpf);

  // Getter e Setter do clienteId
  String get getClienteId {
    return _clienteId;
  }

  set setClienteId(String clienteId) {
    this._clienteId = clienteId;
  }

  // Getter e Setter do nome
  String get getNome {
    return _nome;
  }

  set setNome(String nome) {
    this._nome = nome;
  }

  // Getter e Setter do cpf
  String get getCpf {
    return _cpf;
  }

  set setCpf(String cpf) {
    this._cpf = cpf;
  }

  /**
   * No Map row é especificado o nome da coluna e o valor da coluna.
   */
  Map<String, dynamic> get getRow {
    Map<String, dynamic> linha = {
      SQLiteClienteMetaDados.colunaClienteId: getClienteId,
      SQLiteClienteMetaDados.colunaNome: getNome,
      SQLiteClienteMetaDados.colunaCPF: getCpf
    };
    return linha;
  }

  /**
   * Converte um Map row para um objeto cliente
   */
  factory Cliente.fromMap(Map<String, dynamic> linha) => new Cliente(
      linha[SQLiteClienteMetaDados.colunaClienteId],
      linha[SQLiteClienteMetaDados.colunaNome],
      linha[SQLiteClienteMetaDados.colunaCPF]);

  /**
   * Retorna uma string com o estado do objeto.
   */
  @override
  String paraString() {
    return "clienteId :${this.getClienteId} - Nome :${this.getNome} - CPF :${this.getCpf}]";
  }

  /**
   * Restaura o estado do objeto apartir do id.
   */
  Future<bool> abrir() async {
    final ClienteDAO clientedao = DAOFactory.getDAOFactory().getClienteDAO();
    List<Cliente> lista = await clientedao.aplicarFiltro(this);
    if (lista.isNotEmpty) {
      Cliente oCliente = lista.first;
      setNome = oCliente.getNome;
      setCpf = oCliente.getCpf;
      return true;
    } else {
      return false;
    }
  }
}
