{application, my_db_app, [
  {description, "DB application from chapter 12"},
  {vsn, "1"},
  {modules, [my_db, my_db_gen, my_db_sup, my_db_app]},
  {registered, [my_db_gen, my_db_sup]},
  {applications, [
    kernel,
    stdlib
  ]},
  {mod, {my_db_app, []}},
  {env, []}
]}.