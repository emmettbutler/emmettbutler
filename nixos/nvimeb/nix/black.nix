{ stdenv, lib, buildPythonPackage, dataclasses, fetchPypi, pythonOlder
, pytestCheckHook, aiohttp, aiohttp-cors, appdirs, click804, colorama
, hatch-fancy-pypi-readme, hatch-vcs, hatchling, mypy-extensions, pathspec
, parameterized, platformdirs, regex, toml, tomli, typed-ast, typing-extensions
, uvloop }:

buildPythonPackage rec {
  pname = "black";
  version = "21.4b2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/JvPO0grBcHzX2qILAedwBucd5WCdTL0zEPA7IgGe7w=";
  };

  nativeBuildInputs = [ hatch-fancy-pypi-readme hatch-vcs hatchling ];

  # Necessary for the tests to pass on Darwin with sandbox enabled.
  # Black starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook parameterized aiohttp ];

  preCheck = ''
    export PATH="$PATH:$out/bin"

    # The top directory /build matches black's DEFAULT_EXCLUDE regex.
    # Make /build the project root for black tests to avoid excluding files.
    touch ../.git
  '' + lib.optionalString stdenv.isDarwin ''
    # Work around https://github.com/psf/black/issues/2105
    export TMPDIR="/tmp"
  '';

  disabledTests = [
    # requires network access
    "test_gen_check_output"
  ] ++ lib.optionals stdenv.isDarwin [
    # fails on darwin
    "test_expression_diff"
    # Fail on Hydra, see https://github.com/NixOS/nixpkgs/pull/130785
    "test_bpo_2142_workaround"
    "test_skip_magic_trailing_comma"
  ];
  # multiple tests exceed max open files on hydra builders
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  propagatedBuildInputs = [
    aiohttp
    aiohttp-cors
    appdirs
    click804
    mypy-extensions
    pathspec
    platformdirs
    regex
    toml
    tomli
  ] ++ lib.optional (pythonOlder "3.7") dataclasses
    ++ lib.optional (pythonOlder "3.8") typed-ast
    ++ lib.optional (pythonOlder "3.10") typing-extensions;

  passthru.optional-dependencies = {
    d = [ aiohttp aiohttp-cors ];
    colorama = [ colorama ];
    uvloop = [ uvloop ];
  };

  meta = with lib; {
    description = "The uncompromising Python code formatter";
    homepage = "https://github.com/psf/black";
    changelog = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sveitser autophagy ];
  };
}
