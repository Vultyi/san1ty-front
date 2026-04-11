// lib/widgets/admin_credentials_display.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';
import '../models/admin_models.dart';

class AdminCredentialsDisplay extends StatelessWidget {
  final SupportCredentials credentials;

  const AdminCredentialsDisplay({
    super.key,
    required this.credentials,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Login
        Text(
          'LOGIN',
          style: AdminTextStyles.labelBase.copyWith(
            color: AdminColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: AdminDimensions.spacingSM),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AdminDimensions.spacingBase,
                  vertical: AdminDimensions.spacingBase,
                ),
                decoration: BoxDecoration(
                  color: AdminColors.bgSecondary,
                  border: Border.all(
                    color: AdminColors.borderPrimary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
                ),
                child: Text(
                  credentials.email,
                  style: AdminTextStyles.bodyBase.copyWith(
                    fontFamily: 'monospace',
                    color: AdminColors.accentCyan,
                  ),
                ),
              ),
            ),
            SizedBox(width: AdminDimensions.spacingSM),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AdminColors.bgSecondary,
                border: Border.all(
                  color: AdminColors.borderPrimary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.copy,
                  color: AdminColors.accentCyan,
                  size: 20,
                ),
                onPressed: () => _copyToClipboard(context, credentials.email, 'Login'),
              ),
            ),
          ],
        ),
        SizedBox(height: AdminDimensions.spacingLG),
        // Senha
        Text(
          'SENHA',
          style: AdminTextStyles.labelBase.copyWith(
            color: AdminColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: AdminDimensions.spacingSM),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AdminDimensions.spacingBase,
                  vertical: AdminDimensions.spacingBase,
                ),
                decoration: BoxDecoration(
                  color: AdminColors.bgSecondary,
                  border: Border.all(
                    color: AdminColors.borderPrimary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
                ),
                child: Text(
                  credentials.password,
                  style: AdminTextStyles.bodyBase.copyWith(
                    fontFamily: 'monospace',
                    color: AdminColors.accentCyan,
                  ),
                ),
              ),
            ),
            SizedBox(width: AdminDimensions.spacingSM),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AdminColors.bgSecondary,
                border: Border.all(
                  color: AdminColors.borderPrimary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.copy,
                  color: AdminColors.accentCyan,
                  size: 20,
                ),
                onPressed: () => _copyToClipboard(context, credentials.password, 'Senha'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copiado para a área de transferência'),
        backgroundColor: AdminColors.statusGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}