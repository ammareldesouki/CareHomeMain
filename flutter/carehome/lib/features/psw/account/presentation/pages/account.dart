// lib/features/psw/presentation/screens/psw_account_screen.dart

import 'package:carehome/core/route/route_name.dart';
import 'package:flutter/material.dart';

import '../../../../../core/data/fakedata.dart';

class PswAccountScreen extends StatefulWidget {
  const PswAccountScreen({super.key});

  @override
  State<PswAccountScreen> createState() => _PswAccountScreenState();
}

class _PswAccountScreenState extends State<PswAccountScreen> {
  bool _editing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _expCtrl;
  late TextEditingController _qualCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: pswProfile.name);
    _emailCtrl = TextEditingController(text: pswProfile.email);
    _phoneCtrl = TextEditingController(text: pswProfile.phone);
    _addressCtrl = TextEditingController(text: pswProfile.address);
    _expCtrl = TextEditingController(text: pswProfile.experience);
    _qualCtrl = TextEditingController(text: pswProfile.qualifications);
    _bioCtrl = TextEditingController(text: pswProfile.bio);
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _expCtrl,
      _qualCtrl,
      _bioCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    pswProfile.name = _nameCtrl.text;
    pswProfile.email = _emailCtrl.text;
    pswProfile.phone = _phoneCtrl.text;
    pswProfile.address = _addressCtrl.text;
    pswProfile.experience = _expCtrl.text;
    pswProfile.qualifications = _qualCtrl.text;
    pswProfile.bio = _bioCtrl.text;
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated ✓'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accepted = appliedJobs.where((j) => j.status == 'accepted').length;
    final pending = appliedJobs.where((j) => j.status == 'pending').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Hero Banner ────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    // Top row
                    Row(
                      children: [
                        const Text(
                          'My Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        if (!_editing)
                          _HeaderBtn(
                            label: 'Edit',
                            icon: Icons.edit_outlined,
                            onTap: () => setState(() => _editing = true),
                          )
                        else
                          Row(
                            children: [
                              _HeaderBtn(
                                label: 'Cancel',
                                icon: Icons.close,
                                onTap: () {
                                  _nameCtrl.text = pswProfile.name;
                                  _emailCtrl.text = pswProfile.email;
                                  _phoneCtrl.text = pswProfile.phone;
                                  _addressCtrl.text = pswProfile.address;
                                  _expCtrl.text = pswProfile.experience;
                                  _qualCtrl.text = pswProfile.qualifications;
                                  _bioCtrl.text = pswProfile.bio;
                                  setState(() => _editing = false);
                                },
                              ),
                              const SizedBox(width: 8),
                              _HeaderBtn(
                                label: 'Save',
                                icon: Icons.save_outlined,
                                onTap: _save,
                                filled: true,
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            pswProfile.name.isNotEmpty
                                ? pswProfile.name[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_editing)
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 15,
                              color: const Color(0xFF1A73E8),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Text(
                      pswProfile.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pswProfile.qualifications,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // ── Stats ────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          label: 'Shifts Done',
                          value: pswProfile.completedShifts.toString(),
                        ),
                        _VertDivider(),
                        _StatItem(
                          label: 'Rating',
                          value: '${pswProfile.rating}⭐',
                        ),
                        _VertDivider(),
                        _StatItem(
                          label: 'Accepted',
                          value: accepted.toString(),
                        ),
                        _VertDivider(),
                        _StatItem(label: 'Pending', value: pending.toString()),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Form ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bio
                    if (!_editing) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.format_quote_rounded,
                                  color: Colors.blue.shade300,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'About Me',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pswProfile.bio,
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontSize: 13.5,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    _SectionHeader('Personal Information'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _Field(
                          label: 'Full Name',
                          icon: Icons.person_outline_rounded,
                          ctrl: _nameCtrl,
                          editing: _editing,
                        ),
                        _Field(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          ctrl: _emailCtrl,
                          editing: _editing,
                        ),
                        _Field(
                          label: 'Phone',
                          icon: Icons.phone_outlined,
                          ctrl: _phoneCtrl,
                          editing: _editing,
                        ),
                        _Field(
                          label: 'Address',
                          icon: Icons.location_on_outlined,
                          ctrl: _addressCtrl,
                          editing: _editing,
                          maxLines: 2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionHeader('Professional Details'),
                    const SizedBox(height: 12),
                    _FormCard(
                      children: [
                        _Field(
                          label: 'Experience',
                          icon: Icons.work_history_outlined,
                          ctrl: _expCtrl,
                          editing: _editing,
                        ),
                        _Field(
                          label: 'Qualifications',
                          icon: Icons.school_outlined,
                          ctrl: _qualCtrl,
                          editing: _editing,
                        ),
                        if (_editing)
                          _Field(
                            label: 'Bio',
                            icon: Icons.format_quote_rounded,
                            ctrl: _bioCtrl,
                            editing: _editing,
                            maxLines: 4,
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionHeader('Account'),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _ActionTile(
                            icon: Icons.description,
                            label: 'Documentations',
                            color: Colors.purpleAccent,
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteNames.pswVerification,
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          _ActionTile(
                            icon: Icons.lock_outline_rounded,
                            label: 'Change Password',
                            color: Colors.blue,
                            onTap: () {},
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          _ActionTile(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            color: Colors.orange,
                            onTap: () {},
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          _ActionTile(
                            icon: Icons.logout_rounded,
                            label: 'Sign Out',
                            color: Colors.red,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _HeaderBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? Colors.white : Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: filled ? const Color(0xFF1A73E8) : Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: filled ? const Color(0xFF1A73E8) : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.2),
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
  final TextEditingController ctrl;
  final bool editing;
  final int maxLines;

  const _Field({
    required this.label,
    required this.icon,
    required this.ctrl,
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
              color: const Color(0xFF1A73E8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
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
                        controller: ctrl,
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
                          fillColor: const Color(0xFF1A73E8).withOpacity(0.04),
                        ),
                      )
                    : Text(
                        ctrl.text,
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
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
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
