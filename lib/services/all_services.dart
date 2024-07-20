import 'dart:convert';
import 'dart:io';
import 'package:wixpod/model/all_book_model/all_book_model.dart';
import 'package:wixpod/model/category_model/categorywise_model.dart';
import 'package:wixpod/model/count_model/addcount_model.dart';
import 'package:wixpod/model/drawer/appdetaliscreen_model.dart';
import 'package:wixpod/model/favourite_model/favourite_model.dart';
import 'package:wixpod/model/favourite_model/getfavourite_model.dart';
import 'package:wixpod/model/home/home_banner_model.dart';
import 'package:wixpod/model/home/home_section_by_id_model.dart';
import 'package:wixpod/model/home/home_section_model.dart';
import 'package:wixpod/model/search/search_model.dart';
import 'package:wixpod/model/single_book/single_book_model.dart';
import 'package:wixpod/model/subscription_model/adduserfamily_model.dart';
import 'package:wixpod/model/subscription_model/buysubscription_model.dart';
import 'package:wixpod/model/subscription_model/getsubscription_model.dart';
import 'package:wixpod/model/subscription_model/subscriptionplan_model.dart';
import 'package:wixpod/model/user_delete/user_delete.dart';
import 'package:wixpod/model/user_model/login_model.dart';
import 'package:wixpod/model/user_model/registration_model.dart';
import 'package:wixpod/model/user_model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../model/all_author_model/all_author_model.dart';
import '../model/all_author_model/author_book.dart';
import '../model/user_model/updated_model.dart';

