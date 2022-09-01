default: gen lint

gen:
    export REPO_DIR="$PWD"; cd /; flutter_rust_bridge_codegen \
        --rust-input "$REPO_DIR/rust/src/api.rs" \
        --dart-output "$REPO_DIR/lib/bridge_generated.dart" \
        --c-output "$REPO_DIR/frameworks/rust_crate/rust_crate/bridge_generated.h"

build-linux: 
      export REPO_DIR="$PWD"; cd "$PWD/rust"; cargo build --release; cp "$REPO_DIR/rust/target/release/librust.so" "$REPO_DIR/linux/rust"

build-windows: 
      export REPO_DIR="$PWD"; cd "$PWD/rust"; cargo build --release; cp "$REPO_DIR/rust/target/release/rust.dll" "$REPO_DIR/rust/target/release/rust.lib" "$REPO_DIR/windows/rust"

build-macos:
      export REPO_DIR="$PWD"; cd "$PWD/rust"; cargo build --release; cp "$REPO_DIR/rust/target/release/rust.dylib" "$REPO_DIR/macos/Libs"

lint:
    cd rust && cargo fmt
    dart format .

clean:
    flutter clean
    cd rust && cargo clean

# vim:expandtab:sw=4:ts=4
