import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'guard_controller.dart';
import '../auth/auth_controller.dart';

class GuardDashboardView extends GetView<GuardController> {
  const GuardDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Vigile'),
        backgroundColor: const Color(0xFF442A1B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Padding(
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
                    'Enregistrez les présences des étudiants',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pointage Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pointage Étudiant',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF442A1B),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Student ID Field
                    TextField(
                      controller: controller.studentIdController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'ID de l\'étudiant',
                        hintText: 'Saisissez l\'ID de l\'étudiant',
                        prefixIcon: const Icon(Icons.person),
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
                    const SizedBox(height: 20),

                    // Status Selection
                    const Text(
                      'Statut:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF442A1B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: _buildStatusButton(
                            'PRESENT',
                            'Présent',
                            Icons.check_circle,
                            Colors.green,
                            controller.selectedStatus.value == 'PRESENT',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusButton(
                            'ABSENT',
                            'Absent',
                            Icons.person_off,
                            Colors.red,
                            controller.selectedStatus.value == 'ABSENT',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusButton(
                            'LATE',
                            'En retard',
                            Icons.schedule,
                            Colors.orange,
                            controller.selectedStatus.value == 'LATE',
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 20),

                    // Course Selection
                    const Text(
                      'Cours:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF442A1B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedCourseId.value.isEmpty 
                              ? null 
                              : controller.selectedCourseId.value,
                          hint: const Text('Sélectionnez un cours'),
                          isExpanded: true,
                          items: controller.courses.map((course) {
                            return DropdownMenuItem<String>(
                              value: course.id,
                              child: Text(course.displayName),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              controller.setCourse(value);
                            }
                          },
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),

                    // Error Message
                    Obx(() => controller.errorMessage.value.isNotEmpty
                        ? Container(
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
                          )
                        : const SizedBox.shrink()),

                    // Success Message
                    Obx(() => controller.successMessage.value.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              controller.successMessage.value,
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink()),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.createPointage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD17E1F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Enregistrer le Pointage',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF442A1B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Saisissez l\'ID de l\'étudiant\n'
                      '• Sélectionnez le statut (Présent, Absent, En retard)\n'
                      '• Sélectionnez le cours concerné\n'
                      '• Cliquez sur "Enregistrer le Pointage"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status, String label, IconData icon, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setStatus(status),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
