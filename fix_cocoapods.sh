#!/bin/zsh

# Перейти в корень проекта
cd /Users/beksultanbekmurzaev/flutter.project/MDF_Sat || exit

echo "🔹 Создаём Debug.xcconfig..."
cat << EOF > ios/Flutter/Debug.xcconfig
#include? "../Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Generated.xcconfig"
EOF

echo "🔹 Создаём Release.xcconfig..."
cat << EOF > ios/Flutter/Release.xcconfig
#include? "../Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Generated.xcconfig"
EOF

echo "🔹 Создаём Generated.xcconfig..."
cat << EOF > ios/Flutter/Generated.xcconfig
#include? "../Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"

FLUTTER_ROOT=/Users/beksultanbekmurzaev/Desktop/development/flutter
FLUTTER_APPLICATION_PATH=/Users/beksultanbekmurzaev/flutter.project/MDF_Sat
COCOAPODS_PARALLEL_CODE_SIGN=true
FLUTTER_TARGET=/Users/beksultanbekmurzaev/flutter.project/MDF_Sat/lib/main.dart
FLUTTER_BUILD_DIR=build
FLUTTER_BUILD_NAME=1.0.0
FLUTTER_BUILD_NUMBER=1
DART_DEFINES=RkxVVFRFUl9WRVJTSU9OPTMuMzguNw==,RkxVVFRFUl9DSEFOTkVMPXN0YWJsZQ==,RkxVVFRFUl9HSVRfVVJMPWh0dHBzOi8vZ2l0aHViLmNvbS9mbHV0dGVyL2ZsdXR0ZXIuZ2l0,RkxVVFRFUl9GUkFNRVdPUktfUkVWSVNJT049M2I2MmVmYzJhMw==,RkxVVFRFUl9FTkdJTkVfUkVWSVNJT049NzhmYzMwMTJlNA==,RkxVVFRFUl9EQVJUX1ZFUlNJT049My4xMC43
TRACK_WIDGET_CREATION=true
TREE_SHAKE_ICONS=false
PACKAGE_CONFIG=/Users/beksultanbekmurzaev/flutter.project/MDF_Sat/.dart_tool/package_config.json
EOF

echo "🔹 Устанавливаем Pods..."
cd ios || exit
pod install
cd ..

echo "🔹 Очищаем Flutter проект..."
flutter clean
flutter pub get

# Автоматически берём первый доступный device_id
DEVICE_ID=$(flutter devices --machine | grep ios | head -n1 | sed -E 's/.*"id": "([^"]+)".*/\1/')

if [ -z "$DEVICE_ID" ]; then
  echo "❌ Не найдено ни одного iOS устройства или симулятора!"
  exit 1
fi

echo "🔹 Запускаем Flutter на устройстве $DEVICE_ID..."
flutter run -d "$DEVICE_ID"
