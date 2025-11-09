
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_expressions/math_expressions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkTheme') ?? false;
  runApp(MyApp(initialDark: isDark));
}

class MyApp extends StatefulWidget {
  final bool initialDark;
  MyApp({required this.initialDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.initialDark;
  }

  void _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
    setState(() {
      _isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorPage(
        isDark: _isDark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  CalculatorPage({required this.isDark, required this.onThemeChanged});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';

  final List<String> buttons = [
    'AC', '⌫', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '±', '0', '.', '=',
  ];

  bool _isOperator(String s) {
    return s == '+' || s == '-' || s == '×' || s == '÷' || s == '%';
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '0';
        return;
      }

      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        return;
      }

      if (value == '±') {
        if (_expression.isEmpty) {
          _expression = '-';
          return;
        }
        int i = _expression.length - 1;
        while (i >= 0 && !_isOperator(_expression[i])) i--;
        String last = _expression.substring(i + 1);
        if (last.startsWith('-')) {
          _expression = _expression.substring(0, i + 1) + last.substring(1);
        } else {
          _expression = _expression.substring(0, i + 1) + '-' + last;
        }
        return;
      }

      if (value == '=') {
        _calculateResult();
        return;
      }

      if (_expression.isEmpty && _isOperator(value)) {
        if (value != '-') return;
      }

      if (_expression.isNotEmpty && _isOperator(value) && _isOperator(_expression[_expression.length - 1])) {
        _expression = _expression.substring(0, _expression.length - 1) + value;
        return;
      }

      if (value == '.') {
        int i = _expression.length - 1;
        while (i >= 0 && !_isOperator(_expression[i])) i--;
        String last = _expression.substring(i + 1);
        if (last.contains('.')) return;
      }

      _expression += value;
    });
  }

  void _calculateResult() {
    if (_expression.isEmpty) return;

    try {
      String exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression parsed = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = parsed.evaluate(EvaluationType.REAL, cm);
      String formatted;
      if (eval % 1 == 0) {
        formatted = eval.toInt().toString();
      } else {
        formatted = eval.toString();
      }
      setState(() {
        _result = formatted;
        _expression = formatted;
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String text, {double flex = 1}) {
    final bool isOp = _isOperator(text) || text == '=' || text == 'AC' || text == '⌫' || text == '±' || text == '%';
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            backgroundColor: isOp ? null : null,
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          Row(
            children: [
              Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
              Switch(
                value: widget.isDark,
                onChanged: widget.onThemeChanged,
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _expression.isEmpty ? '0' : _expression,
                        style: TextStyle(fontSize: 32),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _result,
                      style: TextStyle(fontSize: 28, color: theme.colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Row 1
                    Row(children: [
                      _buildButton('AC'),
                      _buildButton('⌫'),
                      _buildButton('%'),
                      _buildButton('÷'),
                    ]),
                    // Row 2
                    Row(children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('×'),
                    ]),
                    // Row 3
                    Row(children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-'),
                    ]),
                    // Row 4
                    Row(children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+'),
                    ]),
                    // Row 5
                    Row(children: [
                      _buildButton('±'),
                      _buildButton('0', flex: 2),
                      _buildButton('.'),
                      _buildButton('='),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



