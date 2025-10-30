## Publicación: Firebase App Distribution

Flujo resumido:
1. Bump version (pubspec.yaml o android/app/build.gradle)
   - Formato: version: 1.0.1+2 (versionName+versionCode)
2. Generar APK de release:
   - `flutter build apk --release`
   - APK generado: `build/app/outputs/flutter-apk/app-release.apk`
3. Subir a Firebase Console → App Distribution → Releases.
4. Crear grupo de testers: `QA_Clase`
   - Agregar tester: dduran@uceva.edu.co
5. Incluir Release Notes y distribuir.
6. Recabar evidencias: capturas del panel de releases, correo de invitación, app instalada y actualización entre versiones.

Notas:
- Para instalar en dispositivo físico puedes usar `adb install -r path/to/app-release.apk`.
- Mantén versiones coherentes para actualizaciones incrementales (versionName y versionCode).
