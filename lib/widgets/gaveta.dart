import 'package:flutter/material.dart';
import '../screens/locais_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/contato_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/ranking.screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Locais Turísticos'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LocaisScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quiz'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contate-nos'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ContatoScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PerfilScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Ranking'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RankingScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
