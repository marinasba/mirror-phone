#!/bin/bash
# ============================================================
#  Mirror Phone — Installation automatique
#  Récepteur AirPlay pour macOS (alternative à iPhone Mirroring)
#
#  Usage : curl ou copier ce script, puis lancer :
#    chmod +x INSTALL.sh && ./INSTALL.sh
# ============================================================

set -e

echo ""
echo "📱 Installation de Mirror Phone"
echo "================================"
echo ""

# 1. Vérifier/installer Homebrew
if ! command -v brew &>/dev/null; then
    echo "⏳ Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Ajouter Homebrew au PATH pour cette session
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew déjà installé"
fi

# 2. Installer les dépendances
echo ""
echo "⏳ Installation des dépendances (cmake, gstreamer, libplist)..."
echo "   Ça peut prendre quelques minutes..."
brew install cmake gstreamer libplist 2>&1 | tail -5

# 3. Cloner et compiler UxPlay
echo ""
echo "⏳ Téléchargement et compilation de UxPlay..."
mkdir -p ~/Projects
cd ~/Projects

if [ -d UxPlay ]; then
    echo "   UxPlay déjà téléchargé, mise à jour..."
    cd UxPlay && git pull 2>/dev/null || true
else
    git clone https://github.com/FDH2/UxPlay.git
    cd UxPlay
fi

rm -rf build && mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/opt/homebrew 2>&1 | tail -3
make -j$(sysctl -n hw.ncpu) 2>&1 | tail -3

echo "✅ UxPlay compilé"

# 4. Créer l'app Mirror Phone
echo ""
echo "⏳ Création de l'app Mirror Phone..."

APP="/Applications/Mirror Phone.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

# Exécutable
cat > "$APP/Contents/MacOS/MirrorPhone" << 'SCRIPT'
#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
UXPLAY="$HOME/Projects/UxPlay/build/uxplay"
if [ ! -f "$UXPLAY" ]; then
    osascript -e 'display alert "Mirror Phone" message "UxPlay non trouvé. Relance INSTALL.sh." as critical'
    exit 1
fi
exec "$UXPLAY" -n "Mirror Phone" -nh
SCRIPT
chmod +x "$APP/Contents/MacOS/MirrorPhone"

# Info.plist
cat > "$APP/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key>
	<string>Mirror Phone</string>
	<key>CFBundleDisplayName</key>
	<string>Mirror Phone</string>
	<key>CFBundleIdentifier</key>
	<string>com.personal.mirrorphone</string>
	<key>CFBundleVersion</key>
	<string>1.0</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleExecutable</key>
	<string>MirrorPhone</string>
	<key>CFBundleIconFile</key>
	<string>AppIcon</string>
	<key>LSMinimumSystemVersion</key>
	<string>14.0</string>
	<key>NSHighResolutionCapable</key>
	<true/>
</dict>
</plist>
PLIST

# Icône (générer avec Swift si possible, sinon pas d'icône)
if command -v swiftc &>/dev/null; then
    ICON_SCRIPT=$(mktemp /tmp/mirrorphone_icon.XXXXX.swift)
    cat > "$ICON_SCRIPT" << 'ICONSWIFT'
