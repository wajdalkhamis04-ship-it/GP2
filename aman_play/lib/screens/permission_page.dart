import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_page2.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
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
            'يحتاج أمان بلاي إلى استخدام الميكروفون لكي يستطيع تسجيل المدخلات الصوتية',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToNextPage(); // skip permission, go next
              },
              child: const Text('لاحقًا', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _requestMicPermission(); // request then go next
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('موافق', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();

    if (status.isPermanentlyDenied && mounted) {
      // User permanently denied — open settings
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('الإذن مرفوض', textAlign: TextAlign.center),
          content: const Text(
            'تم رفض إذن الميكروفون بشكل دائم. يرجى تفعيله من إعدادات التطبيق.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToNextPage();
              },
              child: const Text('تخطي', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
                if (mounted) _goToNextPage();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child:
                  const Text('فتح الإعدادات', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      );
    } else {
      _goToNextPage();
    }
  }

  void _goToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PermissionPage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}