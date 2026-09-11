class SosAssets {
  SosAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── The button and its sheet ─────────────────────────────────────────────
  static const String sos = '$_svgs/sos.svg';
  static const String quickSos = '$_svgs/info.svg';
  static const String call = '$_svgs/phone_enabled.svg';
  static const String chat = '$_svgs/chat.svg';
  static const String lostItems = '$_svgs/deployed_code_account.svg';
  static const String chevron = '$_svgs/chevron_right.svg';

  // ── "استغاثة سريعة" ──────────────────────────────────────────────────────
  static const String tripLeader = '$_svgs/flag.svg';
  static const String supervisors = '$_svgs/person.svg';
  static const String adminTeam = '$_svgs/deployed_code_account.svg';
  static const String office = '$_svgs/home_work.svg';
  static const String stepLocation = '$_svgs/my_location.svg';
  static const String stepAlert = '$_svgs/notifications.svg';
  static const String stepContact = '$_svgs/support_agent.svg';
  static const String stepsMap = '$_pngs/sos_steps_map.png';

  // ── Live chat ────────────────────────────────────────────────────────────
  static const String read = '$_svgs/check_check.svg';
  static const String attach = '$_svgs/paperclip.svg';
  static const String microphone = '$_svgs/mic.svg';

  // ── "المفقودات" ──────────────────────────────────────────────────────────
  static const String place = '$_svgs/location_on.svg';
  static const String date = '$_svgs/calendar_today.svg';
  static const String filter = '$_svgs/sliders.svg';
  static const String report = '$_svgs/deployed_code_account.svg';
  static const String description = '$_svgs/description.svg';
  static const String camera = '$_svgs/photo_camera.svg';
  static const String notes = '$_svgs/edit_square.svg';
  static const String itemWallet = '$_pngs/lost_item_wallet.png';
  static const String itemBackpack = '$_pngs/lost_item_backpack.png';
  static const String itemPhone = '$_pngs/lost_item_phone.png';
  static const String itemBeads = '$_pngs/lost_item_beads.png';

  static const List<String> itemPhotoFallbacks = [
    itemWallet,
    itemBackpack,
    itemPhone,
    itemBeads,
  ];
  static const List<String> all = [
    sos,
    quickSos,
    call,
    chat,
    lostItems,
    chevron,
    tripLeader,
    supervisors,
    office,
    stepLocation,
    stepAlert,
    stepContact,
    stepsMap,
    read,
    attach,
    microphone,
    place,
    date,
    filter,
    description,
    camera,
    notes,
    ...itemPhotoFallbacks,
  ];
}
