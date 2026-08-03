// Centralise ici tous les providers de repositories.
// Exemple une fois Auth implemente :
//
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return FirebaseAuthRepository(
//     auth: ref.read(firebaseAuthProvider),
//     connectivity: ref.read(connectivityServiceProvider),
//   );
// });
