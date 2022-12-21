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

    private void allFunction(RouterBuilder router) {

      System.out.println("AQUI VAMOS A LLAMAR TODOS LOS ENDPOINT ==>>");

      router.operation("createvoll").handler(this::createvoll);

      /*
      router.operation("getAllVoll").handler(this::getAllVoll);
      router.operation("updateVoll").handler(this::updateVoll);
      router.operation("deleteVoll").handler(this::deleteVoll);
      router.operation("getVollById").handler(this::getVollById);
      router.operation("createResidencia").handler(this::createResidencia);
      router.operation("getAllResindeciaVoll").handler(this::getAllResindeciaVoll);
      router.operation("updateResidencia").handler(this::updateResidencia);
      router.operation("deleteResidencia").handler(this::deleteResidencia);
      router.operation("findResidenciaById").handler(this::findResidenciaById);
      router.operation("createEspecialidad").handler(this::createEspecialidad);
      router.operation("getAllEspecialidad").handler(this::getAllEspecialidad);
      router.operation("updateEspecialidad").handler(this::updateEspecialidad);
      router.operation("deleteEspecialdiad").handler(this::deleteEspecialdiad);
      router.operation("findEspecailidadById").handler(this::findEspecailidadById);
      router.operation("createPeriodoVoll").handler(this::createPeriodoVoll);
      router.operation("getAllPeriodo").handler(this::getAllPeriodo);
      router.operation("updatePeriodo").handler(this::updatePeriodo);
      router.operation("deteletePeriodo").handler(this::deteletePeriodo);
      router.operation("getPerdiodoById").handler(this::getPerdiodoById);
      router.operation("createPayVoll").handler(this::createPayVoll);
      router.operation("getAllPay").handler(this::getAllPay);
      router.operation("createSeccion").handler(this::createSeccion);
      router.operation("getAllSeccion").handler(this::getAllSeccion);
      router.operation("updatePay").handler(this::updatePay);
      router.operation("deletePay").handler(this::deletePay);
      router.operation("getPayById").handler(this::getPayById);
      router.operation("updateSeccion").handler(this::updateSeccion);
      router.operation("deleteSeccion").handler(this::deleteSeccion);
      router.operation("getSeccionById").handler(this::getSeccionById);
      router.operation("getDataAllVoll").handler(this::getDataAllVoll);
      router.operation("getDataOnlyVoll").handler(this::getDataOnlyVoll);
      router.operation("uploadDoc").handler(this::uploadDoc);
      router.operation("getImg").handler(this::getImg);
      router.operation("donloadDoc").handler(this::donloadDoc);
      router.operation("updatePassword").handler(this::updatePassword);
      router.operation("setPassword").handler(this::setPassword);
      router.operation("login").handler(this::login);
      router.operation("statusSession").handler(this::statusSession);
      router.operation("updateSession").handler(this::updateSession);
      router.operation("logout").handler(this::logout);

      */




    }

  private void createvoll(RoutingContext routingContext) {
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
