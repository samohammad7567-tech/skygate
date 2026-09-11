/// What the shell does with a system back press.
///
/// The cubit decides and the screen carries it out: showing a toast and
/// closing the app both need a `BuildContext` or a platform channel, neither
/// of which belongs in a cubit.
enum BackAction {
  /// The reader was on another tab; the shell has already moved to الرئيسية.
  goHome,

  /// First press on الرئيسية — warn, and start the window.
  warnBeforeExit,

  /// Second press inside the window — leave the app.
  exitApp,
}
