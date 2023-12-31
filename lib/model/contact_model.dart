class Contact {
  late String name;
  late String phoneNumber;

  Contact({required this.name, required this.phoneNumber});

  // Create a Contact instance from a map
  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phoneNumber = json['phoneNumber'];

  // Convert the Contact instance to a map
  Map<String, dynamic> toJson() => {'name': name, 'phoneNumber': phoneNumber};
}
