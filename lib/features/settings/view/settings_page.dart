import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/controller/profile_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _usernameCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();
  final _oldPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = ref.read(profileControllerProvider);
    _usernameCtrl.text = s.username;
    _avatarCtrl.text = s.avatarUrl ?? '';
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _avatarCtrl.dispose();
    _oldPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _usernameCtrl,
            decoration: const InputDecoration(labelText: 'Username (@handle)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final v = _usernameCtrl.text.trim();
              if (v.isEmpty) return;
              await c.changeUsername(v);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Username updated')),
              );
            },
            child: const Text('Update username'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _avatarCtrl,
            decoration: const InputDecoration(labelText: 'Avatar URL'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final v = _avatarCtrl.text.trim();
              if (v.isEmpty) return;
              await c.changeAvatar(v);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Avatar updated')),
              );
            },
            child: const Text('Update avatar'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _oldPwdCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Old password'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newPwdCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New password (>=8)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final np = _newPwdCtrl.text.trim();
              if (np.length < 8) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password must be at least 8 chars'),
                  ),
                );
                return;
              }
              await c.changePassword(_oldPwdCtrl.text, np);
              _oldPwdCtrl.clear();
              _newPwdCtrl.clear();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated')),
              );
            },
            child: const Text('Update password'),
          ),
        ],
      ),
    );
  }
}
