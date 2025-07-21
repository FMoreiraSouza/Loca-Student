import 'package:flutter/material.dart';
import 'package:loca_student/ui/about/widgets/info_card_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Image.asset('content/app_logo.png', height: 200),
            const SizedBox(height: 16),

            const InfoCard(
              icon: Icons.home_work_outlined,
              title: 'Encontre sua república',
              description: 'Pesquise por cidade e veja todos os detalhes antes de reservar.',
            ),
            const SizedBox(height: 16),
            const InfoCard(
              icon: Icons.check_circle_outline,
              title: 'Gerencie reservas',
              description: 'Visualize reservas pendentes ou aceitas e cancele quando necessário.',
            ),
            const SizedBox(height: 32),
            Text(
              _version.isEmpty ? 'Carregando versão' : 'Versão $_version',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Desenvolvido para estudantes',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
