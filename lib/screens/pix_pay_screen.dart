import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/screens/pix_value_screen.dart';

class PixPayScreen extends StatefulWidget {
  static const String routeName = '/pix/pay';

  const PixPayScreen({super.key});

  @override
  State<PixPayScreen> createState() => _PixPayScreenState();
}

class _PixPayScreenState extends State<PixPayScreen> {
  final TextEditingController _keyController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool get _isValidKey => _keyController.text.trim().length > 10;

  @override
  void dispose() {
    _keyController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 28),
                    const Text('Para quem você quer pagar?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 24),
                    _buildSearchField(),
                    const SizedBox(height: 24),
                    _buildActionRow(),
                    const SizedBox(height: 24),
                    AnimatedOpacity(
                      opacity: _isValidKey ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: IgnorePointer(
                        ignoring: !_isValidKey,
                        child: ElevatedButton(
                          onPressed: _continue,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 54),
                            backgroundColor: const Color(0xFF1D4ED8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            shadowColor: const Color(0x4D1D4ED8),
                            elevation: 4,
                          ),
                          child: const Text('Continuar', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          iconSize: 24,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF60A5FA)),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 24,
          hoverColor: const Color(0x1A93C5FD),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _keyController,
              focusNode: _searchFocusNode,
              decoration: const InputDecoration(
                hintText: 'chave, e-mail, celular, CPF, copia e cola',
                hintStyle: TextStyle(color: Color(0xFF666666)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFF60A5FA),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Color(0xFF666666), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconAction(
          label: 'Escanear',
          icon: Icons.qr_code_scanner,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidade de escanear ainda não implementada.')),
            );
          },
        ),
        _buildIconAction(
          label: 'Pix Copia e Cola',
          icon: Icons.description,
          onTap: () {
            final payload = _keyController.text.trim();
            if (payload.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: payload));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Texto copiado para a área de transferência.')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildIconAction({required String label, required IconData icon, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Icon(icon, color: const Color(0xFF60A5FA), size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 12)),
      ],
    );
  }

  void _continue() {
    if (!_isValidKey) return;
    Navigator.pushNamed(
      context,
      PixValueScreen.routeName,
      arguments: _keyController.text.trim(),
    );
  }
}
