import 'package:flutter/material.dart';
import '../widgets/mode_button.dart';

class AmortizationScreen extends StatelessWidget {
  const AmortizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Amortización")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                ModeButton(
                  text: 'Fijo',
                  type: 'fixed',
                  onPressed: (type) {
                    print('Se presiono el botón con el valor $type');
                  },
                ),
                ModeButton(text: 'Dinámico', type: 'Dynamic', onPressed: (type) {
                  print('Se presiono el botón $type');
                }),
                ModeButton(text: 'Mixto', type: 'Mixte', onPressed: (type){
                  print('Se presiono el botón $type');
                }),
              ],
            ),
          ],
        ),
      )
    );
  }
}