{ pkgs, rootProjectDir, rootYarnModules }:

{
  useHostStore = true;

  environment = {
    # NEXT_STATIC_ - embedded in the js bundles on build time
    NEXT_STATIC_GRAPHQL_ENDPOINT_URL = "http://server:5000/graphql";
    NEXT_STATIC_GRAPHQL_WEBSOCKET_ENDPOINT_URL = "ws://server:5000/graphql";
    NEXT_STATIC_SECURE_COOKIES = "false";

    # NEXT_SERVER_ - visible only during ssr
    NEXT_SERVER_GRAPHQL_ENDPOINT_URL = "http://server:5000/graphql";

    SERVER_HOST = "server";

    SERVER_PORT = 5000;

    HOST = "0.0.0.0";
    PORT = 3000;
  };
}
