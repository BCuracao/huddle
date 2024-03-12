class UserModel {
  String email = "";
  String displayName = "";
  String id = "";

  UserModel(this.email, this.displayName, this.id);

  String getEmail() {
    return email;
  }

  String getDisplayName() {
    return displayName;
  }

  String getId() {
    return id;
  }

  void setDisplayName(String displayName) {
    this.displayName = displayName;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setId(String id) {
    this.id = id;
  }
}
