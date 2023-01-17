package hnsp.voll.apiVoll;

import hnsp.voll.apiVoll.utils.Utils;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.multipart.FileUpload;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.PubSecKeyOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.auth.jwt.JWTAuthOptions;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.JWTAuthHandler;
import io.vertx.ext.web.openapi.RouterBuilder;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import io.vertx.sqlclient.Row;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.time.OffsetDateTime;
import java.util.Iterator;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import static hnsp.voll.apiVoll.utils.MapObject.session;
import static hnsp.voll.apiVoll.utils.QueryDB.*;


public class Verticol2  extends AbstractVerticle {

  private PgPool pool;
  private Router router;

    public static void main(String[] args) {

      Vertx.vertx().deployVerticle(new Verticol2());
    }

    @Override
      public void start() {
      System.out.println(" Start Verticle: Ok");
      //clientDB().compose(this::preubaConexion); // setUpInitialData

      clientDB().compose(this::setUpInitialData);

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

          //router.route().putMetadata("/v1", routerBuilder.createRouter());


          router.errorHandler(500, rc -> {
            rc.failure().printStackTrace();
            rc.end(rc.failure().getMessage());
          });

          vertx
            .createHttpServer()
            .requestHandler(router)
            .listen(8080);

          System.out.println("Listening .... ");
        })
        .onFailure(Throwable::printStackTrace);
      return Future.succeededFuture();
    }

    private void allFunction(RouterBuilder router) {

      System.out.println("AQUI VAMOS A LLAMAR TODOS LOS ENDPOINT ==>>");
/*
      router.operation("createvoll").handler(this::createvoll);
      router.operation("updateSeccion").handler(this::updateSeccion);
*/
      router.operation("getTest").handler(this::TestData);
      router.operation("login").handler(this::login);
      //router.operation("statusSession").handler(this::statusSession);
      router.operation("updateSession").handler(this::updateSession);
      router.operation("logout").handler(this::logout);

      router.operation("uploadDoc").handler(this::uploadDoc);

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

  private void uploadDoc(RoutingContext routingContext) {



      // Use the Event Bus to dispatch the file now
      // Since Event Bus does not support POJOs by default so we need to create a MessageCodec implementation
      // and provide methods for encode and decode the bytes




  }


  private void TestData(RoutingContext routingContext) {
    System.out.println("Hay coneccion ...");

    pool.getConnection().compose(res ->
      res.query("SELECT * FROM  sch_voll.voluntario")
        .execute()
        .flatMap(res2 ->{

          JsonObject voll = new JsonObject();
          JsonArray listVoll = new JsonArray();
          //Row row = res2.iterator().next();

          for (Row row : res2) {
            listVoll.add(row.toJson());
            System.out.println(row.toJson().encodePrettily());
          /*
          voll
            .put("id", row.getUUID("id"))
            .put("nombre", row.getUUID("nombre"))
            .put("apellidos", row.getUUID("apellidos"));
            */

          }

          routingContext
            .response()
            .setStatusCode(200)
            .putHeader("content-type", "application/json")
            //.end(new JsonObject().put("token", res3).encode());

          .end(listVoll.encodePrettily());
          return Future.succeededFuture(voll);
        }).onSuccess(ok -> {
        System.out.println(ok.encodePrettily());
      }).onFailure( err ->{
        System.out.println(err.getMessage());
      }));

  }

  private void updateSeccion(RoutingContext router) {

  }
/* */
  private void login(RoutingContext routingContext) {

    final String sessionId = UUID.randomUUID().toString();

    String email = routingContext.request().getParam("email");
    String password = routingContext.request().getParam("password");
    String encriptPass = Utils.encriptyPass(password);

    System.out.println("Emcript pwd ROW =>"+ password);
    String login = sqlLogin(routingContext);

    System.out.println("LOGIN SQL => "+ login);

    pool
      .getConnection()
      .compose(conn -> conn
        .query(login)
        .execute()
        .compose(result -> {
          if (result.rowCount() != 1)
            return Future.failedFuture("404");
          Row row = result.iterator().next();
          // muestra datos
          System.out.println(row.toJson().encodePrettily());

          System.out.println("pass find :"+ row.getString("email"));
          System.out.println("email find =>"+ email);


          //String role = getRole(row.getUUID("id").toString(),
          //  row.getUUID("role_id").toString());

          JsonObject session = new JsonObject();

          if (email.equals(row.getString("email")) &&
            encriptPass.equals(row.getString("password"))) {

            System.out.println("login OK ...");

            JWTAuthOptions jwt = new JWTAuthOptions()
              .addPubSecKey(new PubSecKeyOptions()
                .setAlgorithm("HS256")
                .setBuffer("superKey"));
            jwt.getJWTOptions().setSubject(sessionId);


            JWTAuth auth = JWTAuth.create(vertx, jwt);
            String token =
              auth.generateToken(new JsonObject()
                .put("sessionId", sessionId)
                .put("userId", row.getUUID("id").toString())
                .put("lastSeen", Optional
                  .ofNullable(row.getOffsetDateTime("lastseen"))
                  .map(OffsetDateTime::toInstant)
                  .orElse(null))
                .put("nombre", row.getString("nombre"))
                .put("apellidos", row.getString("apellidos"))

                .put("email", row.getString("email")), jwt.getJWTOptions());

            System.out.println("el token => "+token);

            session
              .put("sessionId", sessionId)
                .put("id", row.getUUID("id").toString())
                .put("token", token)
                .put("lastSeen", Optional
                  .ofNullable(row.getOffsetDateTime("lastseen"))
                  .map(OffsetDateTime::toInstant)
                  .orElse(null))
                .put("nombre", row.getString("nombre"))
                .put("apellidos", row.getString("apellidos"))
                .put("email", row.getString("email"));

            return Future.succeededFuture(session);
          }

          return Future.succeededFuture();
        })
        .compose(session -> {
          System.out.println("Token: " + session.encodePrettily());

          String saveSession = sqlInsertSessionData(session, sessionId);
          String updateLastSeen = sqlUpdateLastSession(session);

          System.out.println("SAVE SECION SQL => "+ saveSession);
          System.out.println("UPDATE LAST_SEE SQL => "+ updateLastSeen);
          conn.
            query(saveSession)
            .execute()
            .compose(res4 ->
              conn.
                query(updateLastSeen)
                .execute());

          return Future.succeededFuture(session.getString("token"));

        })
        .recover(err -> {
          System.out.println(err.getMessage());
          return Future.failedFuture("error!");
        })
        .onSuccess(res3 -> {

          routingContext
            .response()
            .setStatusCode(200)
            .putHeader("content-type", "application/json")
            .end(new JsonObject().put("token", res3).encode());
        }))

      .onFailure(err -> {
        routingContext
          .response()
          .putHeader("content-type", "application/json")
          .end(err.getMessage()); // TODO: rever erroes
        System.out.println(err.getMessage());
      });

  }

  //OUTROS =>>>

  private void logout(RoutingContext routingContext) {

    System.out.println(" init logouat ...");

    String id = routingContext.user().principal().getString("sessionId");

    String sql = "DELETE FROM sch_voll.session_up WHERE  id = '" + id + "' ";

    System.out.println("SQL: " + sql);

    pool
      .getConnection()
      .flatMap(conn -> //{
        conn
          .begin()
          .compose(tx -> {
            return
              conn
                .query(sql)
                .execute()
                .compose(size -> {

                  if (size.rowCount() != 1) {
                    System.out.println("HA HABIDO UN ERROR !");
                    return Future.failedFuture("404");
                  }
                  tx.commit();
                  return Future.succeededFuture();
                })
                .eventually(v -> conn.close());
          })
          /*.recover(this::errorSqlEx)
          .onSuccess(app -> {
            routingContext.response().setStatusCode(204).end();
          }) */

          .onSuccess(res3 -> {

            routingContext
              .response()
              .setStatusCode(204).end();
              //.putHeader("content-type", "application/json")
              //.end(new JsonObject().put("token", res3).encode());
          }))

          .recover(err -> {
            return Future.failedFuture(err.getMessage());
          })
          .onFailure(err -> {
            routingContext.response()
              .setStatusCode(400)
              .end(err.getMessage());
            System.out.println(err.getMessage());

          });

  }

  private void updateSession(RoutingContext routingContext) {

    JsonObject updateSession = session(routingContext);

    JWTAuthOptions jwt = new JWTAuthOptions()
      .addPubSecKey(new PubSecKeyOptions()
        .setAlgorithm("HS256")
        .setBuffer("superKey"));
    jwt.getJWTOptions().setSubject(updateSession.getString("sessionId"));

    JWTAuth auth = JWTAuth.create(vertx, jwt);
    String token =
      auth.generateToken(updateSession, jwt.getJWTOptions());

    String sql = " UPDATE sch_voll.session_up  SET token = '" + token +
      "' WHERE id = '" + updateSession.getString("sessionId") + "' RETURNING token";

    pool
      .getConnection()
      .flatMap(conn -> //{
        conn
          .begin()
          .compose(tx -> {
            return
              conn
                .query(sql)
                .execute()
                .compose(size -> {

                  if (size.rowCount() != 1) {
                    return Future.failedFuture("404");
                  }
                  tx.commit();
                  return Future.succeededFuture(size.iterator().next().toJson());
                })
                .eventually(v -> conn.close());
          })
          .recover(err -> {
            return Future.failedFuture(err.getMessage());
          })
          .onSuccess(app -> {
            routingContext.response()
              .putHeader("content-type", "application/json")
              .end(app.encode());

          })
          .onFailure(err -> {
            routingContext.response().end(err.getMessage());
            System.out.println(err.getMessage());

          })
      );


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

  public Future<Void> clientDB(

  ) {

    PgConnectOptions connectOptions = new PgConnectOptions()
      .setPort(5432)
      .setHost("192.168.1.77")
      .setDatabase("db_voll_hnsp")
      .setUser("postgres")
      .setPassword("postgres");

    PoolOptions poolOptions = new PoolOptions()
      .setMaxSize(5);

    this.pool = PgPool.pool(vertx, connectOptions, poolOptions);


    return Future.succeededFuture();
  }


}
