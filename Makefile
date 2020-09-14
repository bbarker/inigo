all : inigo
.PHONY : server inigo static inigo local-server deploy-init deploy test

bootstrap :
	rm -rf TmpBuild
	mkdir -p TmpBuild
	find . -not -regex '.*/TmpBuild' -not -regex '.' -not -path '*/\.*' -exec cp -r '{}' TmpBuild \;
	cp -r TmpBuild/Base/* TmpBuild/
	cd TmpBuild && pwd && idris2 --build Inigo.ipkg --cg node
	mkdir -p build/exec
	cp TmpBuild/build/exec/inigo build/exec/inigo
	rm -rf TmpBuild
	echo "Built \"build/exec/inigo\""

server :
	idris2 --build Server/InigoServer.ipkg --cg node

inigo :
	idris2 --build Inigo.ipkg --cg node

static :
	env SKIP_EXT=true node Server/InigoStatic/localize.js Server/InigoStatic/Pages Server/InigoStatic/Local/pages.json
	node Server/InigoStatic/localize.js Server/InigoStatic/Static Server/InigoStatic/Local/static.json

local-server : server static
	cloudworker --debug \
		--kv-file "pages=./Server/InigoStatic/Local/pages.json" \
		--kv-file "static=./Server/InigoStatic/Local/static.json" \
		--kv-file "index=./Server/InigoStatic/Local/index.json" \
		--kv-file "packages=./Server/InigoStatic/Local/packages.json" \
		--kv-file "deps=./Server/InigoStatic/Local/deps.json" \
		--kv-file "archives=./Server/InigoStatic/Local/archives.json" \
		--kv-file "readme=./Server/InigoStatic/Local/readme.json" \
		--kv-file "accounts=./Server/InigoStatic/Local/accounts.json" \
		--kv-file "sessions=./Server/InigoStatic/Local/sessions.json" \
		build/exec/inigo-server

deploy-init :
	terraform init -upgrade -var-file=${HOME}/InigoStatic.tfvars InigoStatic

deploy : static server
	terraform apply -var-file=${HOME}/InigoStatic.tfvars Server/InigoStatic

test :
	idris2 --find-ipkg Test/Suite.idr --cg node -x suite