import AppKit
let s: CGFloat = 1024
let img = NSImage(size: NSSize(width: s, height: s))
img.lockFocus()
let c = NSGraphicsContext.current!.cgContext
let cols = [NSColor(red:0.15,green:0.10,blue:0.35,alpha:1).cgColor,NSColor(red:0.35,green:0.15,blue:0.55,alpha:1).cgColor]
let g = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cols as CFArray, locations: [0,1])!
let bg = CGPath(roundedRect: CGRect(x:40,y:40,width:s-80,height:s-80), cornerWidth:200, cornerHeight:200, transform:nil)
c.addPath(bg); c.clip()
c.drawLinearGradient(g, start: CGPoint(x:0,y:s), end: CGPoint(x:s,y:0), options: [])
c.resetClip()
let pw:CGFloat=320, ph:CGFloat=600, px=(s-pw)/2, py=(s-ph)/2
let pp = CGPath(roundedRect: CGRect(x:px,y:py,width:pw,height:ph), cornerWidth:40, cornerHeight:40, transform:nil)
c.setFillColor(NSColor(white:0.08,alpha:0.9).cgColor); c.addPath(pp); c.fillPath()
c.setStrokeColor(NSColor(white:0.7,alpha:0.8).cgColor); c.setLineWidth(5); c.addPath(pp); c.strokePath()
let sr = CGRect(x:px+20,y:py+50,width:pw-40,height:ph-80)
let sp = CGPath(roundedRect: sr, cornerWidth:12, cornerHeight:12, transform:nil)
let sc = [NSColor(red:0.2,green:0.4,blue:0.8,alpha:0.6).cgColor,NSColor(red:0.4,green:0.2,blue:0.7,alpha:0.6).cgColor]
let sg = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: sc as CFArray, locations:[0,1])!
c.addPath(sp); c.clip()
c.drawLinearGradient(sg, start:CGPoint(x:0,y:py+50), end:CGPoint(x:0,y:py+ph), options:[]); c.resetClip()
c.setStrokeColor(NSColor.white.withAlphaComponent(0.9).cgColor); c.setLineWidth(8); c.setLineCap(.round); c.setLineJoin(.round)
let ay=s/2, lx=px-140, rx=px+pw+60, as2:CGFloat=80
c.move(to:CGPoint(x:lx+as2,y:ay+30)); c.addLine(to:CGPoint(x:lx,y:ay+30)); c.addLine(to:CGPoint(x:lx+25,y:ay+60))
c.move(to:CGPoint(x:lx,y:ay+30)); c.addLine(to:CGPoint(x:lx+25,y:ay)); c.strokePath()
c.move(to:CGPoint(x:rx,y:ay-30)); c.addLine(to:CGPoint(x:rx+as2,y:ay-30)); c.addLine(to:CGPoint(x:rx+as2-25,y:ay))
c.move(to:CGPoint(x:rx+as2,y:ay-30)); c.addLine(to:CGPoint(x:rx+as2-25,y:ay-60)); c.strokePath()
let nw:CGFloat=100,nh:CGFloat=28
let np=CGPath(roundedRect:CGRect(x:(s-nw)/2,y:py+ph-60,width:nw,height:nh),cornerWidth:14,cornerHeight:14,transform:nil)
c.setFillColor(NSColor(white:0.05,alpha:1).cgColor); c.addPath(np); c.fillPath()
img.unlockFocus()
guard let t=img.tiffRepresentation, let r=NSBitmapImageRep(data:t), let p=r.representation(using:.png,properties:[:]) else{exit(1)}
try! p.write(to:URL(fileURLWithPath:CommandLine.arguments[1]))
ICONSWIFT

    PNG=$(mktemp /tmp/mirrorphone_XXXXX.png)
    xcrun swiftc -framework AppKit -swift-version 5 -O -o /tmp/mirrorphone_icongen "$ICON_SCRIPT" 2>/dev/null
    /tmp/mirrorphone_icongen "$PNG"

    ICONSET=$(mktemp -d /tmp/mirrorphone_XXXXX.iconset)
    for sz in 16 32 64 128 256 512; do
        sips -z $sz $sz "$PNG" --out "$ICONSET/icon_${sz}x${sz}.png" 2>/dev/null
    done
    sips -z 1024 1024 "$PNG" --out "$ICONSET/icon_512x512@2x.png" 2>/dev/null
    sips -z 512 512 "$PNG" --out "$ICONSET/icon_256x256@2x.png" 2>/dev/null
    sips -z 256 256 "$PNG" --out "$ICONSET/icon_128x128@2x.png" 2>/dev/null
    sips -z 64 64 "$PNG" --out "$ICONSET/icon_32x32@2x.png" 2>/dev/null
    sips -z 32 32 "$PNG" --out "$ICONSET/icon_16x16@2x.png" 2>/dev/null
    iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns" 2>/dev/null

    rm -rf "$PNG" "$ICON_SCRIPT" /tmp/mirrorphone_icongen "$ICONSET"
    echo "✅ Icône générée"
fi

# Signer l'app
codesign --force --sign - "$APP" 2>/dev/null

# Enregistrer l'app
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "$APP" 2>/dev/null

echo ""
echo "============================================================"
echo "✅ Mirror Phone installée dans /Applications !"
echo ""
echo "   Pour l'utiliser :"
echo "   1. Lance Mirror Phone depuis le Launchpad ou /Applications"
echo "   2. Sur l'iPhone : Centre de contrôle → Recopie de l'écran"
echo "   3. Choisis 'Mirror Phone' dans la liste"
echo "   4. L'écran de l'iPhone s'affiche dans une fenêtre"
echo ""
echo "   La fenêtre est déplaçable et redimensionnable."
echo "   Cmd+Q pour quitter."
echo "============================================================"
echo ""
