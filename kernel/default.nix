{ stdenv
, buildPackages
, fetchFromGitHub
, perl
, buildLinux
, modDirVersionArg ? null
, ...
} @ args:

let
  inherit (stdenv.lib)
    concatStrings
    intersperse
    take
    splitString
    optionalString
    ;
in
(
  buildLinux (
    args // rec {
      version = "5.5.0-rc1";

      # modDirVersion needs to be x.y.z, will automatically add .0 if needed
      modDirVersion = if (modDirVersionArg == null) then concatStrings (intersperse "." (take 3 (splitString "." "${version}.0"))) else modDirVersionArg;

      # branchVersion needs to be x.y
      extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

      src = fetchFromGitHub {
        owner = "Xilinx";
        repo = "linux-xlnx";
        rev = "zynqmp-soc-for-v5.6";
        sha256 = "00r0x1ly3sm66yjvdcdky1s1m7z8f5rzf1l7pw9mfzxcpyzmz4ss";
      };

      postInstall = (optionalString (args ? postInstall) args.postInstall) + ''
        mkdir -p "$out/nix-support"
        cp -v "$buildRoot/.config" "$out/nix-support/build.config"
      '';
    } // (args.argsOverride or {})
  )
)
