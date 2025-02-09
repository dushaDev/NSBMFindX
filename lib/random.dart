class Random{

  String randomDp(String name) {
    List<String> words=splitName(name);
    const String baseUrl = 'https://avatar.iran.liara.run/username?username=';
    return "$baseUrl${words[0]}+${words[1]}";
  }
   List<String>splitName(String name) {
    List<String> words = name.split(" ");
    return words;
  }

}