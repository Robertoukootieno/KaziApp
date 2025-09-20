import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/service_provider_registration.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../providers/registration_providers.dart';

class RegistrationDetailsDialog extends ConsumerStatefulWidget {
  final ServiceProviderRegistration registration;

  const RegistrationDetailsDialog({
    super.key,
    required this.registration,
  });

  @override
  ConsumerState<RegistrationDetailsDialog> createState() => _RegistrationDetailsDialogState();
}

class _RegistrationDetailsDialogState extends ConsumerState<RegistrationDetailsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _notesController = TextEditingController();
  final _rejectionReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    _rejectionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 800),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildDocumentsTab(),
                  _buildActionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Text(
              '${widget.registration.firstName[0]}${widget.registration.lastName[0]}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.registration.firstName} ${widget.registration.lastName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.registration.businessName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.registration.status.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.registration.status.icon,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.registration.status.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Basic Information'),
          Tab(text: 'Documents'),
          Tab(text: 'Actions'),
        ],
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            'Personal Information',
            [
              _buildInfoRow('Full Name', '${widget.registration.firstName} ${widget.registration.lastName}'),
              _buildInfoRow('Email', widget.registration.email),
              _buildInfoRow('Phone Number', widget.registration.phoneNumber),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            'Business Information',
            [
              _buildInfoRow('Business Name', widget.registration.businessName),
              _buildInfoRow('Service Type', widget.registration.serviceType),
              _buildInfoRow('Description', widget.registration.businessDescription),
              _buildInfoRow('Address', widget.registration.businessAddress),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            'Location',
            [
              _buildInfoRow('County', widget.registration.county),
              _buildInfoRow('Sub County', widget.registration.subCounty),
              _buildInfoRow('Ward', widget.registration.ward),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            'Registration Details',
            [
              _buildInfoRow('Has Business License', widget.registration.hasBusinessLicense ? 'Yes' : 'No'),
              _buildInfoRow('Is Registered Business', widget.registration.isRegisteredBusiness ? 'Yes' : 'No'),
              if (widget.registration.businessLicense != null)
                _buildInfoRow('Business License Number', widget.registration.businessLicense!),
              if (widget.registration.taxPin != null)
                _buildInfoRow('KRA PIN', widget.registration.taxPin!),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            'Submission Details',
            [
              _buildInfoRow('Submitted At', _formatDateTime(widget.registration.submittedAt)),
              if (widget.registration.reviewedAt != null)
                _buildInfoRow('Reviewed At', _formatDateTime(widget.registration.reviewedAt!)),
              if (widget.registration.reviewedBy != null)
                _buildInfoRow('Reviewed By', widget.registration.reviewedBy!),
              if (widget.registration.adminNotes != null)
                _buildInfoRow('Admin Notes', widget.registration.adminNotes!),
              if (widget.registration.rejectionReason != null)
                _buildInfoRow('Rejection Reason', widget.registration.rejectionReason!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final documentsAsync = ref.watch(registrationDocumentsProvider(widget.registration.id));

        return documentsAsync.when(
          data: (documents) => _buildDocumentsList(documents),
          loading: () => const LoadingWidget(),
          error: (error, stack) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(registrationDocumentsProvider(widget.registration.id)),
          ),
        );
      },
    );
  }

  Widget _buildDocumentsList(List<RegistrationDocument> documents) {
    if (documents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No documents uploaded',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildDocumentCard(RegistrationDocument document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                document.type.icon,
                size: 24,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.type.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    document.fileName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Uploaded: ${_formatDateTime(document.uploadedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadDocument(document),
                  tooltip: 'Download',
                ),
                if (document.status == DocumentStatus.pending)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _verifyDocument(document.id, true),
                        tooltip: 'Verify',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _verifyDocument(document.id, false),
                        tooltip: 'Reject',
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsTab() {
    if (widget.registration.status != RegistrationStatus.pending) {
      return const Center(
        child: Text(
          'No actions available for this registration',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionCard(
            'Approve Registration',
            'Approve this service provider registration',
            Icons.check_circle,
            Colors.green,
            () => _showApprovalDialog(),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            'Reject Registration',
            'Reject this service provider registration',
            Icons.cancel,
            Colors.red,
            () => _showRejectionDialog(),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            'Request Additional Information',
            'Request more information from the service provider',
            Icons.info,
            Colors.orange,
            () => _showAdditionalInfoDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _downloadDocument(RegistrationDocument document) {
    // Implement document download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${document.fileName}...')),
    );
  }

  void _verifyDocument(String documentId, bool isVerified) async {
    try {
      await ref.read(registrationActionsProvider).verifyDocument(
        documentId,
        isVerified: isVerified,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isVerified ? 'Document verified' : 'Document rejected'),
            backgroundColor: isVerified ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to verify document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showApprovalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to approve this registration?'),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _approveRegistration(),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: _rejectionReasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _rejectRegistration(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showAdditionalInfoDialog() {
    // Implementation for requesting additional information
  }

  void _approveRegistration() async {
    try {
      await ref.read(registrationActionsProvider).approveRegistration(
        widget.registration.id,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.of(context).pop(); // Close details dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration approved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve registration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _rejectRegistration() async {
    if (_rejectionReasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rejection reason'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(registrationActionsProvider).rejectRegistration(
        widget.registration.id,
        reason: _rejectionReasonController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.of(context).pop(); // Close details dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration rejected'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject registration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
