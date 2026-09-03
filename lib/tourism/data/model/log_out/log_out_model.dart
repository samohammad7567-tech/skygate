
class LogOutModel{
String lang;
String memberCard;
String userId;

LogOutModel(this.memberCard,this.lang,this.userId);

Map<String,String> toJson ()=>{
  "lang":lang.toString(),
  "memberCard":memberCard.toString(),
  "UserId":userId.toString()
};
}