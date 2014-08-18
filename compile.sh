cat src/webpage-info.coffee > lib/webpage-info.coffee
coffee -cb lib/webpage-info.coffee
coffee -cb tests/test_core.coffee
rm lib/webpage-info.coffee
