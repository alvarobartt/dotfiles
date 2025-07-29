#!/bin/bash

generate_part() {
    local length=$1
    LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c $length
}

password=$(generate_part 6)-$(generate_part 6)-$(generate_part 6)

echo "Generated password: $password"
