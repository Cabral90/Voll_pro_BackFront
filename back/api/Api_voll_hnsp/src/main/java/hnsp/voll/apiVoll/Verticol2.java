package hnsp.voll.apiVoll;

import io.netty.handler.codec.http.HttpResponseStatus;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.PubSecKeyOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.auth.jwt.JWTAuthOptions;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.JWTAuthHandler;
import io.vertx.ext.web.openapi.RouterBuilder;
import io.vertx.pgclient.PgPool;


public class Verticol2  extends AbstractVerticle {

  private PgPool pool;
  private Router router;

    public static void main(String[] args) {

      Vertx.vertx().deployVerticle(new Verticol2());
    }

    @Override
      public void start() {

    }


    public Future<Void> setUpInitialData(Void vd) {


      RouterBuilder.create(vertx, "src/main/resources/edit_voll_v2.yaml")//"openapi.yaml")
        .onSuccess(routerBuilder -> {
          System.out.println(" Call  all endpoint: Ok");

          JWTAuthOptions jwt = new JWTAuthOptions()
            .addPubSecKey(new PubSecKeyOptions()
              .setAlgorithm("HS256")
              .setBuffer("superKey"));

          JWTAuth provider = JWTAuth.create(vertx, jwt);
          JWTAuthHandler handler = JWTAuthHandler
            .create(provider);

          routerBuilder
            .securityHandler("bearerAuth", handler);
          allFunction(routerBuilder);

          this.router = Router.router(vertx)
            .errorHandler(400, rc -> sendError(rc, 400, rc.failure().getMessage()));

          router.mountSubRouter("/v1", routerBuilder.createRouter());

          router.errorHandler(500, rc -> {
            rc.failure().printStackTrace();
            rc.end(rc.failure().getMessage());
          });

          vertx
            .createHttpServer()
            .requestHandler(router)
            .listen(8088);

          System.out.println("Listening .... ");
        })
        .onFailure(Throwable::printStackTrace);
      return Future.succeededFuture();
    }

    private void allFunction(RouterBuilder routerBuilder) {

      System.out.println("AQUI VAMOS A LLAMAR TODOS LOS ENDPOINT ==>>");
    }


  public static void sendError(
    final RoutingContext rc,
    final int code,
    final String cause) {

    final String message = HttpResponseStatus.valueOf(code).reasonPhrase();

    final JsonObject json = new JsonObject()
      .put("status", code)
      .put("title", message);

    if (cause != null && !cause.startsWith("ValidationException")) {
      json.put("cause", cause);
    }

    rc.response()
      .setStatusCode(code)
      .setStatusMessage(message)
      .putHeader("Content-Type", "application/json")
      .end(json.toBuffer());

  }


}
