import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';

/// نوع الحساب - UI فقط حالياً (لحد ما الـ API يدعم role)
enum RegisterRole { owner, manager, cashier }

class RegisterPage extends StatefulWidget {
  /// لو true → الصفحة مفتوحة من داخل الداشبورد (الأدمن بيضيف موظف)
  /// لو false → صفحة public للتسجيل العام
  final bool isAdminMode;

  const RegisterPage({super.key, this.isAdminMode = false});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  RegisterRole _role = RegisterRole.owner;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // ⚠️ ملاحظة: الـ role غير مفعّل دلوقتي - لحد ما الـ backend يدعمه
    // لما يجاهز، عدّل register() في AuthCubit و الـ AccountsRepository
    // عشان تبعت الـ role parameter
    //
    // مثال للمستقبل:
    // context.read<AuthCubit>().register(
    //   email: _emailController.text.trim(),
    //   password: _passwordController.text,
    //   role: _role.name, // ⬅️ هتضيف ده لما الـ API يدعمه
    // );

    context.read<AuthCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.isAdminMode
          ? AppBar(
        title: const Text('إضافة حساب جديد'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      )
          : null,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            // لو من داخل الداشبورد → ارجع للصفحة اللي قبلها
            // لو public → روح login
            if (widget.isAdminMode) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide && !widget.isAdminMode ? 1100 : 500,
                ),
                child: isWide && !widget.isAdminMode
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(flex: 5, child: _buildRegisterCard()),
                    const SizedBox(width: 60),
                    Flexible(flex: 4, child: _buildBrandingSide()),
                  ],
                )
                    : _buildRegisterCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingSide() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/bar_logo.png',
              width: 160,
              height: 160,
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'BAR Sweets',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'انضم إلينا اليوم',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        const Text(
          'احصل على تجربة إدارة احترافية',
          style: TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isAdminMode ? 'إضافة حساب جديد' : 'إنشاء حساب',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.isAdminMode
                  ? 'أنشئ حساب جديد للموظف'
                  : 'سجل الآن وابدأ تجربتك',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),

            // ===== Email =====
            _FieldLabel('البريد الإلكتروني'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.email_outlined,
                    color: AppColors.textHint),
                hintText: 'example@bar.com',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'البريد مطلوب';
                if (!v.contains('@') || !v.contains('.')) {
                  return 'بريد غير صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ===== Password =====
            _FieldLabel('كلمة المرور'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textHint),
                prefixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textHint,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                hintText: '••••••••',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'كلمة المرور مطلوبة';
                if (v.length < 6) return 'كلمة المرور 6 أحرف على الأقل';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ===== Confirm Password =====
            _FieldLabel('تأكيد كلمة المرور'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textHint),
                prefixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textHint,
                  ),
                  onPressed: () => setState(() =>
                  _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                hintText: '••••••••',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يجب تأكيد كلمة المرور';
                if (v != _passwordController.text) {
                  return 'كلمتا المرور غير متطابقتين';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ===== نوع الدور (UI فقط - مش مفعّل لحد ما الـ API يدعمه) =====
            Row(
              children: [
                _FieldLabel('نوع الحساب'),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'قريباً',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _RoleCard(
                    icon: Icons.point_of_sale,
                    label: 'الكاشير',
                    selected: _role == RegisterRole.cashier,
                    onTap: () =>
                        setState(() => _role = RegisterRole.cashier),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleCard(
                    icon: Icons.badge,
                    label: 'المدير',
                    selected: _role == RegisterRole.manager,
                    onTap: () =>
                        setState(() => _role = RegisterRole.manager),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleCard(
                    icon: Icons.workspace_premium,
                    label: 'المالك',
                    selected: _role == RegisterRole.owner,
                    onTap: () => setState(() => _role = RegisterRole.owner),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== Submit =====
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is RegisterLoading;
                return SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _submit,
                    icon: isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.person_add, size: 20),
                    label: Text(
                      isLoading
                          ? 'جاري إنشاء الحساب...'
                          : (widget.isAdminMode
                          ? 'إضافة الحساب'
                          : 'إنشاء الحساب'),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // ===== Link to Login =====
            if (!widget.isAdminMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'لديك حساب بالفعل؟',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed('/login'),
                    child: const Text(
                      'سجل دخولك',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ============= Helpers =============

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
