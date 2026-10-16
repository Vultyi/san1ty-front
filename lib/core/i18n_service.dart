import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:estrutura_front_san1ty/core/security/api_security_service.dart';

/// Idioma do app (PT/ES/EN) com pacotes vindos do backend (`/api/i18n`).
/// Offline cai no PT embutido. Troca de idioma reinicia o fluxo (splash).
class I18nService {
  I18nService._();
  static final I18nService instance = I18nService._();

  static const supported = ['pt-BR', 'en', 'es'];
  static const _prefsKey = 'locale';
  static const _cachePrefix = 'i18n_cache_';

  final ValueNotifier<String> locale = ValueNotifier('pt-BR');
  final Map<String, String> _strings = {};

  static const Map<String, String> _ptFallback = {
    'home.greeting': 'Olá',
    'home.welcome': 'Que bom ter você por aqui.',
    'home.balance': 'Saldo em conta',
    'home.hidden': 'Oculto',
    'home.tagline': 'Seu dinheiro rende mais aqui',
    'home.shortcuts_pix': 'Pix',
    'home.shortcuts_pix_sub': 'Transferir e pagar',
    'home.shortcuts_sales': 'Vendas',
    'home.shortcuts_sales_sub': 'Seu faturamento',
    'home.shortcuts_bill': 'Pagar conta',
    'home.shortcuts_bill_sub': 'Boletos e serviços',
    'home.shortcuts_soon': 'Em breve',
    'home.shortcuts_soon_sub': 'Novidades',
    'home.performance': 'Seu desempenho',
    'home.performance_sub': 'Acompanhe como está o seu negócio',
    'home.goal': 'Meta do mês',
    'home.goal_empty': 'Toque para definir quanto quer vender',
    'home.goal_edit': 'Toque para editar sua meta',
    'home.goal_dialog_title': 'Quanto você quer vender este mês?',
    'home.goal_dialog_sub': 'A gente acompanha suas vendas até lá.',
    'home.goal_set': 'Definir meta',
    'home.tip': 'Dica do seu banco',
    'home.tip_text': 'Ative o Pix automático e nunca perca uma venda',
    'home.security': 'Segurança em primeiro lugar',
    'home.security_sub': 'Ative a verificação em 2 etapas',
    'home.security_cta': 'Ativar',
    'home.nav_home': 'Início',
    'home.nav_statement': 'Extrato',
    'home.nav_commerce': 'Comércio',
    'home.nav_wallet': 'Carteira',
    'home.drawer_profile': 'Perfil',
    'home.drawer_settings': 'Configurações',
    'home.drawer_support': 'Suporte',
    'home.drawer_logout': 'Sair da conta',
    'home.drawer_account': 'Conta San1ty',
  };

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && supported.contains(saved)) {
      locale.value = saved;
    }
    await _loadCached(prefs);
    _fetchAll().ignore();
  }

  Future<void> setLocale(String code) async {
    if (!supported.contains(code)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
    locale.value = code;
    _strings.clear();
    await _loadCached(prefs);
    await _fetchAll();
  }

  String t(String key) => _strings[key] ?? _ptFallback[key] ?? key;

  Future<void> _loadCached(SharedPreferences prefs) async {
    final raw = prefs.getString('$_cachePrefix${locale.value}');
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      map.forEach((k, v) {
        if (v is String) _strings[k] = v;
      });
    } catch (_) {}
  }

  Future<void> _fetchAll() async {
    final code = locale.value;
    final merged = <String, String>{};
    for (final ns in <String>['home', 'auth', 'common', 'app', 'support']) {
      try {
        final res = await http
            .get(Uri.parse('${ApiSecurityService.baseUrl}/api/i18n/$code/$ns'))
            .timeout(const Duration(seconds: 10));
        if (res.statusCode != 200) continue;
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final tr = body['translations'];
        if (tr is Map) {
          tr.forEach((k, v) {
            if (v is String) merged[k.toString()] = v;
          });
        }
      } catch (_) {}
    }
    if (merged.isEmpty) return;
    _strings.addAll(merged);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_cachePrefix$code', jsonEncode(merged));
    } catch (_) {}
  }
}

/// Atalho: `tr('home.balance')`.
String tr(String key) => I18nService.instance.t(key);
