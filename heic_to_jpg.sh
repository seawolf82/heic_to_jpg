#!/bin/bash

# Script per convertire file HEIC in JPG usando ImageMagick su Fedora/RHEL/CentOS
# con directory di input e output specificate.

# Verifica se ImageMagick è installato
if ! command -v magick &>/dev/null; then
  echo "Errore: ImageMagick non è installato. Installarlo con: sudo dnf install -y ImageMagick"
  exit 1
fi

# Funzione per la conversione di un singolo file
converti_file() {
  local input_file="$1"
  local output_dir="$2"
  local output_file="$output_dir/${input_file##*/}" # Ottieni solo il nome del file
  output_file="${output_file%.*}.jpg" # Sostituisci l'estensione con .jpg

  # Verifica se il file di input esiste
  if [ ! -f "$input_file" ]; then
    echo "Errore: File '$input_file' non trovato."
    return 1
  fi

    # Verifica se il file è effettivamente un HEIC (controllo più robusto)
    file_type=$(file --mime-type "$input_file")
    if [[ ! "$file_type" == *"image/heic"* ]]; then
        echo "Avviso: '$input_file' non sembra essere un file HEIC. Saltato."
        return 0 # Non è un errore, semplicemente salta il file
    fi


  # Crea la directory di output se non esiste
  mkdir -p "$output_dir"

  # Conversione con ImageMagick
  magick "$input_file" -quality 100 "$output_file"
  if [ $? -eq 0 ]; then
    echo "Convertito: '$input_file' -> '$output_file'"
  else
    echo "Errore durante la conversione di '$input_file'."
    return 1
  fi
}

# Verifica il numero di argomenti
if [ $# -lt 2 ]; then
  echo "Utilizzo: $0 <directory_input> <directory_output>"
  exit 1
fi

input_dir="$1"
output_dir="$2"

# Verifica se la directory di input esiste
if [ ! -d "$input_dir" ]; then
  echo "Errore: La directory di input '$input_dir' non esiste."
  exit 1
fi

# Trova tutti i file .heic e .HEIC nella directory di input e nelle sottodirectory
find "$input_dir" -type f \( -name "*.heic" -o -name "*.HEIC" \) -print0 | while IFS= read -r -d $'\0' file; do
    converti_file "$file" "$output_dir"
done

exit 0
