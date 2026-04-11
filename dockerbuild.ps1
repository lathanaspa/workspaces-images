docker build -t lathanaspa/kasm-brave-vpn:develop -f dockerfile-kasm-brave-vpn .
docker build -t lathanaspa/kasm-chrome-vpn:develop -f dockerfile-kasm-chrome-vpn .
docker build -t lathanaspa/kasm-edge-vpn:develop -f dockerfile-kasm-edge-vpn .
docker build -t lathanaspa/kasm-firefox-vpn:develop -f dockerfile-kasm-firefox-vpn .
docker build -t lathanaspa/kasm-ubuntu-focal-desktop:develop -f dockerfile-kasm-ubuntu-focal-desktop .
docker build -t lathanaspa/kasm-ubuntu-focal-desktop-vpn:develop -f dockerfile-kasm-ubuntu-focal-desktop-vpn .
docker build -t lathanaspa/kasm-ubuntu-jammy-desktop:develop -f dockerfile-kasm-ubuntu-jammy-desktop .
docker build -t lathanaspa/kasm-ubuntu-jammy-desktop-vpn:develop -f dockerfile-kasm-ubuntu-jammy-desktop-vpn .
docker build -t lathanaspa/kasm-ubuntu-noble-desktop:develop -f dockerfile-kasm-ubuntu-noble-desktop .
docker build -t lathanaspa/kasm-ubuntu-noble-desktop-vpn:develop -f dockerfile-kasm-ubuntu-noble-desktop-vpn .

docker push lathanaspa/kasm-brave-vpn:develop 
docker push lathanaspa/kasm-chrome-vpn:develop
docker push lathanaspa/kasm-edge-vpn:develop
docker push lathanaspa/kasm-firefox-vpn:develop
docker push lathanaspa/kasm-ubuntu-focal-desktop:develop 
docker push lathanaspa/kasm-ubuntu-focal-desktop-vpn:develop
docker push lathanaspa/kasm-ubuntu-jammy-desktop:develop
docker push lathanaspa/kasm-ubuntu-jammy-desktop-vpn:develop
docker push lathanaspa/kasm-ubuntu-noble-desktop:develop
docker push lathanaspa/kasm-ubuntu-noble-desktop-vpn:develop