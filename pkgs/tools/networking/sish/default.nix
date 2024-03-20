{ lib
, buildGoModule
, fetchFromGitHub
, testers
, sish
}:

buildGoModule rec {
  pname = "sish";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    rev = "refs/tags/v${version}";
    hash = "sha256-nDmmq8Yv+iCZPor7sLdJWqWudb3yxrllZgPH4d9mP38=";
  };

  vendorHash = "sha256-4HcWD/u7aCEzQ3tYRmFwvdjPuv5eyHlCVHtxA6cBiW0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${src.rev}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = sish;
    };
  };

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "sish";
  };
}