class AllServices {
  /// home
  Future<HomeBannerModel?> home() async {
    try {
      var params = {"data": '{"method_name":"home","page":"1","user_id":"$userid","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
        return homeBannerModelFromJson(response.body);
      }
      return null;
    } catch (e, t) {
      if(kDebugMode){
        print('home api ERROR ---- ${e}');
        print('home api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// home_section
  Future<HomeSectionModel?> homeSection() async {
    try {
      var params = {"data": '{"method_name":"home_section","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
            return homeSectionModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('home_section api ERROR ---- ${e}');
        print('home_section api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// home_section_id
  Future<HomeSectionbyIdModel?> homeSectionbyID({required String id, required int page}) async {
    try {
      var params = {"data": '{"method_name":"home_section_id","homesection_id":"$id","page":"$page","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
            return homeSectionbyIdModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('home_section_id api ERROR ---- ${e}');
        print('home_section_id api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// artist_list
  Future<AllAuthorModel?> allAuthor({int? page}) async {
    try {
      var params = {"data": '{"method_name":"artist_list","page":"$page","language":"$languagecode"}'};

      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            return allAuthorModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('artist_list api ERROR ---- ${e}');
        print('artist_list api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// artist_album_list
  Future<AuthorBookModel?> authorBook({String? authorId, required int page}) async {
    try {
      var params = {
            "data": '{"method_name":"artist_album_list","page":"$page","artist_id":"$authorId","user_id":"$userid","language":"$languagecode"}'
          };
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            return authorBookModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('artist_album_list api ERROR ---- ${e}');
        print('artist_album_list api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// album_list
  Future<AllBookModel?> allBook({int? page}) async {
    try {
      var params = {"data": '{"method_name":"album_list","page":$page,"user_id":"$userid","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
            return allBookModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('album_list api ERROR ---- ${e}');
        print('album_list api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// cat_songs
  Future<CategoryWiseBooks?> categoryBooks({String? catId, required int page}) async {
    try {
      var params = {"data": '{"method_name":"cat_songs","page":"$page","cat_id":"$catId","user_id":"$userid"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            return categoryWiseBooksFromJson(response.body);
          } else {
            return null;
          }
    } catch (e,t) {
      if(kDebugMode){
        print('cat_songs api ERROR ---- ${e}');
        print('cat_songs api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// chapter_count
  Future<AddCountDataModel?> addcount() async {
    try {
      var params = {"data": '{"method_name":"chapter_count","user_id":"$userid"}'};

      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            success.value = addCountDataModelFromJson(response.body).audioBook[0].success;
            return addCountDataModelFromJson(response.body);
          } else {
            return null;
          }
    } catch (e,t) {
      if(kDebugMode){
        print('chapter_count api ERROR ---- ${e}');
        print('chapter_count api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// app_details
  Future<AppDetalisModel?> appdetalis() async {
    try {
      var params = {"data": '{"method_name":"app_details"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            return appDetalisModelFromJson(response.body);
          } else {
            return null;
          }
    } catch (e,t) {
      if(kDebugMode){
        print('app_details api ERROR ---- ${e}');
        print('app_details api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// favourite_post
  Future<FavouriteModel?> favouriteBook({String? bookid}) async {
    try {
      var params = {"data": '{"method_name":"favourite_post","post_id":"$bookid","user_id":"$userid","type":"fav_post"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
            return favouriteModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('favourite_post api ERROR ---- ${e}');
        print('favourite_post api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// get_favourite_post
  Future<GetFavouriteModel?> getfavouriteBook() async {
    try {
      var params = {"data": '{"method_name":"get_favourite_post","user_id":"$userid","type":"fav_post","page":"1","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            return getFavouriteModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('get_favourite_post api ERROR ---- ${e}');
        print('get_favourite_post api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// book_search
  Future<SearchModel?> searchservice({String? searchtext, String? userid}) async {
    try {
      var params = {"data": '{"method_name":"book_search","language":"$languagecode","page":1,"user_id":"$userid","search_text":"$searchtext"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
        return searchModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e,t) {
      if(kDebugMode){
        print('book_search api ERROR ---- ${e}');
        print('book_search api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// book_rating
  Future bookratingservice({required String bookid, required String userid, required double rating}) async {
    try {
      var params = {"data": '{"method_name":"book_rating","page":"1","post_id":"$bookid","rate":"$rating","user_id":"${userid}"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['AUDIO_BOOK'][0]['success'] == '1') {
              ShowSnackBar(message: data['AUDIO_BOOK'][0]['msg']);
            }
            return data;
          }
    } catch (e,t) {
      if(kDebugMode){
        print('book_rating api ERROR ---- ${e}');
        print('book_rating api TRACE ---- ${t}');
      }
    }
  }

  /// single_book
  Future<SingalBookModel?> singalbookservice({String? bookid}) async {
    try {
      var params = {"data": '{"method_name":"single_book","page":"1","Book_id":"$bookid","user_id":"$userid","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
        return singalBookModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e,t) {
      if(kDebugMode){
        print('single_book api ERROR ---- ${e}');
        print('single_book api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// buy_subscription
  Future<BuySubscriptionModel?> buySubscription({String? tid, bool update = false, required String pid, String? endDate, String? purchaseId}) async {
    try {

      /// when update plan set [update = true , end_date != null]
      final params = update
          ? {"data": '{"method_name":"buy_subscription","user_id":"$userid","plan_id":"$pid","end_date": "$endDate"}'}
          : {
              "data":
                  '{"method_name":"buy_subscription","user_id": "$userid","transaction_id": "$tid","plan_id": "$pid","purchase_id" : "$purchaseId"}'
            };
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
        return buySubscriptionModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, t) {
      if(kDebugMode){
        print('buy_subscription api ERROR ---- ${e}');
        print('buy_subscription api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// user_subscription_status
  Future<GetSubscriptionModel?> getSubscription() async {
    var params = {"data": '{"method_name":"user_subscription_status","user_id":"$userid"}'};
    final response = await http.post(Uri.parse(Api.mainApi), body: params);
    try {
      if (response.statusCode == 200) {
        return getSubscriptionModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, t) {
      if(kDebugMode){
        print('user_subscription_status api ERROR ---- ${e}');
        print('user_subscription_status api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// get_plans
  Future<SubscriptionPlanModel?> subscriptionPlans() async {
    try {
      var params = {"data": '{"method_name":"get_plans","language":"$languagecode"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);

      if (response.statusCode == 200) {
            return subscriptionPlanModelFromJson(response.body);
          } else {
            return null;
          }
    } catch (e,t) {
      if(kDebugMode){
        print('get_plans api ERROR ---- ${e}');
        print('get_plans api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// premium_user
  Future<AddUserFamilyModel?> addUserFamilySubscription({required String fname}) async {
    try {
      var params = {"data": '{"method_name":"premium_user","user_id":"$userid","premium_user":"$fname"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
        ShowSnackBar(message: addUserFamilyModelFromJson(response.body).audioBook[0].msg);
        return addUserFamilyModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, t) {
      if(kDebugMode){
        print('premium_user api ERROR ---- ${e}');
        print('premium_user api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// user_login
  Future<LoginModel?> Loginservice({String? email, String? pass}) async {
    try {
      var params = {"data": '{"method_name":"user_login","email":"$email","type":"normal","password":"$pass","auth_id":"1"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (kDebugMode) {}
      if (response.statusCode == 200) {
        return loginModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e, t) {
      if(kDebugMode){
        print('user_login api ERROR ---- ${e}');
        print('user_login api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// user_register
  Future<RegistrationModel?> registrationService(
      {String? name, String? regemail, String? regpass, String? type, String? authId, String? phone, String? pn_countrycode, String? image}) async {
    try {
      final params = {
        "data":
            '{"method_name":"user_register","email": "$regemail","type":"$type","name":"$name","password":"$regpass","auth_id":"$authId","user_image":"$image","phone":"$phone","pn_countrycode": "$pn_countrycode"}'
      };
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
        return registrationModelFromJson(response.body);
      }
      return null;
    } catch (e, t) {
      if(kDebugMode){
        print('user_register api ERROR ---- ${e}');
        print('user_register api TRACE ---- ${t}');
      }
      return null;
    }
  }

  Future<GetUserModel?> getuserservice({String? userid, String? name}) async {
    try {
      var params = {"data": '{"method_name":"user_profile","user_id":"$userid","name":"$name"}'};
      final response = await http.post(Uri.parse(Api.mainApi), body: params);
      if (response.statusCode == 200) {
            return getUserModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('user_profile api ERROR ---- ${e}');
        print('user_profile api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// user_profile_update
  Future<GetUpdatedModel?> getupdatedservice({String? name, String? email, File? image, String? phonenumber, String? pn_countrycode}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Api.mainApi));

      request.fields['data'] =
              '{"method_name":"user_profile_update","user_id":"$userid","email":"$email","name":"$name","phone":"$phonenumber","pn_countrycode":"$pn_countrycode"}';

      if (image != null) {
            request.files.add(await http.MultipartFile.fromPath('user_image', image.path));
          }
      http.Response response = await http.Response.fromStream(await request.send());
      return getUpdatedModelFromJson(response.body);
    } catch (e,t) {
      if(kDebugMode){
        print('user_profile_update api ERROR ---- ${e}');
        print('user_profile_update api TRACE ---- ${t}');
      }
    }
    return null;
  }

  /// delete_userdata
  Future<DeleteProfileModel?> deleteAccountService() async {
    try {
      var body = {'data': '{"method_name":"delete_userdata","user_id":"$userid"}'};

      final response = await http.post(Uri.parse(Api.mainApi), body: body);
      if (response.statusCode == 200) {
            return deleteProfileModelFromJson(response.body);
          }
      return null;
    } catch (e,t) {
      if(kDebugMode){
        print('delete_userdata api ERROR ---- ${e}');
        print('delete_userdata api TRACE ---- ${t}');
      }
    }
    return null;
  }
}
