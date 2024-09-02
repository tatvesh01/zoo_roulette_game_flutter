class GUserDataModel {
  static const displayNameKey = "displayName";
  static const emailKey = "email";
  static const emailVerifiedKey = "emailVerified";
  static const isAnonymousKey = "isAnonymous";
  static const userMetadataCreationTimeKey = "userMetadataCreationTime";
  static const userMetadataLastSignInTimeKey = "userMetadataLastSignInTime";
  static const phoneNumberKey = "phoneNumber";
  static const photoURLKey = "photoURL";
  static const providerDataUIDKey = "providerDataUID";
  static const uidKey = "uid";
  
  GUserDataModel({
    this.displayName = "",
    this.email = "",
    this.emailVerified = false,
    this.isAnonymous = false,
    this.userMetadataCreationTime = "",
    this.userMetadataLastSignInTime = "",
    this.phoneNumber = "",
    this.photoUrl = "",
    this.providerDataUid = "",
    this.uid = "",
  });

  String displayName;
  String email;
  bool emailVerified;
  bool isAnonymous;
  String userMetadataCreationTime;
  String userMetadataLastSignInTime;
  String phoneNumber;
  String photoUrl;
  String providerDataUid;
  String uid;

  factory GUserDataModel.fromJson(Map<String, dynamic> json) => GUserDataModel(
        displayName: json[displayNameKey] ?? "",
        email: json[emailKey] ?? "",
        emailVerified: json[emailVerifiedKey] ?? false,
        isAnonymous: json[isAnonymousKey] ?? false,
        userMetadataCreationTime: json[userMetadataCreationTimeKey] ?? "",
        userMetadataLastSignInTime: json[userMetadataLastSignInTimeKey] ?? "",
        phoneNumber: json[phoneNumberKey] ?? "",
        photoUrl: json[photoURLKey] ?? "",
        providerDataUid: json[providerDataUIDKey] ?? "",
        uid: json[uidKey] ?? "",
      );

  Map<String, dynamic> toJson() => {
        displayNameKey: displayName,
        emailKey: email,
        emailVerifiedKey: emailVerified,
        isAnonymousKey: isAnonymous,
        userMetadataCreationTimeKey: userMetadataCreationTime,
        userMetadataLastSignInTimeKey: userMetadataLastSignInTime,
        phoneNumberKey: phoneNumber,
        photoURLKey: photoUrl,
        providerDataUIDKey: providerDataUid,
        uidKey: uid,
      };
}
