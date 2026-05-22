# Mirror Phone

**Screen mirror your iPhone to your Mac — free, open-source, no cables.**

**Affichez l'ecran de votre iPhone sur votre Mac — gratuit, open-source, sans fil.**

![macOS](https://img.shields.io/badge/macOS-14%2B-blue) ![License](https://img.shields.io/badge/license-MIT-green)

---

## What is this? / C'est quoi ?

**EN:** Mirror Phone is a lightweight macOS app that turns your Mac into an AirPlay receiver. It lets you mirror your iPhone screen wirelessly — no cables, no paid software. Built on top of [UxPlay](https://github.com/FDH2/UxPlay).

**FR:** Mirror Phone est une app macOS legere qui transforme votre Mac en recepteur AirPlay. Elle permet d'afficher l'ecran de votre iPhone sans fil — sans cable, sans logiciel payant. Basee sur [UxPlay](https://github.com/FDH2/UxPlay).

---

## Why? / Pourquoi ?

Apple's built-in iPhone Mirroring requires macOS Sequoia + Apple Silicon and doesn't work for everyone. Mirror Phone works on **any Mac running macOS 14+** (Intel or Apple Silicon).

La Recopie iPhone d'Apple necessite macOS Sequoia + Apple Silicon et ne marche pas pour tout le monde. Mirror Phone fonctionne sur **tout Mac sous macOS 14+** (Intel ou Apple Silicon).

---

## Install / Installation

One command / Une seule commande :

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/marinasba/mirror-phone/main/install.sh)"
```

Or manually / Ou manuellement :

```bash
git clone https://github.com/marinasba/mirror-phone.git
cd mirror-phone
chmod +x install.sh
./install.sh
```

### What does it install? / Qu'est-ce qui est installe ?

- [Homebrew](https://brew.sh) (if not already installed / si pas deja installe)
- cmake, gstreamer, libplist (via Homebrew)
- [UxPlay](https://github.com/FDH2/UxPlay) (compiled from source / compile depuis les sources)
- **Mirror Phone.app** in `/Applications`

---

## Usage / Utilisation

**EN:**
1. Launch Mirror Phone from Launchpad or `/Applications`
2. On your iPhone: Control Center > Screen Mirroring
3. Select "Mirror Phone" from the list
4. Done! Your iPhone screen appears in a window

**FR:**
1. Lancez Mirror Phone depuis le Launchpad ou `/Applications`
2. Sur l'iPhone : Centre de controle > Recopie de l'ecran
3. Choisissez "Mirror Phone" dans la liste
4. C'est fait ! L'ecran de l'iPhone s'affiche dans une fenetre

The window is movable and resizable. `Cmd+Q` to quit.

La fenetre est deplacable et redimensionnable. `Cmd+Q` pour quitter.

---

## Requirements / Prerequis

- macOS 14 (Sonoma) or later / ou plus recent
- iPhone and Mac on the same Wi-Fi / iPhone et Mac sur le meme Wi-Fi
- ~500 MB disk space for dependencies / d'espace disque pour les dependances

---

## Uninstall / Desinstallation

```bash
rm -rf "/Applications/Mirror Phone.app"
rm -rf ~/Projects/UxPlay
# Optional / Optionnel :
# brew uninstall cmake gstreamer libplist
```

---

## Troubleshooting / Problemes

| Problem / Probleme | Solution |
|---------|----------|
| iPhone doesn't see "Mirror Phone" / iPhone ne voit pas "Mirror Phone" | Make sure both devices are on the same Wi-Fi / Verifiez que les deux appareils sont sur le meme Wi-Fi |
| Black screen / Ecran noir | Restart the app / Relancez l'app |
| Compilation error / Erreur de compilation | Run `brew update && brew upgrade` then retry / puis reessayez |

---

## Credits

- [UxPlay](https://github.com/FDH2/UxPlay) — the open-source AirPlay server this project relies on
- Built with love by [@marinasba](https://github.com/marinasba)

## License

MIT — see [LICENSE](LICENSE)
