import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dashboard.dart';

class PermissionPage2 extends StatefulWidget {
  const PermissionPage2({super.key});

  @override
  _PermissionPageState2 createState() => _PermissionPageState2();
}

class _PermissionPageState2 extends State<PermissionPage2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPermissionDialog();
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'يرجى منح الإذن',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'يحتاج أمان بلاي إلى إرسال إشعارات مع كل عملية رصد',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToDashboard(); // skip permission, go to dashboard
              },
              child: const Text('لاحقًا', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _requestNotificationPermission(); // request then go to dashboard
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('موافق', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isPermanentlyDenied && mounted) {
      // User permanently denied — offer to open settings
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('الإذن مرفوض', textAlign: TextAlign.center),
          content: const Text(
            'تم رفض إذن الإشعارات بشكل دائم. يرجى تفعيله من إعدادات التطبيق.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToDashboard();
              },
              child: const Text('تخطي', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
                if (mounted) _goToDashboard();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('فتح الإعدادات',
                  style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      );
    } else {
      _goToDashboard();
    }
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}