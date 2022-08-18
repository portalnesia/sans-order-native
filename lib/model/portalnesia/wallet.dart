
// ignore_for_file: non_constant_identifier_names

class IWalletAccount {
  int id;
  String bank_code;
  String account_name;
  String account_number;

  IWalletAccount({
    required this.id,
    required this.bank_code,
    required this.account_name,
    required this.account_number
  });

  static IWalletAccount fromMap(Map data) {
    return IWalletAccount(id: data['id'], bank_code: data['bank_code'], account_name: data['account_name'], account_number: data['account_number']);
  }
}

class IWallet {
  int id;
  int balance;
  IWalletAccount account;
  
  IWallet({
    required this.id,
    required this.balance,
    required this.account
  });

  static IWallet fromMap(Map data) {
    return IWallet(id: data['id'], balance: data['balance'], account: IWalletAccount.fromMap(data['account']));
  }
}