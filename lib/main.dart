import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_cadastro_cliente_v2/dao/DAOFactory.dart';
import 'package:flutter_cadastro_cliente_v2/dao/SQLiteBDHelper.dart';
import 'package:flutter_cadastro_cliente_v2/dao/cliente/ClienteDAO.dart';
import 'package:flutter_cadastro_cliente_v2/entidade/Cliente.dart';

//Programa principal
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // Este widget é a raiz do aplicativo.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cadastro de Cliente v2',
      theme: new ThemeData(
        // Este é o tema do aplicativo.
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MinhaHomePage(),
    );
  }
}

// Este widget é a página inicial do seu aplicativo.
class MinhaHomePage extends StatefulWidget {
  MinhaHomePage({Key key}) : super(key: key);

  @override
  _MinhaHomePageState createState() => new _MinhaHomePageState();
}

class _MinhaHomePageState extends State<MinhaHomePage> {
  // Referência a fábrica e o dao para cliente
  final ClienteDAO clientedao = DAOFactory.getDAOFactory().getClienteDAO();

  //Mensagem com a quantidade de registros
  String mensagemRegistros = "Registros: 0";

  //Mensagem com os dados da tabela
  String mensagemDados = "";

  //Chave do formulário
  GlobalKey<FormState> chaveFormulario = GlobalKey<FormState>();

  //Controler das caixas de texto do formulário
  TextEditingController clienteIdController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  //Foco para o campo do clienteId
  FocusNode clienteIdFocus = new FocusNode();

  /**
   * Construtor
   */
  @override
  void initState() {
    super.initState();
    limparClick();
    atualizarRegistros();
  }

