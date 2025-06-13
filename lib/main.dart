import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_main.dart';
import 'screens/dataset/dataset_list.dart';
import 'screens/evaluation/evaluation_list.dart';
import 'screens/model/model_list.dart';
import 'screens/leaderboard/leaderboard_list.dart';
import 'screens/metric/metric_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLM 평가 도구',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    DashboardScreen(),
    DatasetListScreen(),
    EvaluationListScreen(),
    ModelListScreen(),
    LeaderboardListScreen(),
    MetricListScreen(),
  ];

  static const List<String> _labels = [
    '대시보드',
    '데이터셋',
    '평가',
    '모델',
    '리더보드',
    '지표',
  ];

  static const List<IconData> _icons = [
    Icons.dashboard,
    Icons.dataset,
    Icons.assessment,
    Icons.model_training,
    Icons.emoji_events,
    Icons.bar_chart,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                'LLM 평가 도구',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.account_circle_outlined),
                tooltip: '사용자',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: '설정',
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: List.generate(_labels.length, (index) =>
                    NavigationRailDestination(
                      icon: Icon(_icons[index]),
                      label: Text(_labels[index]),
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
