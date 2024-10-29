#!/bin/bash

# Girdi ve çıktı dosyaları
input_file="ips.rsc"
output_file="Crowdsec_FreeBlacklist.rsc"

# Alt ağlar
subnets=(
    "162.142.125.0/24"
    "167.94.138.0/24"
    "167.94.145.0/24"
    "167.94.146.0/24"
    "167.248.133.0/24"
    "199.45.154.0/24"
    "199.45.155.0/24"
    "206.168.34.0/24"
)

# Çıktı dosyasını sıfırlama
> "$output_file"

# IP adreslerini silmek için bir regex deseni oluştur
regex_patterns=()
for subnet in "${subnets[@]}"; do
    base_ip=$(echo "$subnet" | cut -d'/' -f1)
    # CIDR notasyonu için 256'ya kadar IP'leri kapsayacak şekilde düzenli ifade oluştur
    regex_patterns+=("${base_ip%.*}.[0-9]{1,3}")
done

# Filtreleme işlemi
{
    while IFS= read -r line; do
        # Eğer satır "add address=" ile başlıyorsa
        if [[ $line == add\ address=* ]]; then
            # IP adresini çıkar
            ip=$(echo "$line" | awk -F'=' '{print $2}' | awk '{print $1}')
            should_filter=false
            
            # IP adresini regex desenleriyle kontrol et
            for pattern in "${regex_patterns[@]}"; do
                if [[ $ip =~ $pattern ]]; then
                    should_filter=true
                    break
                fi
            done
            
            # Eğer IP alt ağda değilse, satırı yaz
            if ! $should_filter; then
                echo "$line"
            fi
        else
            # Eğer "add address=" ile başlamıyorsa, olduğu gibi yaz
            echo "$line"
        fi
    done < "$input_file"
} > "$output_file"

# Alt ağları dosyaya ekle
{
    for subnet in "${subnets[@]}"; do
        echo "add address=${subnet} list=Crowdsec timeout=23h"
    done
} >> "$output_file"

echo "Filtreleme işlemi tamamlandı. Sonuç: $output_file"
