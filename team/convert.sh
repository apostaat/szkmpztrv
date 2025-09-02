shopt -s nullglob nocaseglob  # makes pattern matching case-insensitive
for f in *.heic; do
  echo "Converting $f..."
  heif-convert "$f" "${f%.*}.jpg" && rm "$f"
done
