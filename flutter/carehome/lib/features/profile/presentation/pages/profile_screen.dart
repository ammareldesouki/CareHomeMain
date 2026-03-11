import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/colors.dart';
import '../../domain/entities/carehome_profile_entity.dart';
import '../../domain/entities/psw_profile_entity.dart';
import '../manager/profile_bloc.dart';
import '../widgets/carehome_business_section.dart';
import '../widgets/info_section_card.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/psw_verification_section.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String role;

  const ProfileScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(role: role)..add(LoadProfileEvent()),
      child: _ProfileBody(role: role),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final String role;

  const _ProfileBody({required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is ProfileDocumentUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is ProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileUpdating) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: TColors.primary),
                  const SizedBox(height: 16),
                  const Text('Loading profile...'),
                ],
              ),
            ),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfileEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is PswProfileLoaded) {
          return _buildPswProfile(context, state.profile);
        }

        if (state is CareHomeProfileLoaded) {
          return _buildCareHomeProfile(context, state.profile);
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }

  Widget _buildPswProfile(BuildContext context, PswProfileEntity profile) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: TColors.primary,
            title: const Text(
              'My Profile',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _navigateToEdit(context, profile: profile),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProfileHeaderWidget(
                  firstName: profile.firstName,
                  lastName: profile.lastName,
                  email: profile.email,
                  role: 'PSW',
                  isVerified: profile.isVerified,
                ),
                const SizedBox(height: 8),
                InfoSectionCard(
                  title: 'Personal Information',
                  titleIcon: Icons.person_outline,
                  rows: [
                    InfoRowItem(
                      icon: Icons.badge_outlined,
                      label: 'Full Name',
                      value: '${profile.firstName} ${profile.lastName}',
                    ),
                    InfoRowItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    InfoRowItem(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: profile.phoneNumber,
                    ),
                    InfoRowItem(
                      icon: Icons.cake_outlined,
                      label: 'Date of Birth',
                      value: _formatDate(profile.dateOfBirth),
                    ),
                    InfoRowItem(
                      icon: Icons.person_pin_outlined,
                      label: 'Gender',
                      value: profile.gender,
                    ),
                    if (profile.proofIdentityType.isNotEmpty)
                      InfoRowItem(
                        icon: Icons.perm_identity,
                        label: 'ID Type',
                        value: profile.proofIdentityType,
                      ),
                  ],
                ),
                InfoSectionCard(
                  title: 'Address',
                  titleIcon: Icons.location_on_outlined,
                  rows: [
                    InfoRowItem(
                      icon: Icons.home_outlined,
                      label: 'Street',
                      value: profile.address.street,
                    ),
                    InfoRowItem(
                      icon: Icons.apartment,
                      label: 'Apartment',
                      value: profile.address.apartmentNumber > 0
                          ? 'Apt ${profile.address.apartmentNumber}'
                          : '',
                    ),
                    InfoRowItem(
                      icon: Icons.location_city_outlined,
                      label: 'City',
                      value: profile.address.city,
                    ),
                    InfoRowItem(
                      icon: Icons.map_outlined,
                      label: 'State / Province',
                      value: profile.address.state,
                    ),
                    InfoRowItem(
                      icon: Icons.markunread_mailbox_outlined,
                      label: 'Postal Code',
                      value: profile.address.postalCode,
                    ),
                    InfoRowItem(
                      icon: Icons.flag_outlined,
                      label: 'Country',
                      value: profile.address.country,
                    ),
                  ],
                ),
                PswVerificationSection(
                  profile: profile,
                  onUploadDocument: (filePath, documentType) {
                    context.read<ProfileBloc>().add(
                      UpdatePswDocumentEvent(
                        documentType: documentType,
                        filePath: filePath,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareHomeProfile(
    BuildContext context,
    CareHomeProfileEntity profile,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: TColors.primary,
            title: const Text(
              'My Profile',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _navigateToEdit(context, profile: profile),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProfileHeaderWidget(
                  firstName: profile.firstName,
                  lastName: profile.lastName,
                  email: profile.email,
                  role: 'CareHome',
                ),
                const SizedBox(height: 8),
                InfoSectionCard(
                  title: 'Personal Information',
                  titleIcon: Icons.person_outline,
                  rows: [
                    InfoRowItem(
                      icon: Icons.badge_outlined,
                      label: 'Full Name',
                      value: '${profile.firstName} ${profile.lastName}',
                    ),
                    InfoRowItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    InfoRowItem(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: profile.phoneNumber,
                    ),
                    InfoRowItem(
                      icon: Icons.cake_outlined,
                      label: 'Date of Birth',
                      value: _formatDate(profile.dateOfBirth),
                    ),
                    InfoRowItem(
                      icon: Icons.person_pin_outlined,
                      label: 'Gender',
                      value: profile.gender,
                    ),
                  ],
                ),
                CareHomeBusinessSection(profile: profile),
                InfoSectionCard(
                  title: 'Address',
                  titleIcon: Icons.location_on_outlined,
                  rows: [
                    InfoRowItem(
                      icon: Icons.home_outlined,
                      label: 'Street',
                      value: profile.address.street,
                    ),
                    InfoRowItem(
                      icon: Icons.apartment,
                      label: 'Apartment',
                      value: profile.address.apartmentNumber > 0
                          ? 'Apt ${profile.address.apartmentNumber}'
                          : '',
                    ),
                    InfoRowItem(
                      icon: Icons.location_city_outlined,
                      label: 'City',
                      value: profile.address.city,
                    ),
                    InfoRowItem(
                      icon: Icons.map_outlined,
                      label: 'State / Province',
                      value: profile.address.state,
                    ),
                    InfoRowItem(
                      icon: Icons.markunread_mailbox_outlined,
                      label: 'Postal Code',
                      value: profile.address.postalCode,
                    ),
                    InfoRowItem(
                      icon: Icons.flag_outlined,
                      label: 'Country',
                      value: profile.address.country,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(BuildContext context, {required dynamic profile}) {
    final bloc = context.read<ProfileBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          role: role,
          profile: profile,
          onSave: (data) {
            if (role == 'PSW') {
              bloc.add(UpdatePswProfileEvent(data));
            } else {
              bloc.add(UpdateCareHomeProfileEvent(data));
            }
          },
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}
