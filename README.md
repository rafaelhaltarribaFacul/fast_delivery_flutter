# Fast Delivery

App Flutter para consulta de CEP e histórico de endereços.

## 🚀 Como Executar o Projeto

### Pré-requisitos

* Flutter SDK (≥ 3.0)
* Android SDK (via Android Studio) ou Xcode (para iOS)
* Dispositivo Android/iOS conectado ou emulador/simulador rodando
* (Opcional) Chrome/Edge para teste web

### 1. Clone o repositório

```bash
git clone https://github.com/<seu-usuario>/fast_delivery.git
cd fast_delivery
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Gere código MobX e Hive

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Executando no Android ou iOS

* Conecte seu dispositivo via USB ou abra um emulador.
* Verifique o ID do dispositivo:

  ```bash
  flutter devices
  ```
* Rode o app:

  ```bash
  flutter run -d <deviceId>
  ```

  Ou simplesmente:

  ```bash
  flutter run
  ```

### 5. Executando no Web

* Executar no Chrome:

  ```bash
  flutter run -d chrome
  ```
* Servir via web-server:

  ```bash
  flutter run -d web-server --web-port=8080
  ```

  Abra em [http://localhost:8080](http://localhost:8080)

### 6. Gerar APK de Release (Android)

```bash
flutter build apk --release
```

Para instalar no dispositivo:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### 7. Executando Testes

* Testes automatizados:

  ```bash
  flutter test
  ```

* Script de validação da API ViaCEP:

  ```bash
  dart run tools/test_viacep.dart
  ```

---

## 🛠️ Tecnologias Utilizadas

* Flutter
* Dart
* MobX
* Hive
* Dio
* Geocoding
* url\_launcher
