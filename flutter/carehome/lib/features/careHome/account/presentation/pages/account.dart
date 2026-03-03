// lib/features/careHome/account/presentation/screens/account_screen.dart

import 'package:flutter/material.dart';
import '../../../../../../core/data/fakedata.dart';
import '../../../../../core/route/route_name.dart';

class CAReAccountScreen extends StatefulWidget {
  const CAReAccountScreen({super.key});

  @override
  State<CAReAccountScreen> createState() => _CAReAccountScreenState();
}

class _CAReAccountScreenState extends State<CAReAccountScreen> {
  bool _editing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _regCtrl;
  late TextEditingController _managerCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: careHomeAccount.name);
    _emailCtrl = TextEditingController(text: careHomeAccount.email);
    _phoneCtrl = TextEditingController(text: careHomeAccount.phone);
    _addressCtrl = TextEditingController(text: careHomeAccount.address);
    _regCtrl = TextEditingController(text: careHomeAccount.registrationNumber);
    _managerCtrl = TextEditingController(text: careHomeAccount.managerName);
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _regCtrl,
      _managerCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveChanges() {
    careHomeAccount.name = _nameCtrl.text;
    careHomeAccount.email = _emailCtrl.text;
    careHomeAccount.phone = _phoneCtrl.text;
    careHomeAccount.address = _addressCtrl.text;
    careHomeAccount.registrationNumber = _regCtrl.text;
    careHomeAccount.managerName = _managerCtrl.text;
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully ✓'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Page title ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Manage your care home profile',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  if (!_editing)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _editing = true),
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Edit',
                        style: Theme.of(context).textTheme!.bodyMedium,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Reset controllers
                            _nameCtrl.text = careHomeAccount.name;
                            _emailCtrl.text = careHomeAccount.email;
                            _phoneCtrl.text = careHomeAccount.phone;
                            _addressCtrl.text = careHomeAccount.address;
                            _regCtrl.text = careHomeAccount.registrationNumber;
                            _managerCtrl.text = careHomeAccount.managerName;
                            setState(() => _editing = false);
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save_outlined, size: 16),
                          label: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Avatar / Name Banner ─────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          child: Text(
                            careHomeAccount.name.isNotEmpty
                                ? careHomeAccount.name[0].toUpperCase()
                                : 'C',
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_editing)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 14,
                              color: Colors.blue.shade700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      careHomeAccount.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      careHomeAccount.address,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),
                    // ── Stats ────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatChip(
                          label: 'Offers',
                          value: fakeOffers.length.toString(),
                        ),
                        _StatChip(
                          label: 'Active',
                          value: fakeOffers
                              .where((o) => o.isActive)
                              .length
                              .toString(),
                        ),
                        _StatChip(
                          label: 'Applications',
                          value: applications.length.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Form Section ─────────────────────────────────────────────
              _SectionHeader('Care Home Information'),
              const SizedBox(height: 14),

              _FormCard(
                children: [
                  _Field(
                    label: 'Care Home Name',
                    icon: Icons.home_work_outlined,
                    controller: _nameCtrl,
                    editing: _editing,
                  ),
                  _Field(
                    label: 'Registration Number',
                    icon: Icons.badge_outlined,
                    controller: _regCtrl,
                    editing: _editing,
                  ),
                  _Field(
                    label: 'Address',
                    icon: Icons.location_on_outlined,
                    controller: _addressCtrl,
                    editing: _editing,
                    maxLines: 2,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _SectionHeader('Manager Information'),
              const SizedBox(height: 14),

              _FormCard(
                children: [
                  _Field(
                    label: 'Manager Name',
                    icon: Icons.person_outline_rounded,
                    controller: _managerCtrl,
                    editing: _editing,
                  ),
                  _Field(
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: _emailCtrl,
                    editing: _editing,
                  ),
                  _Field(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phoneCtrl,
                    editing: _editing,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Danger Zone ──────────────────────────────────────────────
              _SectionHeader('Account Actions'),
              const SizedBox(height: 14),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _ActionTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'Change Password',
                      iconColor: Colors.blue,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change password tapped')),
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.shade100),
                    _ActionTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notification Preferences',
                      iconColor: Colors.orange,
                      onTap: () {},
                    ),
                    Divider(height: 1, color: Colors.grey.shade100),
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        RouteNames.login,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children:
            children
                .expand(
                  (w) => [w, Divider(height: 1, color: Colors.grey.shade100)],
                )
                .toList()
              ..removeLast(),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool editing;
  final int maxLines;

  const _Field({
    required this.label,
    required this.icon,
    required this.controller,
    required this.editing,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                editing
                    ? TextField(
                        controller: controller,
                        maxLines: maxLines,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                      )
                    : Text(
                        controller.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
