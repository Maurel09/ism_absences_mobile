import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'student_controller.dart';
import '../auth/auth_controller.dart';
import '../../widgets/logo_widget.dart';

class StudentDashboardView extends GetView<StudentController> {
  const StudentDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const LogoWidget(
              size: 32.0,
              showText: false,
            ),
            const SizedBox(width: 12),
            const Text('Tableau de Bord Étudiant'),
          ],
        ),
        backgroundColor: const Color(0xFF442A1B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD17E1F)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF442A1B), Color(0xFFD17E1F)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour, ${authController.currentUser.value?.firstName ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Voici un résumé de vos absences et justifications',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Absences',
                        controller.totalAbsences.toString(),
                        Colors.red,
                        Icons.person_off,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Retards',
                        controller.totalLates.toString(),
                        Colors.orange,
                        Icons.schedule,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'En attente',
                        controller.pendingJustifications.toString(),
                        Colors.blue,
                        Icons.pending,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Error Message
                if (controller.errorMessage.value.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),


                // Absences List
                const Text(
                  'Historique des Absences',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF442A1B),
                  ),
                ),
                const SizedBox(height: 16),
                ...controller.paginatedAbsences.map((absence) => _buildAbsenceCard(absence)),
                
                // Absences Pagination
                if (controller.totalAbsencePages > 1) ...[
                  const SizedBox(height: 16),
                  _buildPagination(
                    currentPage: controller.currentAbsencePage.value,
                    totalPages: controller.totalAbsencePages,
                    onPrevious: controller.previousAbsencePage,
                    onNext: controller.nextAbsencePage,
                  ),
                ],
                
                const SizedBox(height: 24),

                // Justifications List
                const Text(
                  'Mes Justifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF442A1B),
                  ),
                ),
                const SizedBox(height: 16),
                ...controller.paginatedJustifications.map((justification) => _buildJustificationCard(justification)),
                
                // Justifications Pagination
                if (controller.totalJustificationPages > 1) ...[
                  const SizedBox(height: 16),
                  _buildPagination(
                    currentPage: controller.currentJustificationPage.value,
                    totalPages: controller.totalJustificationPages,
                    onPrevious: controller.previousJustificationPage,
                    onNext: controller.nextJustificationPage,
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsenceCard(absence) {
    // Vérifier si cette absence a déjà une justification
    final hasJustification = controller.justifications.any(
      (justification) => justification.absenceId == absence.id,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: absence.isAbsent
                      ? Colors.red
                      : absence.isLate
                          ? Colors.orange
                          : Colors.green,
                  child: Icon(
                    absence.isAbsent
                        ? Icons.person_off
                        : absence.isLate
                            ? Icons.schedule
                            : Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        absence.statusDisplayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF442A1B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy à HH:mm').format(absence.date),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      if (absence.course != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          absence.course!.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD17E1F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: absence.isAbsent
                        ? Colors.red.shade100
                        : absence.isLate
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    absence.statusDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: absence.isAbsent
                          ? Colors.red.shade700
                          : absence.isLate
                              ? Colors.orange.shade700
                              : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            // Bouton de justification (seulement pour les absences et retards)
            if ((absence.isAbsent || absence.isLate) && !hasJustification) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showJustificationDialog(absence),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD17E1F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit_note, size: 18),
                  label: const Text(
                    'Justifier cette absence',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            // Indicateur si déjà justifié
            if (hasJustification) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.blue.shade600, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Justification envoyée',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJustificationCard(justification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    justification.reason,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: justification.isPending
                        ? Colors.blue.shade100
                        : justification.isApproved
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    justification.statusDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: justification.isPending
                          ? Colors.blue.shade700
                          : justification.isApproved
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Envoyée le ${DateFormat('dd/MM/yyyy à HH:mm').format(justification.createdAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            if (justification.adminNote != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Note admin: ${justification.adminNote}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showJustificationDialog(absence) {
    final reasonController = TextEditingController();
    final List<Map<String, dynamic>> attachments = [];

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.edit_note, color: const Color(0xFFD17E1F)),
                  const SizedBox(width: 8),
                  const Text('Justifier l\'absence'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations sur l'absence
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Absence du ${DateFormat('dd/MM/yyyy à HH:mm').format(absence.date)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (absence.course != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              absence.course!.displayName,
                              style: const TextStyle(
                                color: Color(0xFFD17E1F),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Champ de raison
                    const Text(
                      'Raison de l\'absence *',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: reasonController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Expliquez la raison de votre absence...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFD17E1F),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Section des fichiers
                    const Text(
                      'Pièces jointes (optionnel)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Liste des fichiers attachés
                    if (attachments.isNotEmpty) ...[
                      ...attachments.map((file) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.attach_file, color: Colors.blue.shade600, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                file['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red.shade600, size: 16),
                              onPressed: () {
                                setState(() {
                                  attachments.remove(file);
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 8),
                    ],
                    
                    // Bouton d'ajout de fichier
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _pickFile(setState, attachments),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD17E1F)),
                          foregroundColor: const Color(0xFFD17E1F),
                        ),
                        icon: const Icon(Icons.attach_file, size: 18),
                        label: const Text('Ajouter un fichier'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: reasonController.text.trim().isEmpty
                      ? null
                      : () {
                          _submitJustification(
                            absence,
                            reasonController.text.trim(),
                            attachments,
                          );
                          Navigator.of(context).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD17E1F),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Envoyer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _pickFile(StateSetter setState, List<Map<String, dynamic>> attachments) {
    // Pour l'instant, on simule l'ajout d'un fichier
    // Dans une vraie implémentation, on utiliserait file_picker
    final fileName = 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';
    setState(() {
      attachments.add({
        'name': fileName,
        'url': '/uploads/$fileName',
        'type': 'application/pdf',
      });
    });
    
    Get.snackbar(
      'Fichier ajouté',
      'Le fichier $fileName a été ajouté',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _submitJustification(absence, String reason, List<Map<String, dynamic>> attachments) {
    // Créer la justification avec les attachments
    final attachmentsJson = attachments.isNotEmpty 
        ? attachments.map((file) => {
            'name': file['name'],
            'url': file['url'],
            'type': file['type'],
          }).toList()
        : null;

    controller.createJustificationForAbsence(
      absence.id,
      reason,
      attachmentsJson,
    );
  }

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          ElevatedButton.icon(
            onPressed: currentPage > 1 ? onPrevious : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPage > 1 ? const Color(0xFF442A1B) : Colors.grey.shade300,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.chevron_left, size: 18),
            label: const Text('Précédent', style: TextStyle(fontSize: 12)),
          ),
          
          // Page info
          Text(
            'Page $currentPage sur $totalPages',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF442A1B),
            ),
          ),
          
          // Next button
          ElevatedButton.icon(
            onPressed: currentPage < totalPages ? onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPage < totalPages ? const Color(0xFFD17E1F) : Colors.grey.shade300,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.chevron_right, size: 18),
            label: const Text('Suivant', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
