CARGO_NET_GIT_FETCH_WITH_CLI=true wasm-pack build --target web
cd www/ && python3 -m http.server 8000
