abstract interface class DatabaseKeyStore {
  Future<String> readOrCreateDatabaseKey();
}
