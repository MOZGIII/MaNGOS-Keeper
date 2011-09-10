config.save :mysql, {
  user: "root",
  pass: "",
  default_db: "mangos",
}

config.save :sources_paths, {
  mangos: "mangos",
  scriptdev2: "mangos/src/bindings/ScriptDev2",
  ytdb: "YTDB",
}

config.save :git_repos, {
  mangos: "git://github.com/<user>/mangos.git",
  scriptdev2: "git://github.com/<user>/scriptdev2.git",
  ytdb: "git://github.com/<user>/YTDB.git",
}

config.save :load_sources, {
  patch_scriptdev: true,
  unpack_ytdb: true,
}