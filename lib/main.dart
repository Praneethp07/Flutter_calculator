import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SimpleCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String expression = "";
  String result = "0";
  double resultFont = 48.0;
  double equationFont = 38.0;
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'c') {
        equation = "0";
        result = "0";
      } else if (buttonText == '=') {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        try {
          Parser p = Parser();
          Expression ex = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${ex.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "error";
        }
        equation = "";
      } else if (buttonText == '⌫') {
        equation = equation.substring(0, equation.length - 1);
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation += buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      padding: EdgeInsets.all(3),
      height: MediaQuery.of(context).size.height * .1 * buttonHeight,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(10)),
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
      ),
      body: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text(
            equation,
            style: TextStyle(
              fontSize: equationFont,
            ),
          ),
          // color: Colors.red,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Text(
            result,
            style: TextStyle(
              fontSize: resultFont,
            ),
          ),
          // color: Colors.blue,
        ),
        const Expanded(
          child: Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .75,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("c", 1, Colors.red),
                    buildButton("-", 1, Colors.blue),
                    buildButton("+", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("1", 1, Colors.grey.shade400),
                    buildButton("2", 1, Colors.grey.shade400),
                    buildButton("3", 1, Colors.grey.shade400),
                  ]),
                  TableRow(children: [
                    buildButton("4", 1, Colors.grey.shade400),
                    buildButton("5", 1, Colors.grey.shade400),
                    buildButton("6", 1, Colors.grey.shade400),
                  ]),
                  TableRow(children: [
                    buildButton("7", 1, Colors.grey.shade400),
                    buildButton("8", 1, Colors.grey.shade400),
                    buildButton("9", 1, Colors.grey.shade400),
                  ]),
                  TableRow(children: [
                    buildButton("00", 1, Colors.grey.shade800),
                    buildButton("0", 1, Colors.grey.shade400),
                    buildButton(".", 1, Colors.grey.shade800),
                  ]),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .25,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("⌫", 1, Colors.red),
                  ]),
                  TableRow(children: [
                    buildButton("÷", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("×", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("=", 2, Colors.red),
                  ]),
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
