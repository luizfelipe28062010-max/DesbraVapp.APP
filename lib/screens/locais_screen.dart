import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/gaveta.dart';

class LocaisScreen extends StatelessWidget {
  const LocaisScreen({super.key});

  Future<void> _abrirMaps(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locais = [
      {
        'nome': 'Cachoeira do Xixá',
        'descricao': 'Uma das cachoeiras mais belas do Piauí, com locais de banho diversos e vegetação nativa ao redor. Perfeita para banho e contato com a natureza.',
        'url': 'https://maps.app.goo.gl/Sz3ur7GxxyzHwFth9',
      },
      {
        'nome': 'Cachoeira do Urubu',
        'descricao': 'Nossa cachoeira mais exubrante na divisa com Esperantinacom aguas torrenciais intensas e diversos locais de Banho e pesca',
        'url': 'https://maps.app.goo.gl/y2Nz1QDXnQUMaqob9',
      },
      {
        'nome': 'Pedra Branca',
        'descricao': 'Diversas lagoas com trilhas ecológicas e águas cristalinas. Um paraíso para os amantes do ecoturismo.',
        'url': 'https://maps.app.goo.gl/J5Cv2r6TmzNDhEJ78',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Locais Turísticos')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locais.length,
        itemBuilder: (context, index) {
          final local = locais[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(local['nome']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(local['descricao']!,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.directions),
                    label: const Text('Como chegar'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44)),
                    onPressed: () => _abrirMaps(local['url']!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}