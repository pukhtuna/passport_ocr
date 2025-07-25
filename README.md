# Passport OCR Scanner (Flutter)

A Flutter app that scans passports using offline OCR, extracts MRZ (Machine Readable Zone) data, and displays it in a readable format.

This project uses Google's ML Kit for offline text recognition and processes scanned images from the camera or gallery to extract key passport fields like:

- First Name
- Last Name
- Passport Number
- Nationality
- Date of Birth
- Passport Issue and Expiry Dates
- Place of Issue (if detected)

---

## ✨ Features

- 📸 Scan passport images using camera or gallery
- 🔍 Extract MRZ text using Google ML Kit (offline)
- 🧠 Parse passport info from raw MRZ
- 📄 View extracted passport details in a clean UI
- 📦 Lightweight, fast, and works offline

---

## 📦 Dependencies

This project uses the following Flutter packages:

| Package                          | Description                            |
|----------------------------------|----------------------------------------|
| `google_mlkit_text_recognition` | ML Kit for offline text recognition    |
| `image_picker`                  | Pick images from camera/gallery        |
| `camera`                        | Capture images using device camera     |
| `path_provider`                | Access local file system paths         |
| `get`                           | Routing and state management           |
| `intl`                          | Date formatting                        |

---

## 🚀 Getting Started

1. Clone the repo  
```bash
   git clone https://github.com/your-username/passport-ocr-scanner.git
   cd passport-ocr-scanner
```

2. Install dependencies

```bash
    flutter pub get
```

3. Run the app

```bash
    flutter run
```