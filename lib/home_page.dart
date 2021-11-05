import 'dart:convert';
import 'package:app_localidades/cep.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  Cep? _cep;
  List<Cep> _ceps = [];
  bool isCepSearch = true;

  Future<Cep?> _getLocalByCep(String cepTyped) async {
    try {
      http.Response response = await http.get(Uri.parse('https://viacep.com.br/ws/$cepTyped/json/'));
      Cep cep = Cep.fromJson(response.body);
      return cep;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<Cep>> _getLocalsByAddress(String uf, String cidade, String logradouro) async {
    List<Cep> ceps = [];
    
    try {
      http.Response response = await http.get(Uri.parse('https://viacep.com.br/ws/${uf.toUpperCase()}/$cidade/$logradouro/json/'));
      List<dynamic> decodedList = json.decode(response.body);
      
      for (Map<String, dynamic> cepDecoded in decodedList) {
        Cep cep = Cep.fromMap(cepDecoded);
        ceps.add(cep);
      }
      
      return ceps;
    }  catch (error) {
      print(error);
      return [];
    }
  }

  Future<void> _onChangeCep(String value) async {
    if(value.length == 8){
      Cep? cep = await _getLocalByCep(value);
      setState(() => _cep = cep);
    }              
  }

  Future<void> _searchLocal() async {
    List<Cep> ceps = await _getLocalsByAddress(_ufController.text, _cidadeController.text, _logradouroController.text);     
    setState(() => _ceps = ceps);
  }
  
  void _onTapCep(){
    setState(() => isCepSearch = !isCepSearch);
    Navigator.of(context).pop();
  }

  void _onTapAddress(){
    setState(() => isCepSearch = !isCepSearch);
    Navigator.of(context).pop();
  }

  Widget _titleWidget(String title){
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w500
      ),
    );
  }

  Widget _infoAddress(String fieldName, String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
        Text(value),
      ],
    );
  }

  Widget _listAddress(){
    return Expanded(
      child: SingleChildScrollView(
        child: _fields(_cep!)
      )
    );
  }

  Widget _fields(Cep cep){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _infoAddress("Cep", cep.cep.toString()),
        const Divider(),
        _infoAddress("Logradouro", cep.logradouro.toString()),
        const Divider(),
        _infoAddress("Complemento", cep.complemento.toString()),
        const Divider(),
        _infoAddress("Bairro", cep.bairro.toString()),
        const Divider(),
        _infoAddress("Localidade", cep.localidade.toString()),
        const Divider(),
        _infoAddress("UF", cep.uf.toString()),
        const Divider(),
        _infoAddress("IBGE", cep.ibge.toString()),
        const Divider(),
        _infoAddress("GIA", cep.gia.toString()),
        const Divider(),
        _infoAddress("DDD", cep.ddd.toString()),
        const Divider(),
        _infoAddress("SIAFI", cep.siafi.toString())
      ]
    );
      
  }

  Widget _serachByCEP(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleWidget("Consulta por CEP"),
          const SizedBox(height: 32),
          TextField(
            controller: _cepController,
            onChanged: _onChangeCep,
            decoration:  const InputDecoration(
              hintText: "Digite um cep",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))
              )   
            )
          ),
          const SizedBox(height: 32),
          _cep != null ?_listAddress() : Container()
        ],
      ),
    );
  }

  Widget _searchByAddress(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleWidget("Consulta por endereço"),
          const SizedBox(height: 32),
          TextField(
            controller: _ufController,
            decoration:  const InputDecoration(
              hintText: "Digite a UF do estado",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))
              )   
            )
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _cidadeController,
            decoration:  const InputDecoration(
              hintText: "Digite o nome da cidade",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))
              )   
            )
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _logradouroController,
            decoration:  const InputDecoration(
              hintText: "Digite o logradouro",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))
              )   
            )
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green
            ),
            onPressed: _searchLocal, 
            child: const Text("Buscar")
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: _ceps.length,
              itemBuilder: (context, index){
                return _fields(_ceps[index]);
              },
              separatorBuilder: (context, index){
                return const Divider(height: 64, thickness: 5, color: Colors.grey);
              }
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Localidades"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  title: const Text("Consulta por cep"),
                  subtitle: const Text("consulta de dados com a API do Via Cep"),
                  onTap: _onTapCep,
                ),
                const Divider(),
                ListTile(
                  title: const Text("Consulta por endereço"),
                  subtitle: const Text("consulta de endereço com a API do Via Cep"),
                  onTap: _onTapAddress,
                )
              ],
            ),
          ),
        ),
      ),
      body: isCepSearch ? _serachByCEP() : _searchByAddress()
    );
  }
}