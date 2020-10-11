{}:

{
  image = "postgres:10";

  volumes = [
    "postgres_data:/var/lib/postgresql/data"
  ];

  environment = {
    POSTGRES_USER =     "app_admin";
    POSTGRES_PASSWORD = "app_admin_pass";
    POSTGRES_DB =       "nextjsdemo_test";
  };
}
