import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> items = const [
    {
      "title": "Noticias",
      "description": "Mantente al día con la actualidad mundial.",
      "imageUrl": "https://picsum.photos/200/110",
    },
    {
      "title": "Deportes",
      "description": "Resultados y análisis de los partidos.",
      "imageUrl": "https://picsum.photos/200/111",
    },
    {
      "title": "Ciencia",
      "description": "Descubrimientos e investigaciones recientes.",
      "imageUrl": "https://picsum.photos/200/112",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantalla con Tabs"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Noticias"),
            Tab(text: "Deportes"),
            Tab(text: "Ciencia"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(0),
          _buildTabContent(1),
          _buildTabContent(2),
        ],
      ),
    );
  }

  Widget _buildTabContent(int index) {
    final item = items[index];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoCard(
        title: item['title']!,
        description: item['description']!,
        imageUrl: item['imageUrl'],
      ),
    );
  }
}
