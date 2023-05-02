import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'picture.freezed.dart';
part 'picture.g.dart';




@freezed
abstract class Picture with _$Picture {
  const factory Picture({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    int? width,
    int? height,
    String? color,
    @JsonKey(name: 'blur_hash') required String blurHash,
    String? description,
    @JsonKey(name: 'alt_description') required String altDescription,
    required Urls urls,
    required Links links,
    required int likes,
    @JsonKey(name: 'liked_by_user') required bool likedByUser,
    required List<Tag> tags,
    required User user,
  }) = _Picture;

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);
}


@freezed
abstract class Urls with _$Urls {
  const factory Urls({
    required String raw,
    required String full,
    required String regular,
    required String small,
    required String thumb,
    @JsonKey(name: 'small_s3') required String smallS3,
  }) = _Urls;

  factory Urls.fromJson(Map<String, dynamic> json) => _$UrlsFromJson(Map<String,dynamic>.from(json));
}

@freezed
abstract class Links with _$Links {
  const factory Links({
    required String self,
    required String html,
    required String download,
    @JsonKey(name: 'download_location') required String downloadLocation,
  }) = _Links;

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(Map<String,dynamic>.from(json));
}

@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String type,
    required String title,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(Map<String,dynamic>.from(json));
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required String username,
    required String name,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name')  String? lastName,
    @JsonKey(name: 'twitter_username')  String? twitterUsername,
    @JsonKey(name: 'portfolio_url') String? portfolioUrl,
     String? bio,
     String? location,
    required UserLinks links,
    required UserProfileImage profileImage,
    @JsonKey(name: 'instagram_username')  String? instagramUsername,
     int? totalCollections,
     int? totalLikes,
     int? totalPhotos,
    @JsonKey(name: 'accepted_tos')  bool? acceptedTos,
    bool? forHire,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(Map<String,dynamic>.from(json));
}
@freezed
class UserLinks with _$UserLinks {
  const factory UserLinks({
   String? self,
   String? html,
   String? photos,
   String? likes,
   String? portfolio,
   String? following,
   String? followers,
  }) = _UserLinks;

  factory UserLinks.fromJson(Map<String, dynamic> json) => _$UserLinksFromJson(Map<String,dynamic>.from(json));
}

@freezed
class UserProfileImage with _$UserProfileImage {
  const factory UserProfileImage({
    required String small,
    required String medium,
    required String large,
  }) = _UserProfileImage;

  factory UserProfileImage.fromJson(Map<String, dynamic> json) => _$UserProfileImageFromJson(Map<String,dynamic>.from(json));
}
