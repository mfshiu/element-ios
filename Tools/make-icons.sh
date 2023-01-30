#!/usr/bin/env bash
#
# Converts an svg logo into the various image resources required by
# the various platforms deployments.
#
# On debian-based systems you need these deps:
#   apt-get install xmlstarlet python3-cairosvg icnsutils
# 
# Modified: Eric Xu  Date: 2022/12/29 17:33

if [ $# != 1 ]
then
    echo "Usage: $0 <white-logo svg file>"
    exit
fi

set -ex

tmpdir=`mktemp -d 2>/dev/null || mktemp -d -t 'icontmp'`

for i in 720 480 240
do
    #convert -background none -density 1000 -resize $i -extent $i -gravity center "$1" "$tmpdir/$i.png"

    # Above is the imagemagick command to render an svg to png. Unfortunately, its support for SVGs
    # with CSS isn't very good (with rsvg and even moreso the built in renderer) so we use cairosvg.
    # This can be installed with:
    #    pip install cairosvg==1.0.22 # Version 2 doesn't support python 2
    #    pip install tinycss
    #    pip install cssselect # These are necessary for CSS support
    # You'll also need xmlstarlet from your favourite package manager
    #
    # Cairosvg doesn't suport rendering at a specific size (https://github.com/Kozea/CairoSVG/issues/83#issuecomment-215720176)
    # so we have to 'resize the svg' first (add width and height attributes to the svg element) to make it render at the
    # size we need.
    # XXX: This will break if the svg already has width and height attributes
    cp "$1" "$tmpdir/tmp.svg"
    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n width -v $i "$tmpdir/tmp.svg" > "$tmpdir/tmp2.svg"
    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n height -v $i "$tmpdir/tmp2.svg" > "$tmpdir/tmp3.svg"
    cairosvg -f png -o "$tmpdir/$i.png"  "$tmpdir/tmp3.svg"
    rm "$tmpdir/tmp.svg" "$tmpdir/tmp2.svg" "$tmpdir/tmp3.svg"
done

#for i in 192 144 96 72 48
#do
#    cp "$2" "$tmpdir/tmp.svg"
#    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n width -v $i "$tmpdir/tmp.svg" > "$tmpdir/tmp2.svg"
#    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n height -v $i "$tmpdir/tmp2.svg" > "$tmpdir/tmp3.svg"
#    cairosvg -f png -o "$tmpdir/$i-round.png"  "$tmpdir/tmp3.svg"
#    rm "$tmpdir/tmp.svg" "$tmpdir/tmp2.svg" "$tmpdir/tmp3.svg"
#done
#
#for i in 432 324 216 162 108
#do
#    cp "$3" "$tmpdir/tmp.svg"
#    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n width -v $i "$tmpdir/tmp.svg" > "$tmpdir/tmp2.svg"
#    xmlstarlet ed -N x="http://www.w3.org/2000/svg" --insert "/x:svg" --type attr -n height -v $i "$tmpdir/tmp2.svg" > "$tmpdir/tmp3.svg"
#    cairosvg -f png -o "$tmpdir/$i-white.png"  "$tmpdir/tmp3.svg"
#    rm "$tmpdir/tmp.svg" "$tmpdir/tmp2.svg" "$tmpdir/tmp3.svg"
#done

cp "$tmpdir/240.png" "Riot/Assets/Images.xcassets/launch_screen_logo.imageset/launch_screen_logo.png"
cp "$tmpdir/480.png" "Riot/Assets/Images.xcassets/launch_screen_logo.imageset/launch_screen_logo@2x.png"
cp "$tmpdir/720.png" "Riot/Assets/Images.xcassets/launch_screen_logo.imageset/launch_screen_logo@3x.png"

#cp "$tmpdir/48-round.png" "vector-app/src/main/res/mipmap-mdpi/ic_launcher_round.png"
#cp "$tmpdir/72-round.png" "vector-app/src/main/res/mipmap-hdpi/ic_launcher_round.png"
#cp "$tmpdir/96-round.png" "vector-app/src/main/res/mipmap-xhdpi/ic_launcher_round.png"
#cp "$tmpdir/144-round.png" "vector-app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png"
#cp "$tmpdir/192-round.png" "vector-app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png"
#
#cp "$tmpdir/108-white.png" "library/ui-styles/src/main/res/drawable-mdpi/element_splash_white.png"
#cp "$tmpdir/162-white.png" "library/ui-styles/src/main/res/drawable-hdpi/element_splash_white.png"
#cp "$tmpdir/216-white.png" "library/ui-styles/src/main/res/drawable-xhdpi/element_splash_white.png"
#cp "$tmpdir/324-white.png" "library/ui-styles/src/main/res/drawable-xxhdpi/element_splash_white.png"
#cp "$tmpdir/432-white.png" "library/ui-styles/src/main/res/drawable-xxxhdpi/element_splash_white.png"

rm -r "$tmpdir"
