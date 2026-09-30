// lib/core/update/update_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Atualização OTA via GitHub Releases (repo público, sem token).
///
/// Convenção de tag: `build-N` (gerada pelo workflow build.yml com
/// `--build-number=${{ github.run_number }}`).
/// Compara N com o buildNumber instalado e, se maior, baixa o APK do asset
/// do Release e dispara a instalação.
class UpdateInfo {
  final int latestBuild;
  final String apkUrl;
  final String tag;

  const UpdateInfo({
    required this.latestBuild,
    required this.apkUrl,
    required this.tag,
  });
}

class UpdateService {
  static const String _owner = 'Vultyi';
  static const String _repo = 'san1ty-front';
  static const String _latestUrl =
      'https://api.github.com/repos/$_owner/$_repo/releases/latest';
  static const Duration _timeout = Duration(seconds: 15);

  /// Retorna info de update se houver build maior, senão null.
  /// Nunca joga exceção: qualquer falha (sem internet, API fora, JSON
  /// inesperado) resulta em null para não travar o app.
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final local = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(local.buildNumber) ?? 0;

      final res = await http.get(
        Uri.parse(_latestUrl),
        headers: {'Accept': 'application/vnd.github+json'},
      ).timeout(_timeout);
      if (res.statusCode != 200) return null;

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final tag = (json['tag_name'] as String?) ?? '';
      final latestBuild = _buildFromTag(tag);
      if (latestBuild == null || latestBuild <= currentBuild) return null;

      final apkUrl = _apkUrlFromAssets(json['assets']);
      if (apkUrl == null) return null;

      return UpdateInfo(latestBuild: latestBuild, apkUrl: apkUrl, tag: tag);
    } catch (_) {
      return null;
    }
  }

  /// Baixa e instala. Emite progresso 0-100 via [onProgress].
  /// Erros de download/instalação são reportados via evento, sem throw
  /// para o fluxo normal (só relança erro interno inesperado).
  Stream<OtaEvent> downloadAndInstall(
    UpdateInfo info, {
    String destinationFilename = 'san1ty-update.apk',
  }) {
    return OtaUpdate().execute(
      info.apkUrl,
      destinationFilename: destinationFilename,
    );
  }

  static int? _buildFromTag(String tag) {
    // Aceita "build-123" ou "build_123" / "v+123".
    final m = RegExp(r'build[-_]?(\d+)', caseSensitive: false).firstMatch(tag);
    if (m != null) return int.tryParse(m.group(1)!);
    final digits = RegExp(r'(\d+)\s*$').firstMatch(tag);
    return digits == null ? null : int.tryParse(digits.group(1)!);
  }

  static String? _apkUrlFromAssets(dynamic assets) {
    if (assets is! List) return null;
    for (final a in assets) {
      if (a is! Map<String, dynamic>) continue;
      final name = (a['name'] as String? ?? '').toLowerCase();
      final url = a['browser_download_url'] as String?;
      if (url == null || url.isEmpty) continue;
      if (name.endsWith('.apk')) return url;
    }
    return null;
  }
}
