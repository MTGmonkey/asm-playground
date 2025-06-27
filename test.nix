{
  lib,
  stdenv,
  nasm,
  ...
}:
stdenv.mkDerivation {
  name = "asm-test";
  src = ./src;
  nativeBuildInputs = [
    nasm
  ];
  buildInputs = [
  ];
  configurePhase = ''
  '';
  buildPhase = ''
    nasm -f elf test_start.asm
    ld -m elf_i386 test_start.o -o test
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp test $out/bin/test
  '';

  meta = {
    license = lib.licenses.wtfpl;
    mainProgram = "test";
  };
}
