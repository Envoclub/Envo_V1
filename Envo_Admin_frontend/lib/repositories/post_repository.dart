import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../models/action_model.dart';
import '../models/leaderboard_model.dart';
import '../models/posts.dart';
import '../models/rewards_model.dart';
import '../utils/meta_strings.dart';
import 'auth_repository.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  AuthRepository authRepository;
  PostRepository(this.authRepository);
  Future<List<PostActions>> getAllPostActions() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      String url = MetaStrings.baseUrl + MetaStrings.getPostActions;
      log(url);

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => PostActions.fromJson(e))
            .toList();
      } else {
        throw jsonDecode(response.body)["error"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getAllPosts() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      log(headers.toString());
      String url = MetaStrings.baseUrl + MetaStrings.getPosts;

      var response = await http.get(Uri.parse(url), headers: headers);
      log(response.body);
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Post.fromJson(e))
            .toList();
      } else {
        throw jsonDecode(response.body)["detail"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getMyPosts() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      log(headers.toString());
      String url = MetaStrings.baseUrl + MetaStrings.getMyPosts;

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Post.fromJson(e))
            .toList();
      } else {
        throw jsonDecode(response.body)["detail"];
      }
    } catch (e) {
      rethrow;
    }
  }

  like(Post post) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      var params = {"pk": post.pk};
      log(headers.toString());
      String url = MetaStrings.baseUrl + MetaStrings.likePost;
      log(url);

      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      log(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw jsonDecode(response.body)["detail"];
      }
    } catch (e) {
      rethrow;
    }
  }

  verify(Post post) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      var params = {"pk": post.pk};
      log(headers.toString());
      String url = MetaStrings.baseUrl + MetaStrings.verifyPost;
      log(url);

      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      log(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw jsonDecode(response.body)["detail"];
      }
    } catch (e) {
      rethrow;
    }
  }

  unLike(Post post) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      var params = {"pk": post.pk};
      log(headers.toString());
      try {
        String url = MetaStrings.baseUrl + MetaStrings.unLikePost;
        log(url);

        var response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(params));
        log(response.body);
        if (response.statusCode == 200) {
          return true;
        } else {
          throw jsonDecode(response.body);
        }
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  createPost(CreatePostModel post) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };

      log(headers.toString());
      final dio = Dio();
      String url = MetaStrings.baseUrl + MetaStrings.getPosts;
      FormData formData = FormData.fromMap({
        "action": post.action,
        "description": "",
        "postUrl": await MultipartFile.fromFile(
          post.postUrl.path,
        )
      });
      var response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log("errorr ${response.data}");
        throw jsonDecode(response.data);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<LeaderboardModel>> getLeaderBoard() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      log(headers.toString());
      String url = MetaStrings.baseUrl + MetaStrings.getLeaderBoard;

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return leaderboardModelFromJson(response.body);
      } else {
        throw jsonDecode(response.body)["detail"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RewardsModel>> getRewardsList() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json",
        "Accept" : "application/json"
      };
      log(headers.toString());

      String url = MetaStrings.baseUrl + MetaStrings.getRewardsList;
      log(url);
      var response = await http.get(Uri.parse(url), headers: headers);
      log(response.body);
      if (response.statusCode == 200) {
        return rewardsModelFromJson(response.body);
      } else {
        throw jsonDecode(response.body)["detail"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> redeemData(int id) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      log(headers.toString());

      String url =
          "${MetaStrings.baseUrl}${MetaStrings.getRewardsList}$id/redeem/";
      log(url);
      var response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["message"];
      } else {
        throw jsonDecode(response.body)["message"];
      }
    } catch (e) {
      rethrow;
    }
  }


  createReward(RewardsModel reward, int company, Uint8List data, String filename) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
      };

      final dio = Dio();
      String url = MetaStrings.baseUrl + MetaStrings.addReward;

      // Create a FormData object to send the multipart request
      FormData formData = FormData.fromMap({
        "company": company.toString(),
        "title": reward.title,
        "description": reward.description,
        "coinrequired": reward.coinrequired.toString(),
        "banner_upload": await MultipartFile.fromBytes(
          data,
          filename: filename,
        ),
      });

      var response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          contentType: Headers
              .formUrlEncodedContentType, // Set content type to form-data
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log("error ${response.data}");
        throw jsonDecode(response.data);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
