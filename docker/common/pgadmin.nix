{}:

# -- user - pgadmin4@pgadmin.org
# -- user pass - admin
# -- hostname - postgres (yes, pgadmin4 client reaches postgres through pgadmin4 server, you dont need to expose $POSTGRES_PORT port)
# -- username - $POSTGRES_USER
# -- password - $POSTGRES_PASSWORD

{
  image = "fenglc/pgadmin4";
  ports = [
    "5050:5050"
  ];
  depends_on = [
    "postgres"
  ];
}
