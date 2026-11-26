{ fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "try-omarchy";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/omacom/try-omarchy/releases/download/v${finalAttrs.version}/TryOmarchy.dmg";
    hash = "sha256-DrgopVd4MKJwvleBxr1feCIGMvNbE/z/Tzr4B8NEXMg=";
  };

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    # Read the APFS image with macOS itself to preserve the signed app bundle.
    mount_dir="$(mktemp -d)"
    /usr/bin/hdiutil attach -readonly -nobrowse -noautoopen -mountpoint "$mount_dir" "$src"
    trap '/usr/bin/hdiutil detach "$mount_dir"' EXIT
    mkdir -p "$out/Applications"
    app_dir="$out/Applications/Try Omarchy.app"
    /usr/bin/ditto "$mount_dir/Try Omarchy.app" "$app_dir"
    /usr/bin/codesign --verify --deep --strict "$app_dir"

    runHook postInstall
  '';

  meta = {
    description = "Run the Omarchy desktop in a virtual machine on macOS";
    homepage = "https://tryomarchy.com/";
    platforms = [ "aarch64-darwin" ];
  };
})
