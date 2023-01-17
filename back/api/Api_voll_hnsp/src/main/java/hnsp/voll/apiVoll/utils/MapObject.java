package hnsp.voll.apiVoll.utils;

import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;

public class MapObject {
  public static JsonObject session(RoutingContext routingContext){
    String sessionId = routingContext.user().principal().getString("sessionId");

    System.out.println("sessionId: " + sessionId);

    JsonObject updateSession = new JsonObject()
      .put("sessionId", sessionId)
      .put("id", routingContext.user().principal().getString("id"))
      .put("nombre", routingContext.user().principal().getString("nombre"))
      .put("apellidos", routingContext.user().principal().getString("apellidos"))
      .put("email", routingContext.user().principal().getString("email"));

    return updateSession;
  }
}
