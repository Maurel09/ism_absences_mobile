# 📱 ISM Absences Mobile

## 📋 Description
Application mobile Flutter pour la gestion des absences de l'Institut Supérieur de Management (ISM). Permet aux étudiants de consulter leurs absences et aux gardiens de pointer les présences.

## 🚀 Technologies Utilisées
- **Framework** : Flutter 3.8+
- **Language** : Dart
- **State Management** : GetX
- **HTTP Client** : Dio
- **Local Storage** : SharedPreferences
- **Date Formatting** : Intl

## 🏗️ Architecture
L'application suit une architecture modulaire avec GetX :
- **Modules** : Organisation par fonctionnalités
- **Controllers** : Gestion d'état avec GetX
- **Services** : Logique métier et appels API
- **Data** : Modèles et sources de données
- **Routes** : Navigation et routage

## 📦 Installation

### Prérequis
- Flutter SDK 3.8+
- Dart SDK
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Configuration
1. **Cloner le dépôt**
```bash
git clone https://github.com/VOTRE_USERNAME/ism_absences_mobile.git
cd ism_absences_mobile
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration de l'API**
```bash
# Modifier l'URL de l'API dans les services
# Par défaut : http://localhost:3000/api
```

4. **Lancer l'application**
```bash
# Sur émulateur Android
flutter run

# Sur appareil physique
flutter run -d <device-id>

# Build de production
flutter build apk --release
```

## 👥 Rôles Utilisateurs
- **STUDENT** : Consultation des absences et justifications
- **GUARD** : Pointage des présences/absences

## 📱 Fonctionnalités
- ✅ Authentification sécurisée
- ✅ Consultation des absences
- ✅ Système de pointage (gardien)
- ✅ Justifications avec upload
- ✅ Interface responsive
- ✅ Design cohérent ISM
- ✅ Gestion d'état optimisée

## 🏆 Points Forts
- Architecture modulaire avec GetX
- Interface utilisateur moderne
- Performance optimisée
- Code maintenable
- Compatible Android/iOS

## 📁 Structure du Projet
```
lib/
├── app/
│   ├── data/          # Modèles et sources de données
│   ├── modules/       # Modules par fonctionnalité
│   │   ├── auth/      # Authentification
│   │   ├── dashboard/ # Tableau de bord
│   │   ├── absences/  # Gestion des absences
│   │   └── profile/   # Profil utilisateur
│   ├── routes/        # Configuration des routes
│   └── widgets/       # Widgets réutilisables
└── main.dart          # Point d'entrée
```

## 🔧 Scripts Disponibles
- `flutter pub get` : Installer les dépendances
- `flutter run` : Lancer en mode debug
- `flutter build apk` : Build APK Android
- `flutter build ios` : Build iOS
- `flutter test` : Exécuter les tests

## 🎨 Design
L'application utilise le design system de l'ISM avec :
- Couleurs institutionnelles
- Typographie cohérente
- Composants réutilisables
- Interface responsive

## 📱 Captures d'écran
*Ajoutez ici des captures d'écran de votre application*

## 🤝 Contribution
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence
Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

**Développé avec ❤️ pour l'ISM**