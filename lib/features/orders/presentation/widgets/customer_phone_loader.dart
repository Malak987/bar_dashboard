import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../accounts/domain/repositories/accounts_repository.dart';

/// 📞 ويدجت بتحمّل رقم تليفون العميل من Users API
/// (لأن Order response مش بيرجع رقم التليفون)
class CustomerPhoneLoader extends StatefulWidget {
  final String userId;

  const CustomerPhoneLoader({super.key, required this.userId});

  // 🗄️ Cache بسيط عشان مانحملش الرقم كل مرة
  static final Map<String, String?> _phoneCache = {};

  @override
  State<CustomerPhoneLoader> createState() => _CustomerPhoneLoaderState();
}

class _CustomerPhoneLoaderState extends State<CustomerPhoneLoader> {
  String? _phone;
  bool _isLoading = false;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    // لو موجود في الـ cache، خده فوراً
    if (CustomerPhoneLoader._phoneCache.containsKey(widget.userId)) {
      _phone = CustomerPhoneLoader._phoneCache[widget.userId];
      _hasLoaded = true;
    } else {
      _loadPhone();
    }
  }

  Future<void> _loadPhone() async {
    setState(() => _isLoading = true);
    try {
      final repo = sl<AccountsRepository>();
      final result = await repo.getUserById(widget.userId);
      result.when(
        success: (user) {
          CustomerPhoneLoader._phoneCache[widget.userId] = user.phoneNumber;
          if (mounted) {
            setState(() {
              _phone = user.phoneNumber;
              _isLoading = false;
              _hasLoaded = true;
            });
          }
        },
        failure: (_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasLoaded = true;
            });
          }
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasLoaded = true;
        });
      }
    }
  }

  Future<void> _callPhone() async {
    if (_phone == null) return;
    final uri = Uri(scheme: 'tel', path: _phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _whatsappPhone() async {
    if (_phone == null) return;
    // تنظيف الرقم (إزالة الـ +20 لو موجود + الـ spaces)
    var cleanPhone = _phone!.replaceAll(RegExp(r'[\s\-()]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '20${cleanPhone.substring(1)}';
    }
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.info),
            ),
            SizedBox(width: 8),
            Text('جاري تحميل رقم التليفون...',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      );
    }

    if (!_hasLoaded || _phone == null || _phone!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.phone_disabled,
                size: 16, color: AppColors.textHint),
            SizedBox(width: 8),
            Text('لا يوجد رقم تليفون مسجل',
                style: TextStyle(
                    color: AppColors.textHint, fontSize: 12)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border:
        Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone, color: AppColors.info, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'رقم التليفون',
                  style:
                  TextStyle(color: AppColors.textHint, fontSize: 10),
                ),
                Text(
                  _phone!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call,
                color: AppColors.success, size: 22),
            tooltip: 'اتصال',
            onPressed: _callPhone,
          ),
          IconButton(
            icon: const Icon(Icons.message,
                color: Color(0xFF25D366), size: 22),
            tooltip: 'واتساب',
            onPressed: _whatsappPhone,
          ),
        ],
      ),
    );
  }
}
