final: super:

let
  inherit (final) callPackage kernelPatches linuxPackagesFor;
in
{
  linux_xilinx_zynqmp = callPackage ./kernel {
    kernelPatches = [];
  };
  linuxPackages_xilinx_zynqmp = linuxPackagesFor final.linux_xilinx_zynqmp;
}
