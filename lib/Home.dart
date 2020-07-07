import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];

  Future<File> _obterArquivo() async {

    final diretorio = await getApplicationDocumentsDirectory();
    return File( '${diretorio.path}/dados.json' );
  }

  _salvarArquivo() async {

    var arquivo = await _obterArquivo();

    //criar dados na _listaTarefas
    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = 'Ir ao mercado';
    tarefa['realizada'] = 'false';
    _listaTarefas.add( tarefa );

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
    //print('caminho : ' + diretorio.path );
  }

  _lerArquivo() async {

    try{
      final arquivo = await _obterArquivo();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext contexto) {

    //_salvarArquivo();

    print('itens: ' + _listaTarefas.toString());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          //floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            elevation: 20,
            //icon: Icon(Icons.add_shopping_cart),
            //label: Text('Adicionar'),
            //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Icon(Icons.add),
            onPressed: (){
              showDialog(
                context: contexto,
                builder: (contexto){
                  return AlertDialog(
                    title: Text('Adicionar Tarefa'),
                    content: TextField(decoration: InputDecoration(labelText: 'Digite sua Tarefa'),
                    onChanged: (texto){
                    },),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar'),
                      ),
                      FlatButton(
                        onPressed: (){

                          Navigator.pop(context);

                        },
                        child: Text('Salvar'),
                      ),
                      
                    ],
                  );
                }
              );
              print('pressionado');
            }
        ),

      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemBuilder: (contexto, indice){
                  return ListTile(
                    title: Text(_listaTarefas[indice]['titulo']),
                  );
                },
                itemCount: _listaTarefas.length
              )
          ),
        ],
      )
    );
  }
}
