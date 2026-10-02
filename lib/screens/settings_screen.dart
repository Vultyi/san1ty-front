import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/core/security/api_security_service.dart';
import 'package:estrutura_front_san1ty/screens/login_screen.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';

TextStyle _inter(double size, FontWeight weight, Color color) =>
    GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

/// Configurações: perfil, notificações, versão e sair.
class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifs = true;
  String _version = '';
  String _userName = '';
  String _userEmail = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final info = await PackageInfo.fromPlatform();
    final user = await AuthService().getCurrentUser();
    if (!mounted) return;
    setState(() {
      _notifs = prefs.getBool('notifs_enabled') ?? true;
      _version = 'v${info.version} (build ${info.buildNumber})';
      final full = (user?['full_name'] ?? '') as String;
      _userName = full.isEmpty ? 'Usuário' : full;
      _userEmail = (user?['email'] ?? '') as String;
      _loading = false;
    });
  }

  Future<void> _toggleNotifs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifs_enabled', value);
    if (mounted) setState(() => _notifs = value);
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_back_ios_new_outlined,
                        size: 24, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Configurações',
                    style: _inter(20, FontWeight.w600, AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _profileCard(),
              const SizedBox(height: 16),
              _section('Preferências', [
                _switchRow('Notificações', 'Avisos de pagamento e novidades', _notifs,
                    _toggleNotifs),
              ]),
              const SizedBox(height: 16),
              _section('Sobre', [
                _infoRow('Versão', _version),
                _infoRow('Servidor', ApiSecurityService.baseUrl),
              ]),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.errorRed),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Sair da conta',
                      style: _inter(15, FontWeight.w600, AppColors.errorRed)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.actionPrimary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
              style: _inter(20, FontWeight.w700, Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_userName, style: _inter(17, FontWeight.w600, AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(_userEmail, style: _inter(13, FontWeight.w400, AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _inter(17, FontWeight.w600, AppColors.textPrimary)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            border: Border.all(color: AppColors.borderDefault),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _switchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.actionPrimary,
      title: Text(title, style: _inter(15, FontWeight.w500, AppColors.textPrimary)),
      subtitle:
          Text(subtitle, style: _inter(13, FontWeight.w400, AppColors.textSecondary)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _inter(15, FontWeight.w500, AppColors.textPrimary)),
          Flexible(
            child: Text(value,
                style: _inter(13, FontWeight.w400, AppColors.textSecondary),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
