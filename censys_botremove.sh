#!/bin/bash

# Girdi ve çıktı dosyaları
input_file="Crowdsec_FreeBlacklist.rsc"
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

# Filtreleme işlemi
{
    while IFS= read -r line; do
        # Eğer satır "add address=" ile başlıyorsa
        if [[ $line == add\ address=* ]]; then
            # IP adresini çıkar
            ip=$(echo "$line" | awk -F'=' '{print $2}' | awk '{print $1}')
            should_filter=false
            
            # IP adresini alt ağlarla kontrol et
            for subnet in "${subnets[@]}"; do
                if ipcalc -c "$ip" "$subnet" &>/dev/null; then
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

echo "Filtreleme işlemi tamamlandı. Sonuç: $output_file"

echo 'add address=162.142.125.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=167.94.138.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=167.94.145.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=167.94.146.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=167.248.133.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=199.45.154.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=199.45.155.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
echo 'add address=206.168.34.0/24 list=Crowdsec timeout=23h' >> Crowdsec_FreeBlacklist.rsc
