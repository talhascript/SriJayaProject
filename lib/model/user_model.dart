class User {
  String _name;
  String _phoneNumber;
  String _address;

  User({
    required String name,
    required String phoneNumber,
    required String address,
  })  : _name = name,
        _phoneNumber = phoneNumber,
        _address = address;

  String get name => _name;
  set name(String value) => _name = value;

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) => _phoneNumber = value;

  String get address => _address;
  set address(String value) => _address = value;
}