{ stdenv
, bundlerEnv
, ruby
, fetchFromGitHub
}:
let
  version = "unstable-2022-08-20";
  src = ./.;
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
