package hnsp.voll.apiVoll.utils;

import io.vertx.core.MultiMap;
import io.vertx.core.json.JsonObject;

import java.math.BigInteger;
import java.net.URLDecoder;
import java.security.MessageDigest;
import java.util.List;
import java.util.Map;

public class Utils {

  public static String encriptyPass(String pass) {
    String pwd = null;

    try {
      byte[] data = pass.getBytes();
      MessageDigest md = MessageDigest.getInstance("SHA-256");
      byte[] hash1 = md.digest(data);

      BigInteger bin = new BigInteger(1, hash1);
      pwd = String.format("%0" + (data.length << 1) + "x", bin);

    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return pwd;
  }


  private JsonObject getRequestParams(MultiMap params){

    JsonObject paramMap = new JsonObject();
    for( Map.Entry entry: params.entries()){
      String key = (String)entry.getKey();
      Object value = entry.getValue();
      if(value instanceof List){
        value = (List<String>) entry.getValue();
      }
      else{
        value = (String) entry.getValue();
      }
      paramMap.put(key, value);
    }
    return paramMap;
  }

  private static JsonObject getQueryMap(String query)
  {
    String[] params = query.split("&");
    JsonObject map = new JsonObject();
    for (String param : params) {
      String name = param.split("=")[0];
      String value = "";
      try {
        value = URLDecoder.decode(param.split("=")[1], "UTF-8");
      } catch (Exception e) {
      }
      map.put(name, value);
    }
    return map;
  }

}
