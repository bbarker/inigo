
variable "cloudflare_email" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_domain" {
  type = string
}

variable "cloudflare_pattern" {
  type = string
}

provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_token = var.cloudflare_api_token
  account_id  = var.cloudflare_account_id
}

resource "cloudflare_workers_kv_namespace" "pages" {
  title = "pages"
}

resource "cloudflare_workers_kv_namespace" "static" {
  title = "static"
}

resource "cloudflare_workers_kv_namespace" "index" {
  title = "index"
}

resource "cloudflare_workers_kv_namespace" "packages" {
  title = "packages"
}

resource "cloudflare_workers_kv_namespace" "archives" {
  title = "archives"
}

resource "cloudflare_workers_kv_namespace" "readme" {
  title = "readme"
}

resource "cloudflare_workers_kv_namespace" "deps" {
  title = "deps"
}

resource "cloudflare_workers_kv_namespace" "accounts" {
  title = "accounts"
}

resource "cloudflare_workers_kv_namespace" "sessions" {
  title = "sessions"
}

resource "cloudflare_worker_script" "inigo-server" {
  name = "inigo-server"
  content = file("build/exec/inigo-server")

  kv_namespace_binding {
    name = "pages"
    namespace_id = cloudflare_workers_kv_namespace.pages.id
  }

  kv_namespace_binding {
    name = "static"
    namespace_id = cloudflare_workers_kv_namespace.static.id
  }

  kv_namespace_binding {
    name = "index"
    namespace_id = cloudflare_workers_kv_namespace.index.id
  }

  kv_namespace_binding {
    name = "packages"
    namespace_id = cloudflare_workers_kv_namespace.packages.id
  }

  kv_namespace_binding {
    name = "archives"
    namespace_id = cloudflare_workers_kv_namespace.archives.id
  }

  kv_namespace_binding {
    name = "readme"
    namespace_id = cloudflare_workers_kv_namespace.readme.id
  }

  kv_namespace_binding {
    name = "deps"
    namespace_id = cloudflare_workers_kv_namespace.deps.id
  }

  kv_namespace_binding {
    name = "accounts"
    namespace_id = cloudflare_workers_kv_namespace.accounts.id
  }

  kv_namespace_binding {
    name = "sessions"
    namespace_id = cloudflare_workers_kv_namespace.sessions.id
  }
}

resource "cloudflare_worker_route" "inigo-server-route" {
  zone_id = var.cloudflare_zone_id
  pattern = var.cloudflare_pattern
  script_name = cloudflare_worker_script.inigo-server.name
}

resource "cloudflare_workers_kv" "pages" {
  namespace_id = cloudflare_workers_kv_namespace.pages.id

  for_each = fileset(path.module, "./Pages/**/*.md")
  key = replace(each.key, "/.*Pages([/][a-zA-Z0-9/]+)[.]md/", "$1")
  value = file("${path.module}/${each.key}")
}

resource "cloudflare_workers_kv" "static" {
  namespace_id = cloudflare_workers_kv_namespace.static.id

  for_each = fileset(path.module, "./Static/**/*")
  key = replace(each.key, "/.*Static([/][a-zA-Z0-9/]+[.][a-z]+)/", "$1")
  value = file("${path.module}/${each.key}")
}
