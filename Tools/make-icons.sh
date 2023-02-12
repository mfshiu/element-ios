#!/usr/bin/env bash
#
# Converts an svg logo into the various image resources required by
# the various platforms deployments.
#
# On debian-based systems you need these deps:
#   apt-get install xmlstarlet python3-cairosvg icnsutils
# 
# Modified: Eric Xu  Date: 2023/1/31

if [ $# != 2 ]
then
    echo "Usage: $0 <white-logo svg> <app icon svg>"
    exit
fi

set -ex

tmpdir=`mktemp -d 2>/dev/null || mktemp -d -t 'icontmp'`

# for i in 720 480 240
# do
#     #convert -background none -density 1000 -resize $i -extent $i -gravity center "$1" "$tmpdir/$i.png"

#     # Above is the imagemagick command to render an svg to png. Unfortunately, its support for SVGs
#     # with CSS isn't very good (with rsvg and even moreso the built in renderer) so we use cairosvg.
#     # This can be installed with:
#     #    pip install cairosvg
#     #    pip install tinycss
#     #    pip install cssselect # These are necessary for CSS support
#     # You'll also need xmlstarlet from your favourite package manager
#     #
#     # Cairosvg doesn't suport rendering at a specific size (https://github.com/Kozea/CairoSVG/issues/83#issuecomment-215720176)
#     # so we have to 'resize the svg' first (add width and height attributes to the svg element) to make it render at the
#     # size we need.
#     # XXX: This will break if the svg already has width and height attributes
#     cp "$1" "$tmpdir/tmp.svg"
#     xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n width -v $i "$tmpdir/tmp.svg" > "$tmpdir/tmp2.svg"
#     xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n height -v $i "$tmpdir/tmp2.svg" > "$tmpdir/tmp3.svg"
#     cairosvg -f png -o "$tmpdir/$i.png"  "$tmpdir/tmp3.svg"
#     rm "$tmpdir/tmp.svg" "$tmpdir/tmp2.svg" "$tmpdir/tmp3.svg"
# done

# for i in 192 144 96 72 48
# do
#    cp "$2" "$tmpdir/tmp.svg"
#    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n width -v $i "$tmpdir/tmp.svg" > "$tmpdir/tmp2.svg"
#    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n height -v $i "$tmpdir/tmp2.svg" > "$tmpdir/tmp3.svg"
#    cairosvg -f png -o "$tmpdir/$i-round.png"  "$tmpdir/tmp3.svg"
#    rm "$tmpdir/tmp.svg" "$tmpdir/tmp2.svg" "$tmpdir/tmp3.svg"
# done
#
for i in 720 480 240
do
   cp "$1" "$tmpdir/tmp.svg"
   cairosvg -f png -o "$tmpdir/$i-white.png" --output-width $i --output-height $i "$tmpdir/tmp.svg"
   rm "$tmpdir/tmp.svg"
done

for i in 20 29 40 58 60 76 80 87 120 152 167 180 1024
do
   cp "$2" "$tmpdir/tmp.svg"
   cairosvg -f png -o "$tmpdir/$i-appicon.png" --output-width $i --output-height $i "$tmpdir/tmp.svg"
   rm "$tmpdir/tmp.svg"
done

# launch_screen_logo
cp "$tmpdir/240-white.png" "Riot/Assets/Images.xcassets/launch_screen_logo.imageset/launch_screen_logo.png"
cp "$tmpdir/480-white.png" "Riot/Assets/Images.xcassets/launch_screen_logo.imageset/launch_screen_logo@2x.png"
cp "$tmpdir/720-white.png" "Riot/Assets/Images.xcassets/launch_screen_logo.imageset/launch_screen_logo@3x.png"

# app icon
cp "$tmpdir/1024-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iOS-Marketing-1024@1x.png"
cp "$tmpdir/20-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-20@1x.png"
cp "$tmpdir/40-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-20@2x.png"
cp "$tmpdir/29-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-29@1x.png"
cp "$tmpdir/58-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-29@2x.png"
cp "$tmpdir/40-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-40@1x.png"
cp "$tmpdir/80-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-40@2x.png"
cp "$tmpdir/76-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-76@1x.png"
cp "$tmpdir/152-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-76@2x.png"
cp "$tmpdir/167-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPad-83.5@2x.png"
cp "$tmpdir/40-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-20@2x.png"
cp "$tmpdir/60-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-20@3x.png"
cp "$tmpdir/58-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-29@2x.png"
cp "$tmpdir/87-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-29@3x.png"
cp "$tmpdir/80-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-40@2x.png"
cp "$tmpdir/120-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-40@3x.png"
cp "$tmpdir/120-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-60@2x.png"
cp "$tmpdir/180-appicon.png" "Riot/Assets/SharedImages.xcassets/AppIcon.appiconset/AppIcon~iPhone-60@3x.png"
#
cp "$tmpdir/40-appicon.png" "Riot/Assets/Images.xcassets/Call/callkit_icon.imageset/callkit_icon.png"
cp "$tmpdir/80-appicon.png" "Riot/Assets/Images.xcassets/Call/callkit_icon.imageset/callkit_icon@2x.png"
cp "$tmpdir/120-appicon.png" "Riot/Assets/Images.xcassets/Call/callkit_icon.imageset/callkit_icon@3x.png"

rm -r "$tmpdir"
