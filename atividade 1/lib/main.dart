import 'dart:math';
import 'package:flutter/material.dart';

void main() {
runApp(const SorteadorApp());
}

class SorteadorApp extends StatelessWidget {
const SorteadorApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Sorteador de Decisões',
theme: ThemeData(
useMaterial3: true,
),
home: const SorteadorPage(),
);
}
}

class SorteadorPage extends StatefulWidget {
const SorteadorPage({super.key});

@override
State<SorteadorPage> createState() => _SorteadorPageState();
}

class _SorteadorPageState extends State<SorteadorPage> {
final TextEditingController _opcaoController = TextEditingController();

final List<String> _opcoes = [];

String? _erroTexto;

final Color _roxo = const Color(0xFF6C4AB6);
final Color _roxoMedio = const Color(0xFFE8DFFF);
final Color _roxoClaro = const Color(0xFFF4F0FA);
final Color _verde = const Color(0xFF4CAF50);
final Color _vermelho = const Color(0xFFE53935);
final Color _cinza = const Color(0xFF777777);

void _adicionarOpcao() {
final texto = _opcaoController.text.trim();

if (texto.isEmpty) {
setState(() {
_erroTexto = 'Digite uma opção';
});
return;
}

if (_opcoes.contains(texto)) {
setState(() {
_erroTexto = 'Essa opção já foi adicionada';
});
return;
}

setState(() {
_opcoes.add(texto);
_opcaoController.clear();
_erroTexto = null;
});
}

void _removerOpcao(int index) {
setState(() {
_opcoes.removeAt(index);
});
}

void _sortear() {
if (_opcoes.length < 2) {
return;
}

final random = Random();
final resultado = _opcoes[random.nextInt(_opcoes.length)];

_mostrarResultado(resultado);
}

void _mostrarResultado(String resultado) {
showDialog(
context: context,
barrierDismissible: true,
builder: (BuildContext dialogContext) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(24),
),
backgroundColor: Colors.white,
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
const SizedBox(height: 8),

Container(
width: 80,
height: 80,
decoration: BoxDecoration(
color: _roxoMedio,
shape: BoxShape.circle,
),
child: const Center(
child: Text(
'🎉',
style: TextStyle(fontSize: 40),
),
),
),

const SizedBox(height: 16),

Text(
'A decisão foi tomada!',
style: TextStyle(
fontSize: 14,
color: _cinza,
),
textAlign: TextAlign.center,
),

const SizedBox(height: 8),

Text(
resultado,
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: _roxo,
),
textAlign: TextAlign.center,
),

const SizedBox(height: 8),
],
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(dialogContext);

Future.delayed(
const Duration(milliseconds: 200),
_sortear,
);
},
child: Text(
'Sortear novamente',
style: TextStyle(color: _cinza),
),
),

ElevatedButton(
onPressed: () => Navigator.pop(dialogContext),
style: ElevatedButton.styleFrom(
backgroundColor: _roxo,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: const Text('Ótimo!'),
),
],
);
},
);
}

void _limparTudo() {
showDialog(
context: context,
builder: (ctx) => AlertDialog(
title: const Text('Limpar lista?'),
content: const Text(
'Todas as opções serão removidas.',
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(ctx),
child: const Text('Cancelar'),
),
ElevatedButton(
onPressed: () {
setState(() {
_opcoes.clear();
});

Navigator.pop(ctx);
},
style: ElevatedButton.styleFrom(
backgroundColor: _vermelho,
foregroundColor: Colors.white,
),
child: const Text('Limpar'),
),
],
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: _roxoClaro,

appBar: AppBar(
title: const Text(
'Sorteador de Decisões 🎲',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
backgroundColor: _roxo,
foregroundColor: Colors.white,

actions: [
if (_opcoes.isNotEmpty)
IconButton(
icon: const Icon(Icons.delete_sweep),
tooltip: 'Limpar tudo',
onPressed: _limparTudo,
),

Padding(
padding: const EdgeInsets.only(right: 12),
child: Center(
child: Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 4,
),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.25),
borderRadius: BorderRadius.circular(20),
),
child: Text(
'${_opcoes.length} opções',
style: const TextStyle(
color: Colors.white,
fontSize: 13,
),
),
),
),
),
],
),

