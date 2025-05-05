import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/mood_provider.dart';
import 'screens/mood_journal/mood_journal_screen.dart';
import 'services/database_helper.dart';
import 'theme/app_theme.dart';

void main() async {
  // 确保Flutter引擎初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化数据库
  await DatabaseHelper();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MoodProvider())],
      child: MaterialApp(
        title: '愈迹',
        theme: AppTheme.getTheme(),
        home: const MoodJournalScreen(),
      ),
    );
  }
}
