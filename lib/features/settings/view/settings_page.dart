import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';                    // +++
import '../../profile/controller/profile_controller.dart';
import '../../auth/controller/auth_controller.dart';           // +++

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
    final profile = ref.read(profileControllerProvider.notifier);
    final auth = ref.read(authControllerProvider.notifier);    // +++

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Username ---
          TextField(
            controller: _usernameCtrl,
            decoration: const InputDecoration(labelText: 'Username (@handle)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final v = _usernameCtrl.text.trim();
              if (v.isEmpty) return;
              final messenger = ScaffoldMessenger.of(context);
              await profile.changeUsername(v);
              messenger.showSnackBar(const SnackBar(content: Text('Username updated')));
            },
            child: const Text('Update username'),
          ),

          const SizedBox(height: 12),

          // --- Avatar ---
          TextField(
            controller: _avatarCtrl,
            decoration: const InputDecoration(labelText: 'Avatar URL'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final v = _avatarCtrl.text.trim();
              if (v.isEmpty) return;
              final messenger = ScaffoldMessenger.of(context);
              await profile.changeAvatar(v);
              messenger.showSnackBar(const SnackBar(content: Text('Avatar updated')));
            },
            child: const Text('Update avatar'),
          ),

          const SizedBox(height: 12),

          // --- Password ---
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
              final messenger = ScaffoldMessenger.of(context);
              final np = _newPwdCtrl.text.trim();
              if (np.length < 8) {
                messenger.showSnackBar(const SnackBar(content: Text('Password must be at least 8 chars')));
                return;
              }
              await profile.changePassword(_oldPwdCtrl.text, np);
              _oldPwdCtrl.clear();
              _newPwdCtrl.clear();
              messenger.showSnackBar(const SnackBar(content: Text('Password updated')));
            },
            child: const Text('Update password'),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // --- Sign out ---
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Sign out?'),
                  content: const Text('You will need to sign in again.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Sign out')),
                  ],
                ),
              );
              if (confirm != true) return;

              await auth.signOut();              // efface tokens + ping /logout
              if (!mounted) return;
              context.go('/login');              // navigation immédiate
            },
          ),
        ],
      ),
    );
  }
}
