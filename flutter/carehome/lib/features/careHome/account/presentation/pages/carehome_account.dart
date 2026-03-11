import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/route/route_name.dart';
import '../../../../auth/presentation/manager/auth_bloc.dart';
import '../../../../profile/domain/entities/carehome_profile_entity.dart';
import '../../../../profile/presentation/manager/profile_bloc.dart';
import '../../../../profile/presentation/pages/edit_profile_screen.dart';

class CAReAccountScreen extends StatelessWidget {
  const CAReAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc(role: 'CareHome')..add(LoadProfileEvent()),
        ),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: const _CareHomeAccountBody(),
    );
  }
}

class _CareHomeAccountBody extends StatelessWidget {
  const _CareHomeAccountBody();

  static const _gradientStart = Color(0xFF1A73E8);
  static const _gradientEnd = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthLoggedOut) {
          Navigator.pushReplacementNamed(context, RouteNames.login);
        }
      },
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile updated successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
          if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              backgroundColor: Color(0xFFF4F6FB),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProfileError) {
            return Scaffold(
              backgroundColor: const Color(0xFFF4F6FB),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<ProfileBloc>().add(LoadProfileEvent()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final CareHomeProfileEntity? profile = state is CareHomeProfileLoaded
              ? state.profile
              : null;

          if (profile == null) {
            return const Scaffold(
              backgroundColor: Color(0xFFF4F6FB),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FB),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero Banner ────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_gradientStart, _gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(36),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Top row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Row(
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
                              _HeaderBtn(
                                label: 'Edit',
                                icon: Icons.edit_outlined,
                                onTap: () {
                                  final bloc = context.read<ProfileBloc>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditProfileScreen(
                                        role: 'CareHome',
                                        profile: profile,
                                        onSave: (data) => bloc.add(
                                          UpdateCareHomeProfileEvent(data),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Avatar with initials
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            profile.firstName.isNotEmpty
                                ? profile.firstName[0].toUpperCase()
                                : 'C',
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${profile.firstName} ${profile.lastName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.home_work,
                                color: Colors.white,
                                size: 13,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Care Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // ── Stats row ───────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              label: 'License',
                              value: profile.businessLicense,
                            ),
                            _VertDivider(),
                            _StatItem(
                              label: 'Legal Entity',
                              value: profile.legalName,
                            ),
                            _VertDivider(),
                            _StatItem(
                              label: 'Vaccination',
                              value: profile.vaccinationPolicy,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Personal Information ──────────────────────────
                        _SectionHeader('Personal Information'),
                        const SizedBox(height: 12),
                        _FormCard(
                          children: [
                            _InfoField(
                              label: 'Full Name',
                              value: '${profile.firstName} ${profile.lastName}',
                              icon: Icons.person_outline_rounded,
                            ),
                            _InfoField(
                              label: 'Email',
                              value: profile.email,
                              icon: Icons.email_outlined,
                            ),
                            _InfoField(
                              label: 'Phone',
                              value: profile.phoneNumber,
                              icon: Icons.phone_outlined,
                            ),
                            _InfoField(
                              label: 'Date of Birth',
                              value: _formatDate(profile.dateOfBirth),
                              icon: Icons.cake_outlined,
                            ),
                            _InfoField(
                              label: 'Gender',
                              value: profile.gender,
                              icon: Icons.person_pin_outlined,
                            ),
                          ],
                        ),

                        // ── Business Information ──────────────────────────
                        const SizedBox(height: 20),
                        _SectionHeader('Business Information'),
                        const SizedBox(height: 12),
                        _FormCard(
                          children: [
                            _StatusField(
                              label: 'Business License',
                              status: profile.businessLicense,
                              icon: Icons.badge_outlined,
                            ),
                            _StatusField(
                              label: 'Legal Entity Name',
                              status: profile.legalName,
                              icon: Icons.account_balance_outlined,
                            ),
                            _StatusField(
                              label: 'Vaccination Policy',
                              status: profile.vaccinationPolicy,
                              icon: Icons.health_and_safety_outlined,
                            ),
                          ],
                        ),

                        // ── Address ───────────────────────────────────────
                        const SizedBox(height: 20),
                        _SectionHeader('Address'),
                        const SizedBox(height: 12),
                        _FormCard(
                          children: [
                            _InfoField(
                              label: 'Street',
                              value: profile.address.street,
                              icon: Icons.home_outlined,
                            ),
                            if (profile.address.apartmentNumber > 0)
                              _InfoField(
                                label: 'Apartment',
                                value: 'Apt ${profile.address.apartmentNumber}',
                                icon: Icons.apartment,
                              ),
                            _InfoField(
                              label: 'City',
                              value: profile.address.city,
                              icon: Icons.location_city_outlined,
                            ),
                            _InfoField(
                              label: 'State',
                              value: profile.address.state,
                              icon: Icons.map_outlined,
                            ),
                            _InfoField(
                              label: 'Postal Code',
                              value: profile.address.postalCode,
                              icon: Icons.markunread_mailbox_outlined,
                            ),
                            _InfoField(
                              label: 'Country',
                              value: profile.address.country,
                              icon: Icons.flag_outlined,
                            ),
                          ],
                        ),

                        // ── Account Actions ───────────────────────────────
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
                                icon: Icons.lock_outline_rounded,
                                label: 'Change Password',
                                color: _gradientStart,
                                onTap: () {},
                              ),
                              Divider(height: 1, color: Colors.grey.shade100),
                              _ActionTile(
                                icon: Icons.notifications_outlined,
                                label: 'Notifications',
                                color: _gradientStart,
                                onTap: () {},
                              ),
                              Divider(height: 1, color: Colors.grey.shade100),
                              _ActionTile(
                                icon: Icons.logout_rounded,
                                label: 'Sign Out',
                                color: Colors.red,
                                textColor: Colors.red,
                                onTap: () =>
                                    context.read<AuthBloc>().add(LogoutEvent()),
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
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '—';
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }
}

// ── Reusable Widgets ──────────────────────────────────────────────────────────

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
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 30, width: 1, color: Colors.white.withOpacity(0.2));
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  );
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

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoField({
    required this.label,
    required this.value,
    required this.icon,
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
                Text(
                  value.isNotEmpty ? value : '—',
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

class _StatusField extends StatelessWidget {
  final String label;
  final String status;
  final IconData icon;

  const _StatusField({
    required this.label,
    required this.status,
    required this.icon,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return Colors.green;
      case 'rejected':
      case 'expired':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
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
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusBadgeIcon, size: 11, color: _statusColor),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: _statusColor,
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

  IconData get _statusBadgeIcon {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return Icons.check_circle;
      case 'rejected':
      case 'expired':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
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
