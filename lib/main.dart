import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posdevices/modules/manager/views/manager_login_view.dart';
import 'package:posdevices/routes/app_pages.dart';

import 'modules/pos/views/pos_home_view.dart';

void main() {
  runApp(const WorkspaceLauncherApp());
}

class WorkspaceLauncherApp extends StatelessWidget {
  const WorkspaceLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plugin OS Workspace',
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      getPages: AppPages.manager,
      home: _LauncherHome(),
    );
  }
}

class _LauncherHome extends StatelessWidget {
  const _LauncherHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07111D), Color(0xFF111827), Color(0xFF030712)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    size: 72,
                    color: Color(0xFF2DD4BF),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Plugin OS Demo Workspace',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose a local UI to verify the manager and POS flows before Firebase is connected.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _LaunchCard(
                        title: 'Manager App',
                        subtitle: 'Phone-first menu management demo',
                        icon: Icons.phone_iphone_rounded,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => _VisibleShell(
                              title: 'Manager Demo',
                              child: ManagerLoginView(),
                            ),
                          ),
                        ),
                      ),
                      _LaunchCard(
                        title: 'POS App',
                        subtitle: 'Tablet/web ordering demo',
                        icon: Icons.tablet_mac_rounded,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const _VisibleShell(
                              title: 'POS Demo',
                              child: PosHomeView(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _LaunchCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        color: const Color(0xFF0F172A),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40, color: const Color(0xFF2DD4BF)),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VisibleShell extends StatelessWidget {
  final String title;
  final Widget child;

  const _VisibleShell({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}
