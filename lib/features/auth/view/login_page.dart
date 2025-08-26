import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/inputs/tdx_text_field.dart';
import '../../../core/icons/tdx_icons.dart';
import '../../../core/design/tokens.dart';
import '../../auth/controller/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  @override
  void dispose() {
    _usernameCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(v)) {
      return '3-20 chars, letters/numbers/_';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Min length: 8';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = ref.read(authControllerProvider.notifier);
    await auth.login(
      username: _usernameCtl.text.trim(),
      password: _passwordCtl.text,
      router: GoRouter.of(context),
    );
    final err = ref.read(authControllerProvider).error;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(TdxSpace.xl),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TdxTextField(
                    controller: _usernameCtl,
                    label: 'Username',
                    prefix: const Icon(Icons.person_outline),
                    validator: _validateUsername,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TdxTextField(
                    controller: _passwordCtl,
                    label: 'Password',
                    obscure: true,
                    prefix: const Icon(Icons.lock_outline), // si tu veux Icons.lock_outline
                    validator: _validatePassword,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.loading ? null : _submit,
                      child: state.loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Sign in'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.push('/recovery-code'),
                    child: const Text('Generate/Show recovery code'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
