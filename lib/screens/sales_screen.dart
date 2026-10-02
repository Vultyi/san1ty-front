import 'dart:async';

import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

// Tokens locais (valores da especificação que não existem em Dimensions).
const double _margin = 20;
const double _space24 = 24;
const double _radiusCard = 18;
const double _radiusPill = 21;
const Color _white = Color(0xFFF5F7FA);

TextStyle _inter(double size, FontWeight weight, Color color) =>
    GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

String _formatBrl(int cents) {
  final reais = (cents ~/ 100).toString();
  final buffer = StringBuffer();
  for (var i = 0; i < reais.length; i++) {
    if (i > 0 && (reais.length - i) % 3 == 0) buffer.write('.');
    buffer.write(reais[i]);
  }
  final centavos = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $buffer,$centavos';
}

/// Campo só com dígitos: o usuário digita números e o texto vira R$ 0,00.
class _BrlInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    digits = digits.replaceFirst(RegExp(r'^0+'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    if (digits.length > 9) digits = digits.substring(0, 9);
    final text = _formatBrl(int.parse(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class SalesScreen extends StatefulWidget {
  static const String routeName = '/sales';

  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  static const Duration _pollEvery = Duration(seconds: 5);
  static const int _maxPolls = 120; // ~10 minutos

  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final PaymentService _service = PaymentService();

  PixCharge? _charge;
  bool _loading = false;
  bool _refreshing = false;
  Timer? _timer;
  int _polls = 0;

  int get _cents =>
      int.tryParse(_amountCtrl.text.replaceAll(RegExp(r'\D'), '')) ?? 0;

  @override
  void dispose() {
    _timer?.cancel();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _service.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- ações

  Future<void> _generate() async {
    final cents = _cents;
    if (cents <= 0) {
      _toast('Digite um valor maior que zero.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      final description = _descCtrl.text.trim().isEmpty
          ? 'Cobrança San1tyPay'
          : _descCtrl.text.trim();
      final charge = await _service.createCharge(
        amountCents: cents,
        description: description,
      );
      if (!mounted) return;
      setState(() => _charge = charge);
      _startPolling();
    } on PaymentException catch (e) {
      _toast(e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startPolling() {
    _timer?.cancel();
    _polls = 0;
    _timer = Timer.periodic(_pollEvery, (_) {
      _polls++;
      if (_polls > _maxPolls) {
        _timer?.cancel();
        return;
      }
      _refresh(silent: true);
    });
  }

  Future<void> _refresh({bool silent = false}) async {
    final charge = _charge;
    if (charge == null || _refreshing) return;
    _refreshing = true;
    if (!silent) setState(() {});
    try {
      final status = await _service.fetchStatus(charge.id);
      if (!mounted) return;
      setState(() => _charge = charge.copyWith(status: status));
      if (status != PaymentStatus.pending) _timer?.cancel();
    } on PaymentException catch (e) {
      if (!silent) _toast(e.message);
    } finally {
      _refreshing = false;
      if (mounted && !silent) setState(() {});
    }
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    _toast('Código copiado.');
  }

  Future<void> _share(PixCharge charge) async {
    try {
      await Share.share(
        'Pague ${_formatBrl(charge.amountCents)} via Pix:\n${charge.pixCode}',
      );
    } on Exception {
      _toast('Não foi possível compartilhar agora.');
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _charge = null;
      _amountCtrl.clear();
      _descCtrl.clear();
    });
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.backgroundSecondary,
          margin: const EdgeInsets.fromLTRB(_margin, 0, _margin, Dimensions.space16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius16),
            side: const BorderSide(color: AppColors.borderDefault),
          ),
          content: Text(message, style: _inter(14, FontWeight.w400, _white)),
        ),
      );
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final charge = _charge;
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(_margin, Dimensions.space8, _margin, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: _space24),
              _buildFormCard(),
              if (charge != null) ...[
                const SizedBox(height: Dimensions.space16),
                _buildChargeCard(charge),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 24, color: _white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(width: Dimensions.space8),
        Text('Vendas', style: _inter(20, FontWeight.w600, _white)),
      ],
    );
  }

  Widget _buildFormCard() {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nova cobrança', style: _inter(17, FontWeight.w600, _white)),
          const SizedBox(height: Dimensions.space4),
          Text(
            'Gere um QR Code Pix e envie ao cliente pelo seu bot.',
            style: _inter(14, FontWeight.w400, AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Text('Valor', style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
          const SizedBox(height: Dimensions.space8),
          TextField(
            controller: _amountCtrl,
            enabled: !_loading,
            keyboardType: TextInputType.number,
            inputFormatters: [_BrlInputFormatter()],
            cursorColor: AppColors.actionPrimary,
            style: _inter(40, FontWeight.w600, _white),
            decoration: InputDecoration.collapsed(
              hintText: 'R\$ 0,00',
              hintStyle: _inter(40, FontWeight.w600, AppColors.borderDefault),
            ),
          ),
          const SizedBox(height: 20),
          Text('Descrição (opcional)',
              style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
          const SizedBox(height: Dimensions.space8),
          TextField(
            controller: _descCtrl,
            enabled: !_loading,
            maxLength: 80,
            cursorColor: AppColors.actionPrimary,
            style: _inter(14, FontWeight.w400, _white),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Ex.: Curso de edição - módulo 1',
              hintStyle: _inter(14, FontWeight.w400, AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.backgroundPrimary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space16,
                vertical: Dimensions.space12,
              ),
              border: _fieldBorder(AppColors.borderDefault),
              enabledBorder: _fieldBorder(AppColors.borderDefault),
              disabledBorder: _fieldBorder(AppColors.borderDefault),
              focusedBorder: _fieldBorder(AppColors.actionPrimary),
            ),
          ),
          const SizedBox(height: _space24),
          _PrimaryButton(
            label: 'Gerar cobrança',
            loading: _loading,
            onPressed: _loading ? null : _generate,
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _fieldBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        borderSide: BorderSide(color: color),
      );

  Widget _buildChargeCard(PixCharge charge) {
    final paid = charge.status == PaymentStatus.paid;
    final expired = charge.status == PaymentStatus.expired;
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Cobrança Pix', style: _inter(17, FontWeight.w600, _white)),
              ),
              _StatusPill(status: charge.status),
            ],
          ),
          const SizedBox(height: Dimensions.space4),
          Text(
            _formatBrl(charge.amountCents),
            style: _inter(20, FontWeight.w600, _white),
          ),
          const SizedBox(height: 20),
          Center(child: _buildQrArea(charge, paid: paid, expired: expired)),
          const SizedBox(height: 20),
          Text('Pix copia e cola',
              style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
          const SizedBox(height: Dimensions.space8),
          _buildCodeBox(charge.pixCode),
          const SizedBox(height: _space24),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  label: 'Compartilhar',
                  icon: Icons.share_outlined,
                  onPressed: () => _share(charge),
                ),
              ),
              const SizedBox(width: Dimensions.space12),
              Expanded(
                child: _OutlineButton(
                  label: 'Atualizar',
                  icon: Icons.refresh_outlined,
                  loading: _refreshing,
                  onPressed: _refreshing ? null : () => _refresh(),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space8),
          Center(
            child: TextButton(
              onPressed: _reset,
              child: Text('Nova cobrança',
                  style: _inter(14, FontWeight.w600, AppColors.actionPrimary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrArea(PixCharge charge, {required bool paid, required bool expired}) {
    if (paid || expired) {
      final color = paid ? AppColors.successGreen : AppColors.textSecondary;
      return SizedBox(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              paid ? Icons.check_circle_outline : Icons.timer_off_outlined,
              size: 24,
              color: color,
            ),
            const SizedBox(height: Dimensions.space12),
            Text(
              paid ? 'Pagamento confirmado' : 'Cobrança expirada',
              style: _inter(17, FontWeight.w600, color),
            ),
            const SizedBox(height: Dimensions.space4),
            Text(
              paid ? 'O cliente já pode receber o acesso.' : 'Gere uma nova cobrança.',
              style: _inter(14, FontWeight.w400, AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(Dimensions.space16),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: QrImageView(
        data: charge.pixCode,
        size: 200,
        padding: EdgeInsets.zero,
        backgroundColor: _white,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.backgroundPrimary,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: AppColors.backgroundPrimary,
        ),
      ),
    );
  }

  Widget _buildCodeBox(String code) {
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              code,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _inter(14, FontWeight.w400, AppColors.textSecondary),
            ),
          ),
          IconButton(
            tooltip: 'Copiar código',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.content_copy_outlined, size: 24, color: _white),
            onPressed: () => _copy(code),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ componentes

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(_radiusCard),
      ),
      child: child,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      PaymentStatus.paid => ('Pago', AppColors.successGreen),
      PaymentStatus.expired => ('Expirado', AppColors.textSecondary),
      PaymentStatus.pending => ('Aguardando', AppColors.warningOrange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.space12,
        vertical: Dimensions.space8,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(_radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: Dimensions.space8),
          Text(label, style: _inter(14, FontWeight.w600, color)),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: AppColors.actionPrimary,
        disabledBackgroundColor: AppColors.actionPrimary.withAlpha(110),
        foregroundColor: _white,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: _white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 24, color: _white),
                  const SizedBox(width: Dimensions.space8),
                ],
                Flexible(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: _inter(14, FontWeight.w600, _white)),
                ),
              ],
            ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        side: const BorderSide(color: AppColors.borderDefault),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.actionPrimary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: _white),
                const SizedBox(width: Dimensions.space8),
                Flexible(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: _inter(14, FontWeight.w600, _white)),
                ),
              ],
            ),
    );
  }
}
