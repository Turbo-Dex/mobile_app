import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/tokens.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/model/auth_models.dart';

class RecoveryCodePage extends ConsumerStatefulWidget {
  const RecoveryCodePage({Key? key}) : super(key: key);

  @override
  ConsumerState<RecoveryCodePage> createState() => _RecoveryCodePageState();
}

class _RecoveryCodePageState extends ConsumerState<RecoveryCodePage> {
  RecoveryCode? _code;
  bool _loading = false;
  String? _error;

  Future<void> _generate() async {
    final auth = ref.read(authControllerProvider);
    if (auth.accessToken == null) {
      setState(() => _error = 'Please sign in first');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final code =
      await ref.read(authControllerProvider.notifier).generateRecoveryCode();
      setState(() => _code = code);
    } catch (_) {
      setState(() => _error = 'Could not get a recovery code');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _copy() async {
    if (_code == null) return;
    await Clipboard.setData(ClipboardData(text: _code!.code));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recovery code')),
      body: Padding(
        padding: const EdgeInsets.all(TdxSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your recovery code lets you reset your password without email or SMS. '
                  'Store it safely. It may be shown only once.',
            ),
            const SizedBox(height: 16),
            if (_error != null) ...[
              Text(
                _error!,
                style:
                TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 8),
            ],
            if (_code != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: SelectableText(
                  _code!.code,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(letterSpacing: 2),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _copy, child: const Text('Copy')),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: _loading ? null : _generate,
              child: _loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Generate recovery code'),
            ),
          ],
        ),
      ),
    );
  }
}
