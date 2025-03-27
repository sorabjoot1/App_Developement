import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '0';

  void onButtonClick(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '0';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  Widget buildButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonClick(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: color,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Calculator"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.bottomRight,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: TextStyle(fontSize: 30, color: Colors.black87)),
                  SizedBox(height: 10),
                  Text(result, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                buildRow(['7', '8', '9', '÷'], Colors.blue, Colors.orange),
                buildRow(['4', '5', '6', '×'], Colors.blue, Colors.orange),
                buildRow(['1', '2', '3', '-'], Colors.blue, Colors.orange),
                buildRow(['C', '0', '=', '+'], Colors.red, Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<String> buttons, Color numColor, Color opColor) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) {
          Color color = (btn == '÷' || btn == '×' || btn == '-' || btn == '+') ? opColor : numColor;
          return buildButton(btn, color);
        }).toList(),
      ),
    );
  }
}
