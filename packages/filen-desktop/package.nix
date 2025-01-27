{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  cacert,
}:

buildNpmPackage rec {
  pname = "filen-desktop";
  version = "3.0.41";
  makeCacheWritable = true;

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-desktop";
    rev = "v${version}";
    hash = "sha256-HpyASSpjRgBTkV7L5bfi65rO+MnrSP7VdeuL/VXBlSo=";
  };

  npmDepsHash = "sha256-uePTd8y26hyLYcazlrOyrH+7CRjav+/d6HLMSKEGWiA=";

  # Copy your local package-lock.json into the source after unpacking
  postPatch = ''
    chmod +w package-lock.json
    cp ${./package-lock.json} package-lock.json
  '';

  buildInputs = [ cacert ];

  # Set environment variables for SSL and npm
  env = {
    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    npm_config_strict_ssl = "false"; # "false" as a string
  };
  preBuild = ''
    export NODE_EXTRA_CA_CERTS="${cacert}/etc/ssl/certs/ca-bundle.crt"
    npm config set strict-ssl false
  '';

  meta = with lib; {
    homepage = "https://filen.io/products";
    downloadPage = "https://filen.io/products/desktop";
    description = "Filen Desktop Client";
    longDescription = ''
      Encrypted Cloud Storage built for your Desktop.
      Sync your data, mount network drives, collaborate with others and access files natively — powered by robust encryption and seamless integration.
    '';
    mainProgram = "filen-desktop";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.agpl3Only;
    maintainers = with maintainers; [ smissingham ];
  };
}
