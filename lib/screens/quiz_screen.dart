import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/gaveta.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _atual = 0;
  int _pontos = 0;
  bool _respondido = false;
  int? _selecionado;

  final List<Map<String, dynamic>> _perguntas = [
    {
      'pergunta': 'Em qual cidade fica a Cachoeira do Xixá?',
      'opcoes': ['Batalha', 'Teresina', 'Parnaíba', 'Floriano'],
      'correta': 0,
    },
    {
      'pergunta': 'Qual o estado onde fica Batalha?',
      'opcoes': ['Ceará', 'Maranhão', 'Piauí', 'Bahia'],
      'correta': 2,
    },
    {
      'pergunta': 'Qual o principal atrativo natural de Batalha?',
      'opcoes': ['Dunas', 'Cachoeiras', 'Geleiras', 'Vulcões'],
      'correta': 1,
    },
    {
      'pergunta':
          'Com qual cidade Batalha faz divisa onde fica a Cachoeira do Urubu?',
      'opcoes': ['Piripiri', 'Esperantina', 'Campo Maior', 'Barras'],
      'correta': 1,
    },
    {
      'pergunta':
          'O que caracteriza o local turístico Pedra Branca em Batalha?',
      'opcoes': [
        'Praias de areia fina',
        'Trilhas na serra',
        'Lagoas com águas cristalinas',
        'Cavernas e grutas',
      ],
      'correta': 2,
    },
  ];

  void _responder(int index) {
    if (_respondido) return;
    setState(() {
      _selecionado = index;
      _respondido = true;
      if (index == _perguntas[_atual]['correta']) _pontos++;
    });
  }

  Future<void> _salvarPontuacao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int pontuacaoAtual = prefs.getInt('pontuacao') ?? 0;
      await prefs.setInt('pontuacao', pontuacaoAtual + _pontos);
      debugPrint(
        'Pontuação guardada localmente! Total: ${pontuacaoAtual + _pontos}',
      );
    } catch (e) {
      debugPrint('Erro ao salvar pontuação localmente: $e');
    }
  }

  Future<void> _proxima() async {
    if (_atual < _perguntas.length - 1) {
      setState(() {
        _atual++;
        _respondido = false;
        _selecionado = null;
      });
    } else {
      await _salvarPontuacao();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Quiz finalizado!'),
          content: Text(
            'Você acertou $_pontos de ${_perguntas.length} perguntas.\n\nPontos guardados no seu perfil!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _atual = 0;
                  _pontos = 0;
                  _respondido = false;
                  _selecionado = null;
                });
              },
              child: const Text('Jogar novamente'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pergunta = _perguntas[_atual];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_atual + 1) / _perguntas.length,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              'Pergunta ${_atual + 1} de ${_perguntas.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              pergunta['pergunta'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(pergunta['opcoes'].length, (i) {
              Color cor = Colors.white;
              Icon? icone;

              if (_respondido) {
                if (i == pergunta['correta']) {
                  cor = Colors.green.shade100;
                  icone = const Icon(Icons.check_circle, color: Colors.green);
                } else if (i == _selecionado) {
                  cor = Colors.red.shade100;
                  icone = const Icon(Icons.cancel, color: Colors.red);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => _responder(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cor,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pergunta['opcoes'][i],
                          style: const TextStyle(fontSize: 16),
                        ),
                        ?icone,
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_respondido)
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _proxima,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _atual < _perguntas.length - 1
                        ? 'Próxima pergunta'
                        : 'Ver resultado',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
