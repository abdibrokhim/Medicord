import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class StorageService {
  static Future<void> storeAccess(String uuid) async {
    await addNewItemToKeyChain("uuid", uuid.toString());
  }

  static Future<void> addNewItemToKeyChain(String key, String value) async {
    IOSOptions getIOSOptions() => const IOSOptions(
          accountName: AppleOptions.defaultAccountName,
        );

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    const storage = FlutterSecureStorage();

    await storage.write(
      key: key,
      value: value,
      iOptions: getIOSOptions(),
      aOptions: getAndroidOptions(),
    );
  }

  static Future<Map<String, String>> readItemsFromToKeyChain() async {
    const storage = FlutterSecureStorage();
    IOSOptions getIOSOptions() => const IOSOptions(
          accountName: AppleOptions.defaultAccountName,
        );

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    return await storage.readAll(
      iOptions: getIOSOptions(),
      aOptions: getAndroidOptions(),
    );
  }

  static Future<void> clearAccessStorage() async {
    const storage = FlutterSecureStorage();
    IOSOptions getIOSOptions() => const IOSOptions(
          accountName: AppleOptions.defaultAccountName,
        );

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    try {
      await storage.delete(
        key: "uuid",
        iOptions: getIOSOptions(),
        aOptions: getAndroidOptions(),
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}