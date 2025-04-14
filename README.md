# 📝 Smart Notes App

A clean and minimal note-taking Flutter app with search functionality, markdown support, swipe-to-delete with undo, and Firebase/Firestore (optional). Built with clean UI and provider-based state management.

---

## 🚀 Features

- 📚 Create, edit, and delete notes
- 🖍️ Color-coded notes for organization
- 🔍 Search notes by title/content
- 🧹 Swipe-to-delete with undo option
- 🖋️ Markdown support for formatting
- ☁️ Firestore backend (optional)
- 📦 Optimized APK (split by ABI, compressed assets)

---

## 📱 Screenshots

| Home Screen | Editor Screen | Search |
|-------------|---------------|--------|
| (Insert here) | (Insert here) | (Insert here) |

---

## 🔧 Tech Stack

- Flutter 3.x
- Provider for state management
- Google Fonts
- Firestore (Optional for cloud sync)

---

## 🛠️ How to Run
git clone https://github.com/your-username/smart-notes.git
cd smart-notes
flutter pub get
flutter run
📦 Reduce APK Size
To keep the app lightweight:

✅ Build Split APKs:
flutter build apk --split-per-abi
This creates:

app-arm64-v8a-release.apk

app-armeabi-v7a-release.apk

✅ Enable Shrinking & ProGuard
Edit android/app/build.gradle:

gradle
Copy
Edit
buildTypes {
    release {
        shrinkResources true
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}

✅ Analyze APK Size
flutter build apk --analyze-size
📂 Directory Structure
lib/
├── models/         # Note model
├── providers/      # Notes provider
├── screens/        # Home, Editor
├── widgets/        # Reusable components like NoteCard
└── main.dart       # Entry point


🤝 Contributing
Feel free to fork, clone, or raise issues! Pull Requests are welcome.

📃 License
MIT License

🙌 Made with ❤️ by Sathish







