# Split sheet

convert peasant_sheet.png -crop 50x50 peasant.png

# Resize many

ls knight-*.png | xargs -I{} convert {} -filter point -resize 200%  {}

# Recombine

files=$(ls tiles*.png | sort -t '-' -n -k 2 | tr '\n' ' ')
montage $files -tile x1 -geometry 32x32+0+0 sheet.png
