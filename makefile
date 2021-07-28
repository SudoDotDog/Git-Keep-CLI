# Paths
build := typescript/tsconfig.build.json
dev := typescript/tsconfig.dev.json

# NPX functions
tsc := node_modules/.bin/tsc
ts_node := node_modules/.bin/ts-node
mocha := node_modules/.bin/mocha
eslint := node_modules/.bin/eslint

# Build functions
build_utils := node_modules/.bin/build-utils

main: dev

dev:
	@echo "[INFO] Building for development"
	@NODE_ENV=development $(tsc) --p $(dev)

example-chmod: dev
	@echo "[INFO] Giving Permission"
	@chmod +x ./app/bin

example-get: example-chmod
	@echo "[INFO] Running Example"
	@./app/bin get example/version.json

example-major: example-chmod
	@echo "[INFO] Running Example"
	@./app/bin major example/version.json --spaces 4

example-minor: example-chmod
	@echo "[INFO] Running Example"
	@./app/bin minor example/version.json --spaces 4

example-patch: example-chmod
	@echo "[INFO] Running Example"
	@./app/bin patch example/version.json --spaces 4

example-auto: example-chmod
	@echo "[INFO] Running Example"
	@./app/bin auto example/version.json --spaces 4

build:
	@echo "[INFO] Building for production"
	@NODE_ENV=production $(tsc) --p $(build)

tests:
	@echo "[INFO] Testing with Mocha"
	@NODE_ENV=test \
	$(mocha) --config test/.mocharc.json

cov:
	@echo "[INFO] Testing with Nyc and Mocha"
	@NODE_ENV=test \
	nyc $(mocha) --config test/.mocharc.json

lint:
	@echo "[INFO] Linting"
	@NODE_ENV=production \
	$(eslint) . --ext .ts,.tsx \
	--config ./typescript/.eslintrc.json

lint-fix:
	@echo "[INFO] Linting and Fixing"
	@NODE_ENV=development \
	$(eslint) . --ext .ts,.tsx \
	--config ./typescript/.eslintrc.json --fix

install:
	@echo "[INFO] Installing Development Dependencies"
	@yarn install --production=false

install-prod:
	@echo "[INFO] Installing Production Dependencies"
	@yarn install --production=true

outdated: install
	@echo "[INFO] Checking Outdated Dependencies"
	@yarn outdated

license: clean
	@echo "[INFO] Sign files"
	@NODE_ENV=development $(ts_node) script/license.ts

clean:
	@echo "[INFO] Cleaning release files"
	@NODE_ENV=development $(build_utils) clean-path app

publish: install tests lint license build
	@echo "[INFO] Publishing package"
	@cd app && npm publish --access=public

publish-dry-run: install tests lint license build
	@echo "[INFO] Publishing package"
	@cd app && npm publish --access=public --dry-run
