{ stdenv
, bundlerEnv
, ruby
, fetchFromGitHub
}:
let
  version = "unstable-2022-04-15";
  src = fetchFromGitHub {
    repo = "Jovian-Controller";
    owner = "Jovian-Experiments";
    rev = "669276f8e6be0ec1277a0c88c561357c65dbdfe0";
    sha256 = "sha256-vHsq7lQFjjUsSOa+Sbd2AVrLvEj70dcInC44eCYYtXY=";
  };

  gems = bundlerEnv {
    name = "Jovian-Controller-env";
    inherit ruby;
    gemdir  = src;
  };
in stdenv.mkDerivation {
  pname = "Jovian-Controller";

  inherit src;
  inherit version;


  buildInputs = [
    gems
    gems.wrappedRuby
  ];

  installPhase = ''
    mkdir -p $out/libexec
    cp  -rvt $out/libexec \
      *.rb \
      lib

    # Add a ruby-based wrapper that launches the script with the right ruby.
    mkdir -p $out/bin
    cat <<EOF > $out/bin/Jovian-Controller
    #!${gems.wrappedRuby}/bin/ruby
    load(File.join(__dir__(), "..", "libexec", "jovian-controller.rb"))
    EOF
    chmod +x $out/bin/Jovian-Controller
  '';
}
