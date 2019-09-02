import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heigthController = TextEditingController();
  String _result;
  Color _resultColor = Colors.black;

  bool _sexoMasculino = true;
  bool _sexoFeminino = false;

  /// Função para tratar a seleção do switch do sexo masculino
  void _onSexoMasculinoChanged(bool value) => setState(() {
        _sexoMasculino = value;
        _sexoFeminino = !value; // marca o inverso no feminino
      });

  /// Função para tratar a seleção do switch do sexo feminino
  void _onSexoFemininoChanged(bool value) => setState(() {
        _sexoFeminino = value;
        _sexoMasculino = !value; // marca o inverso no masculino
      });

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heigthController.text = '';
    setState(() {
      _result = 'Informe seus dados';
      _sexoMasculino = true;
      _sexoFeminino = false;
      _resultColor = Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso (kg)",
              error: "Insira seu peso!",
              controller: _weightController),
          buildTextFormField(
              label: "Altura (cm)",
              error: "Insira uma altura!",
              controller: _heigthController),
          // 1. Adicionar botões (Toggle ou Radio button)
          // para escolha de gênero (masculino / feminino):
          buildGenderLabel(),
          buildSwitch("Masculino", _sexoMasculino, _onSexoMasculinoChanged),
          buildSwitch("Feminino", _sexoFeminino, _onSexoFemininoChanged),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  void calculateImc() {
    double weight = double.parse(_weightController.text);
    double heigth = double.parse(_heigthController.text) / 100.0;

    // 4. Refatorar o código do aplicativo para utilizar a classe Pessoa:
    Pessoa pessoa = new Pessoa(weight, heigth, _sexoFeminino);
    pessoa.calculateImc();
    setState(() {
      _result = pessoa.classify();
      // 5. Aplicar uma escala de cores para o resultado da classificação do IMC:
      _resultColor = pessoa._scaleColor;
    });
  }

  Widget buildGenderLabel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Text(
        "Sexo:",
        textAlign: TextAlign.left,
      ),
    );
  }

  /// Função que cria um switch com uma label, uma variável para o valor
  /// (se está selecionado ou não) e uma função para quando marcar o switch
  Widget buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return new SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: new Text(label),
    );
  }

  Widget buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            calculateImc();
          }
        },
        child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
        // 6. Aumentar o texto do resultado do IMC (número) e também colocar em negrito:
        style: TextStyle(
          fontWeight: FontWeight.bold, // negrito
          fontSize: 22, // tamanho do texto
          color: _resultColor,
        ),
      ),
    );
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}

/// 3. Criar um classe Pessoa com os atributos (peso, altura e gênero),
/// criar métodos para calcular IMC e classificar:
class Pessoa {
  double _weight;
  double _heigth;
  double _imc;
  bool _isFemale;
  Color _scaleColor;

  Pessoa(double weight, double heigth, bool isFemale) {
    _weight = weight;
    _heigth = heigth;
    _isFemale = isFemale;
  }

  double calculateImc() {
    _imc = _weight / (_heigth * _heigth);
    return _imc;
  }

  String classify() {
    String result;
    result = "IMC = ${_imc.toStringAsPrecision(2)}\n";
    // 2. Corrigir o calculo de acordo com o gênero (masculino e feminino);
    if (_isFemale) {
      if (_imc < 19.1) {
        result += "Abaixo do peso";
        _scaleColor = Colors.blue;
      } else if (_imc < 25.9) {
        result += "Peso ideal";
        _scaleColor = Colors.green;
      } else if (_imc < 27.4) {
        result += "Pouco acima do peso";
        _scaleColor = Colors.yellow;
      } else if (_imc < 32.4) {
        result += "Acima do peso";
        _scaleColor = Colors.orange;
      } else {
        result += "Obesidade";
        _scaleColor = Colors.red;
      }
    } else {
      if (_imc < 20.7) {
        result += "Abaixo do peso";
        _scaleColor = Colors.blue;
      } else if (_imc < 26.5) {
        result += "Peso ideal";
        _scaleColor = Colors.green;
      } else if (_imc < 27.9) {
        result += "Pouco acima do peso";
        _scaleColor = Colors.yellow;
      } else if (_imc < 31.2) {
        result += "Acima do peso";
        _scaleColor = Colors.orange;
      } else {
        result += "Obesidade";
        _scaleColor = Colors.red;
      }
    }
    return result;
  }
}
