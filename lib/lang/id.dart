const Map<String,String> _settingLang = {
  'theme_what': 'Tema @what',
  'theme': 'Tema',
  'system': 'Sistem',
  'dark': 'Gelap',
  'light': 'Terang',
  'cancel': 'Batal'
};

const Map<String,String> _appsLang = {
  'terms_of_service':'Syarat & Ketentuan',
  'privacy_policy': 'Kebijakan Privasi',
  'welcome': 'Selamat Datang di ',
  'login': 'Masuk dengan Portalnesia',
  'logout': 'Keluar',
  'logout_confirmation': "Keluar dari akun @what?",
  'setting': 'Pengaturan',
  'language': "Bahasa",
  'view_all': 'Lihat Semua',
  'all_what': 'Semua @what',
  'managed_merchant': 'Merchant Yang Dikelola',
  'owned_merchant': 'Merchant Yang Dimiliki'
};

const Map<String,String> _commonLang = {
  'add': 'Tambah',
  'add_what': 'Tambah @what',
  'del':"Hapus",
  'del_what':"Hapus @what",
  'remove':"Hapus",
  'remove_what':"Hapus @what",
  "wallet": "Dompet",
  "wait": "Mohon tunggu",
  "name": "Nama",
  "name_what": "Nama @what",
  "description": "Deskripsi",
  "address": "Alamat",
  "save": "Simpan",
  "are_you_sure": "Anda Yakin?",
  "back_confirmation": "Perubahan Anda belum disimpan",
  "cancel": "Batal",
  "yes": "Ya",
  "success":"Sukses",
  "saved":"Tersimpan",
  "saved_what":"@what tersimpan",
  "required":"Wajib diisi"
};

Map<String,String> idLang = {}..addAll(_appsLang)..addAll(_settingLang)..addAll(_commonLang);