import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/gaveta.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final supabase = Supabase.instance.client;
  final _nomeController = TextEditingController();
  String? _fotoPath;
  int _pontuacao = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _nomeController.text = prefs.getString('nome') ?? '';
        _fotoPath = prefs.getString('foto_path');
        _pontuacao = prefs.getInt('pontuacao') ?? 0;
      });
    } catch (e) {
      debugPrint('Erro ao carregar perfil: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _salvarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', _nomeController.text);
    if (_fotoPath != null) await prefs.setString('foto_path', _fotoPath!);

    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil salvo!')));
  }

  // ATUALIZADO: Envia estritamente os campos numéricos int que o teu banco possui
  Future<void> _enviarParaSupabase() async {
    if (_pontuacao == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você não tem pontos acumulados para enviar!'),
        ),
      );
      return;
    }

    try {
      await supabase.from('score').insert({
        'pontos': _pontuacao,
        'pontuacao': _pontuacao,
      });

      // Zera a pontuação localmente no aparelho após enviar com sucesso
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pontuacao', 0);

      setState(() {
        _pontuacao = 0;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pontuação enviada para o ranking com sucesso!'),
        ),
      );
    } catch (e) {
      debugPrint('Erro ao enviar para o Supabase: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar pontuação!')),
      );
    }
  }

  Future<void> _escolherFoto() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem == null) return;
    setState(() => _fotoPath = imagem.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      drawer: const AppDrawer(),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _escolherFoto,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _fotoPath != null
                          ? FileImage(File(_fotoPath!))
                          : null,
                      child: _fotoPath == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toque para trocar a foto',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Seu nome',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Pontuação no Quiz',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_pontuacao pts',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.leaderboard),
                    label: const Text('Enviar pontuação para o ranking'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _enviarParaSupabase,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar perfil'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _salvarPerfil,
                  ),
                ],
              ),
            ),
    );
  }
}
