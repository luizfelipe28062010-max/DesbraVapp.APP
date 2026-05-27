import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/gaveta.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final supabase = Supabase.instance.client;
  int? _scoreGlobal;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarScore();
  }

  Future<void> _carregarScore() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final response = await supabase.from('score').select('pontos');

      final total = (response as List).fold<int>(
        0,
        (soma, item) => soma + ((item['pontos'] as num?)?.toInt() ?? 0),
      );

      setState(() {
        _scoreGlobal = total;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar: $e';
        _carregando = false;
      });
    }
  }

  String _formatarNumero(int n) {
    // Formata com ponto como separador de milhar: 2995 → 2.995
    final s = n.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F5F0),
        elevation: 0,
        title: const Text(
          'Ranking Global',
          style: TextStyle(
            color: Color(0xFF1A3A2A),
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A3A2A)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _carregarScore,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _carregarScore,
        color: const Color(0xFF2D6A4F),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            // Título e subtítulo
            const Text(
              'Pontos Atuais',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A3A2A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Veja o score acumulado por todos os jogadores até agora.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF5A7A6A),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Card principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDDEDD8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _carregando
                  ? const Column(
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF2D6A4F),
                          strokeWidth: 2.5,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Carregando...',
                          style: TextStyle(
                            color: Color(0xFF5A7A6A),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : _erro != null
                      ? Column(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Color(0xFFB00020), size: 40),
                            const SizedBox(height: 12),
                            Text(
                              _erro!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color(0xFFB00020), fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _carregarScore,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Text(
                              'SCORE GLOBAL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.5,
                                color: Color(0xFF2D6A4F),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _formatarNumero(_scoreGlobal ?? 0),
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A3A2A),
                                letterSpacing: -1,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Atualizado agora mesmo.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A7A6A),
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}