import 'package:flutter/material.dart';
import '../widgets/stat_chip.dart';
import '../widgets/quest_tile.dart';

class LayoutQuestPage extends StatefulWidget {
  const LayoutQuestPage({super.key});

  @override
  State<LayoutQuestPage> createState() => _LayoutQuestPageState();
}

class _LayoutQuestPageState extends State<LayoutQuestPage> {
  String log = 'Siap memulai quest!';
  int hp = 80;
  int mp = 120;
  int gold = 140;

  final quests = const [
    ('Kalahkan 3 Goblin', 'Reward: +20 gold'),
    ('Ambil 2 Potion', 'Reward: +10 MP'),
    ('Latihan di arena', 'Reward: +10 HP'),
  ];

  void startQuest() {
    setState(() {
      gold += 10;
      hp = (hp - 5).clamp(0, 999);
      log = '⚔️ Quest dimulai! Kamu dapat +10 gold, -5 HP';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quest started!')),
    );
  }
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Quest'),
        backgroundColor: cs.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderCard(
              name: 'Rani',
              role: 'Mage Apprentice',
              badgeText: 'LEVEL 3',
            ),
            const SizedBox(height: 12),

            // WRAP: bagus untuk item yang bisa pindah baris di layar sempit
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatChip(icon: Icons.favorite, label: 'HP', value: hp.toString(), color: Colors.red),
                StatChip(icon: Icons.auto_awesome, label: 'MP', value: mp.toString(), color: Colors.blue),
                StatChip(icon: Icons.paid, label: 'Gold', value: gold.toString(), color: Colors.amber),
              ],
            ),

            const SizedBox(height: 12),

            Text('Today\'s Quests', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // Expanded: biar list mengisi sisa ruang dan tidak overflow
            Expanded(
              child: ListView.separated(
                itemCount: quests.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final (title, subtitle) = quests[i];
                  return QuestTile(
                    title: title,
                    subtitle: subtitle,
                    onTap: () => setState(() => log = '📌 Dipilih: $title'),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Tombol aksi
            ElevatedButton.icon(
              onPressed: startQuest,
              icon: const Icon(Icons.flag),
              label: const Text('Start Quest'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 10),

            // Log output
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withAlpha(20)),
              ),
              child: Text(log),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String name;
  final String role;
  final String badgeText;

  const _HeaderCard({
    required this.name,
    required this.role,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primaryContainer, cs.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // STACK: avatar + badge
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: cs.primary,
                child: Text(
                  name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(191),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // EXPANDED: biar teks mengambil sisa ruang
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(role, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),

          Icon(Icons.chevron_right, color: cs.onPrimaryContainer),
        ],
      ),
    );
  }
}