  /**
   * Destrutor
   */
  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    //Barra do aplicativo
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Cadastro de Cliente v2'),
      ),
      //Corpo do aplicativo
      body: Container(
        child: Builder(
            builder: (context) => Form(
                  //Chave do formulário
                  key: chaveFormulario,
                  //Campos do formulário
                  //Coluna dos campos de entrada
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      "ClienteId",
                                      style: new TextStyle(
                                          fontSize: 14.0, fontFamily: "Roboto"),
                                    ),
                                    SizedBox(
                                        width: 75,
                                        height: 25,
                                        child: new TextFormField(
                                            focusNode: clienteIdFocus,
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: "Roboto"),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            // somente números podem ser digitados
                                            //Validação da entrada
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Insira o clienteId!";
                                              }
                                            },
                                            controller: clienteIdController)),
                                    new Text(
                                      "Nome Cliente",
                                      style: new TextStyle(
                                          fontSize: 14.0, fontFamily: "Roboto"),
                                    ),
                                    SizedBox(
                                        width: 200,
                                        height: 30,
                                        child: new TextFormField(
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: "Roboto"),
                                            //Validação da entrada
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Insira o nome do cliente!";
                                              }
                                            },
                                            controller: nomeController)),
                                    new Text(
                                      "CPF Cliente",
                                      style: new TextStyle(
                                          fontSize: 14.0, fontFamily: "Roboto"),
                                    ),
                                    SizedBox(
                                        width: 150,
                                        height: 30,
                                        child: new TextFormField(
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: "Roboto"),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            // somente números podem ser digitados
                                            //Validação da entrada
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Insira o cpf do cliente!";
                                              }
                                            },
                                            controller: cpfController)),
                                    new Text(
                                      mensagemRegistros,
                                      style: new TextStyle(
                                          fontSize: 14.0, fontFamily: "Roboto"),
                                    ),
                                  ]),

                              //Coluna dos botões
                              new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: incluirClick,
                                        child: new Text(
                                          "INCLUIR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: alterarClick,
                                        child: new Text(
                                          "ALTERAR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: excluirClick,
                                        child: new Text(
                                          "EXCLUIR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: consultarClick,
                                        child: new Text(
                                          "CONSULTAR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: listarClick,
                                        child: new Text(
                                          "LISTAR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: esvaziarBDClick,
                                        child: new Text(
                                          "ESVAZIAR BD",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: limparClick,
                                        child: new Text(
                                          "LIMPAR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                    new ElevatedButton(
                                        key: null,
                                        onPressed: () {
                                          fecharClick();
                                        },
                                        child: new Text(
                                          "FECHAR",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Roboto"),
                                        )),
                                  ]),
                            ]),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Lista dos dados:",
                                style: new TextStyle(
                                    fontSize: 14.0, fontFamily: "Roboto"),
                              )
                            ]),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                mensagemDados,
                                style: new TextStyle(
                                    fontSize: 14.0, fontFamily: "Roboto"),
                              )
                            ]),
                      ]),
                )),
      ),
    );
  }

  /**
   * Atualizar registros em tela
   */
  void atualizarRegistros() async {
    final qtde = await clientedao.getNumeroRegistros();
    setState(() {
      mensagemRegistros = "Registros: ${qtde.toString()}";
    });
  }

  /**
   * Evento do botão incluir
   */
  void incluirClick() async {
    if (chaveFormulario.currentState.validate()) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente = new Cliente(
          clienteIdController.text, nomeController.text, cpfController.text);
      //Executa a inclusão
      var resultado = await clientedao.incluir(cliente);
      if (resultado != 0) {
        Fluttertoast.showToast(
            msg: "Inclusão realizada com sucesso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        atualizarRegistros();
      } else {
        Fluttertoast.showToast(
            msg: "Inclusão não realizada!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    }
  }

  /**
   * Evento do botão alterar
   */
  void alterarClick() async {
    //Verifica se o clienteId foi preenchido
    if (clienteIdController.text.isNotEmpty) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente = new Cliente(clienteIdController.text, "", "");
      bool resultadoConsulta = await cliente.abrir();
      if (resultadoConsulta == true) {
        // Cliente para alterar
        cliente.setNome = nomeController.text;
        cliente.setCpf = cpfController.text;
        final resultadoAlteracao = await clientedao.alterar(cliente);
        if (resultadoAlteracao != 0) {
          Fluttertoast.showToast(
              msg: "Alteração realizada com sucesso!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        } else {
          Fluttertoast.showToast(
              msg: "Alteração não realizada!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Cliente não encontrado, digite um clienteId válido!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Digite um clienteId!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      clienteIdFocus.requestFocus();
    }
  }

  /**
   * Diálogo de saída da aplicação
   */
  showAlertDialogExcluir(BuildContext context) {
    // set up the buttons
    Widget botaoSim = TextButton(
      onPressed: () {
        //Ação para a resposta sim
        Navigator.of(context).pop(); // fecha a caixa de diálogo
        excluirRegistro();
      },
      child: Text("Sim"),
    );

    Widget botaoNao = TextButton(
      onPressed: () {
        //Ação para a resposta não
        Navigator.of(context).pop(); // fecha a caixa de diálogo
        //Não faz nada
      },
      child: Text("Não"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Excluir cliente"),
      content: Text("Desejar excluir o registro?"),
      actions: [
        botaoSim,
        botaoNao,
      ],
    );

    // Mostra a caixa de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /**
   * Método que excluir o registro do cliente
   */
  void excluirRegistro() async {
    //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
    Cliente cliente = new Cliente(clienteIdController.text, "", "");
    final resultadoExclusao = await clientedao.excluir(cliente);
    if (resultadoExclusao != 0) {
      Fluttertoast.showToast(
          msg: "Exclusão realizada com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
      atualizarRegistros();
    } else {
      Fluttertoast.showToast(
          msg: "Exclusão não realizada!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2);
    }
  }

  /**
   * Evento do botão excluir
   */
  void excluirClick() async {
    //Verifica se o clienteId foi preenchido
    if (clienteIdController.text.isNotEmpty) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente = new Cliente(clienteIdController.text, "", "");
      //Procura o cliente
      bool resultadoConsulta = await cliente.abrir();
      //Se encontrar chama o diálogo
      if (resultadoConsulta == true) {
        //Chama o diálogo para confirmar a exclusão
        showAlertDialogExcluir(context);
      } else {
        Fluttertoast.showToast(
            msg: "Cliente não encontrado, digite um clienteId válido!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Digite um clienteId!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      clienteIdFocus.requestFocus();
    }
  }

  /**
   * Evento do botão consultar
   */
  void consultarClick() async {
    //Verifica se o clienteId foi preenchido
    if (clienteIdController.text.isNotEmpty) {
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      //Instancia o objeto Cliente e preenche os atributos do objeto com os dados da interface
      Cliente cliente = new Cliente(clienteIdController.text, "", "");
      bool resultadoConsulta = await cliente.abrir();
      if (resultadoConsulta == true) {
        nomeController.text = cliente.getNome;
        cpfController.text = cliente.getCpf;
        Fluttertoast.showToast(
            msg: "Cliente encontrado!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(
            msg: "Cliente não encontrado!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Digite um clienteId!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
    clienteIdFocus.requestFocus();
  }

  /**
   * Evento do botão listar
   */
  void listarClick() async {
    //Instancia o objeto Cliente
    Cliente cliente = new Cliente("", "", "");
    //Recupera a lista de todos os clientes aplicando o fitro sem atribuir nenhum valor ao objeto
    List<Cliente> lista = await clientedao.aplicarFiltro(cliente);
    //Cabeçalho da listagem
    String saida = "clienteId - nome - cpf\n";
    //Percorre a lista recuperando os dados do objeto
    for (int i = 0; i < lista.length; i++) {
      //Recupera o cliente i da lista
      Cliente cli = lista[i];
      saida = saida +
          cli.getClienteId +
          "-" +
          cli.getNome +
          "-" +
          cli.getCpf +
          "\n";
    }
    //Exibe a saida
    setState(() {
      mensagemDados = "${saida}";
    });
  }

  /**
   * Diálogo de confirmação para esvaziar o BD da aplicação
   */
  showAlertDialogEsvaziarBD(BuildContext context) {
    // set up the buttons
    Widget botaoSim = TextButton(
      onPressed: () {
        //Ação para a resposta sim
        Navigator.of(context).pop(); // fecha a caixa de diálogo
        SQLiteBDHelper dbHelper = new SQLiteBDHelper();
        dbHelper.apagarBancoDados(); //Apaga a tabela
        Fluttertoast.showToast(
            msg: "Tabela Apagada!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
        atualizarRegistros(); //Atualiza os registro em tela
      },
      child: Text("Sim"),
    );

    Widget botaoNao = TextButton(
      onPressed: () {
        //Ação para a resposta não
        Navigator.of(context).pop(); // fecha a caixa de diálogo
        //Não faz nada
      },
      child: Text("Não"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Esvaziar BD"),
      content: Text("Deseja esvaziar a tabela Cliente?"),
      actions: [
        botaoSim,
        botaoNao,
      ],
    );

    // Mostra a caixa de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /**
   * Evento do botão esvaziar BD
   */
  void esvaziarBDClick() async {
    //Confirma a exclusão dos dados da tabela
    showAlertDialogEsvaziarBD(context);
  }

  /**
   * Evento do botão limpar
   */
  void limparClick() {
    //Limpa as caixas de texto
    clienteIdController.text = '';
    nomeController.text = '';
    cpfController.text = '';
    setState(() {
      chaveFormulario = GlobalKey<FormState>();
      //Limpa a listagem dos dados
      mensagemDados = "";
    });
    atualizarRegistros();
  }

  /**
   * Diálogo de saída da aplicação
   */
  showAlertDialogSair(BuildContext context) {
    // set up the buttons
    Widget botaoSim = TextButton(
      onPressed: () {
        //Ação para a resposta sim
        SystemNavigator.pop();
      },
      child: Text("Sim"),
    );

    Widget botaoNao = TextButton(
      onPressed: () {
        //Ação para a resposta não
        Navigator.of(context).pop(); // fecha a caixa de diálogo
      },
      child: Text("Não"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Fechar aplicativo"),
      content: Text("Você tem certeza que deseja sair?"),
      actions: [
        botaoSim,
        botaoNao,
      ],
    );

    // Mostra a caixa de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /**
   * Evento do botão fechar
   */
  void fecharClick() {
    //Chamada a caixa de diálogo para confirmar a saída
    showAlertDialogSair(context);
  }
}
