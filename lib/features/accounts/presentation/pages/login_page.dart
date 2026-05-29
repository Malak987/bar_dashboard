import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/branch_selection/branch_selection_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../../../branches/presentation/cubit/branches_cubit.dart';
import '../cubit/auth_cubit.dart';

enum AccountType { cashier, manager, owner }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
  TextEditingController(text: 'admin@luxesweets.com');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;
  bool _rememberMe = false;
  AccountType _accountType = AccountType.owner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final branchesCubit = context.read<BranchesCubit>();
      if (branchesCubit.state is BranchesInitial) {
        branchesCubit.fetchAllBranches();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('مرحباً ${state.auth.userName} 👋'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 4),
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
                  maxWidth: isWide ? 1100 : 500,
                ),
                child: isWide
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(flex: 5, child: _buildLoginCard()),
                    const SizedBox(width: 60),
                    Flexible(flex: 4, child: _buildBrandingSide()),
                  ],
                )
                    : _buildLoginCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============= Branding =============
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
          'إدارة محل الحلويات الفاخرة',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        const Text(
          'لوحة تحكم احترافية v2.0',
          style: TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _StatBadge(icon: '💎', value: '+1K', label: 'العملاء'),
            SizedBox(width: 14),
            _StatBadge(icon: '🧁', value: '+50', label: 'المنتجات'),
            SizedBox(width: 14),
            _StatBadge(icon: '🏪', value: '+3', label: 'الفروع'),
          ],
        ),
      ],
    );
  }

  // ============= Login Card =============
  Widget _buildLoginCard() {
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
            // Title
            const Text(
              'تسجيل الدخول',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'سجل دخولك للوحة التحكم',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // ===== نوع الحساب =====
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'نوع الحساب',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _AccountTypeCard(
                    icon: Icons.point_of_sale,
                    label: 'الكاشير',
                    selected: _accountType == AccountType.cashier,
                    onTap: () => setState(
                            () => _accountType = AccountType.cashier),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AccountTypeCard(
                    icon: Icons.badge,
                    label: 'المدير',
                    selected: _accountType == AccountType.manager,
                    onTap: () => setState(
                            () => _accountType = AccountType.manager),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _AccountTypeCard(
                    icon: Icons.workspace_premium,
                    label: 'المالك',
                    selected: _accountType == AccountType.owner,
                    onTap: () => setState(
                            () => _accountType = AccountType.owner),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== الفرع =====
            const _FieldLabel('الفرع'),
            const SizedBox(height: 8),
            BlocBuilder<BranchesCubit, BranchesState>(
              buildWhen: (previous, current) {
                return current is BranchesInitial ||
                    current is BranchesLoading ||
                    current is BranchesLoaded ||
                    current is BranchesFailure;
              },
              builder: (context, branchesState) {
                final branches = branchesState is BranchesLoaded
                    ? branchesState.branches.items
                    : <BranchEntity>[];

                return BlocBuilder<BranchSelectionCubit, BranchSelectionState>(
                  builder: (context, selectionState) {
                    final selectedValue = selectionState.selectedBranchId;
                    final dropdownValue = selectedValue != null &&
                            branches.any((branch) => branch.id == selectedValue)
                        ? selectedValue
                        : '__all__';

                    return DropdownButtonFormField<String>(
                      key: ValueKey(dropdownValue),
                      initialValue: dropdownValue,
                      dropdownColor: AppColors.surfaceLight,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.store_outlined,
                          color: AppColors.textHint,
                        ),
                        suffixIcon: branchesState is BranchesLoading
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: '__all__',
                          child: Text('كل الفروع'),
                        ),
                        ...branches.map(
                          (branch) => DropdownMenuItem(
                            value: branch.id,
                            child: Text(branch.nameAr),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null || value == '__all__') {
                          context
                              .read<BranchSelectionCubit>()
                              .selectAllBranches();
                          return;
                        }

                        final branch = branches.firstWhere((item) => item.id == value);
                        context.read<BranchSelectionCubit>().selectBranch(
                              id: branch.id,
                              name: branch.nameAr,
                            );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // ===== Email =====
            const _FieldLabel('البريد الإلكتروني'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.email_outlined,
                    color: AppColors.textHint),
                hintText: 'admin@example.com',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'البريد مطلوب';
                if (!v.contains('@')) return 'بريد غير صحيح';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ===== Password =====
            const _FieldLabel('كلمة المرور'),
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
                if (v.length < 6) return 'كلمة المرور قصيرة';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ===== Remember + Forgot =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
                Row(
                  children: [
                    const Text('تذكرني',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                        activeColor: AppColors.primary,
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== Submit =====
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is LoginLoading;
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
                        : const Icon(Icons.login, size: 20),
                    label: Text(
                      isLoading ? 'جاري الدخول...' : 'تسجيل الدخول',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // ===== Link to Register =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ليس لديك حساب؟',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/register'),
                  child: const Text(
                    'سجل الآن',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== Test accounts =====
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.info_outline,
                          color: AppColors.primary, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'بيانات تجريبية',
                        style: TextStyle(
                            color: AppColors.primary, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _testCredentialRow(
                      '👑', 'admin@luxesweets.com / admin123'),
                  const SizedBox(height: 4),
                  _testCredentialRow(
                      '💼', 'fatima@luxesweets.com / manager123'),
                  const SizedBox(height: 4),
                  _testCredentialRow(
                      '💳', 'omar@luxesweets.com / cashier123'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testCredentialRow(String emoji, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

// ============= Helpers =============

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        label,
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 13),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AccountTypeCard({
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

class _StatBadge extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
