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
    nasm -f elf main.asm
    ld -m elf_i386 main.o -o main
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin/main
  '';

  meta = {
    license = lib.licenses.wtfpl;
    mainProgram = "main";
  };
}
