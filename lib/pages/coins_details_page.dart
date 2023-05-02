import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/coin.dart';
import 'package:intl/intl.dart';

class CoinsDetailsPage extends StatefulWidget {
  final Coin coin;

  const CoinsDetailsPage({super.key, required this.coin});

  @override
  State<CoinsDetailsPage> createState() => _CoinsDetailsPageState();
}

class _CoinsDetailsPageState extends State<CoinsDetailsPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double quantity = 0;

  buyCoin() {
    if (_form.currentState!.validate()) {
      // Save buy
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra realizada com sucesso!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(widget.coin.icon),
                  ),
                  Container(width: 10),
                  Text(
                    real.format(widget.coin.price),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      color:
                          (widget.coin.price > 100) ? Colors.blue : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            (quantity > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity ${widget.coin.alias}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 24),
                  ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _value,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  labelStyle: TextStyle(fontSize: 30, color: Colors.black),
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'reais',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'Compra mínima deve ser ao menos R\$ 50,00';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantity = (value.isEmpty)
                        ? 0
                        : double.parse(value) / widget.coin.price;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: buyCoin,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comprar',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
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
