# Task — Simple To-Do App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This is my first open-source app built with Flutter.  
It started as a simple to-do list, and now includes more features for a complete task management experience.  
*(This app might have errors in some features.)*

---

## ✨ Features
- ➕ Add new tasks  
- ✅ Toggle tasks as done/undone  
- ✏️ Long press to edit or toggle task  
- 💾 Save tasks locally with SharedPreferences (persist until app data is cleared)  
- ℹ️ **InfoPage** → Display app information and features  
- 📂 **BackupPage** → Backup & restore tasks  
- 🏠 **HomePage** → Task management with search and edit  
- ⚙️ **SettingsPage** → Theme selection and data management  
- 🎨 **Theme Settings** → Light/Dark & custom themes  
- 🖊️ **EditTaskDialog** → Edit tasks with date info  
- 📦 **AppInfoProvider** → App version & package details  
- 🖥️ **Linux UI** → Native Yaru design integration  

---

## 📸 Screenshots

| Android - Home (Light) | Android - Edit Task (Dark) | Linux - Home (Light) | Linux - Edit Task (Dark) |
|------------------------|----------------------------|-----------------------|---------------------------|
| ![Android - Home(Light)](https://github.com/BawiCeu16/task/blob/main/assets/screenshorts/android/homepage_light.png?raw=true) | ![Android - Edit Task(Dark)](https://github.com/BawiCeu16/task/blob/main/assets/screenshorts/android/edit_dark.png?raw=true) | ![Linux - Home(Light)](https://github.com/BawiCeu16/task/blob/main/assets/screenshorts/linux/homepage_light%20.png?raw=true) | ![Linux - Edit Task(Dark)](https://github.com/BawiCeu16/task/blob/main/assets/screenshorts/linux/edit_dark.png?raw=true) |

---

## 📱 Supported Devices & Design

- ✅ **Android** → Material 3 Design  
- ✅ **Linux** → Yaru Design (Ubuntu-like native look)  
- ❓ **Others (iOS, Windows, macOS, Web)** → Not tested  

---

## 🚀 Getting Started

```bash
┌──(user㉿kali)-[~]
└─$ git clone https://github.com/BawiCeu16/task.git

┌──(user㉿kali)-[~]
└─$ cd task

┌──(user㉿kali)-[~/task]
└─$ flutter pub get

┌──(user㉿kali)-[~/task]
└─$ flutter run