body: SingleChildScrollView(
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 16,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
ClipRRect(
borderRadius: BorderRadius.circular(24),
child: Image.network(
'https://picsum.photos/seed/dice/600/300',
height: 160,
fit: BoxFit.cover,
errorBuilder: (_, __, ___) {
return Container(
height: 160,
color: _roxoMedio,
child: const Center(
child: Text(
'🎲',
style: TextStyle(fontSize: 64),
),
),
);
},
),
),

const SizedBox(height: 20),

TextField(
controller: _opcaoController,
onChanged: (_) {
setState(() {
_erroTexto = null;
});
},
onSubmitted: (_) => _adicionarOpcao(),
style: const TextStyle(fontSize: 16),

decoration: InputDecoration(
hintText: 'Ex: Pizza, Sushi, Hambúrguer...',
hintStyle: const TextStyle(
color: Color(0xFFBBBBBB),
),
labelText: 'Nova opção',
prefixIcon: Icon(
Icons.add_circle_outline,
color: _roxo,
),

suffixIcon:
_opcaoController.text.isNotEmpty
? IconButton(
icon: Icon(
Icons.clear,
color: _cinza,
),
onPressed: () {
setState(() {
_opcaoController.clear();
_erroTexto = null;
});
},
)
    : null,

errorText: _erroTexto,

filled: true,
fillColor: Colors.white,

enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
color: _erroTexto != null
? _vermelho
    : const Color(0xFFDDDDDD),
width: 1.5,
),
),

focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
color: _roxo,
width: 2,
),
),

errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
color: _vermelho,
width: 1.5,
),
),
),
),

const SizedBox(height: 12),

ElevatedButton.icon(
onPressed: _adicionarOpcao,
icon: const Icon(Icons.add),
label: const Text(
'Adicionar opção',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
),
),
style: ElevatedButton.styleFrom(
backgroundColor: _verde,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(
vertical: 14,
),
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
),

const SizedBox(height: 20),

if (_opcoes.isEmpty)
Container(
height: 90,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: const Color(0xFFEEEEEE),
),
),
child: const Center(
child: Text(
'Nenhuma opção adicionada ainda',
style: TextStyle(
color: Color(0xFFAAAAAA),
fontSize: 14,
),
),
),
)
else
ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: _opcoes.length,
itemBuilder: (context, index) {
return Container(
margin: const EdgeInsets.only(bottom: 8),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: const Color(0xFFEEEEEE),
),
),
child: ListTile(
leading: CircleAvatar(
backgroundColor: _roxoMedio,
child: Text(
'${index + 1}',
style: TextStyle(
color: _roxo,
fontWeight: FontWeight.bold,
),
),
),

title: Text(
_opcoes[index],
style: const TextStyle(
fontSize: 15,
),
),

trailing: IconButton(
icon: Icon(
Icons.delete_outline,
color: _vermelho,
),
onPressed: () {
_removerOpcao(index);
},
),
),
);
},
),

const SizedBox(height: 24),

ElevatedButton.icon(
onPressed: _opcoes.length >= 2
? _sortear
    : null,
icon: const Icon(
Icons.shuffle,
size: 22,
),
label: Text(
_opcoes.length < 2
? 'Adicione ${2 - _opcoes.length} opção(ões)'
    : 'SORTEAR',
style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
letterSpacing: 1,
),
),
style: ElevatedButton.styleFrom(
backgroundColor: _roxo,
foregroundColor: Colors.white,
disabledBackgroundColor:
const Color(0xFFBBBBBB),
disabledForegroundColor: Colors.white,
padding: const EdgeInsets.symmetric(
vertical: 18,
),
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
),
),

const SizedBox(height: 24),
],
),
),
);
}

@override
void dispose() {
_opcaoController.dispose();
super.dispose();
}
}

