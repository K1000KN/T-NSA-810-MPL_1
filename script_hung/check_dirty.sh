#!/bin/bash

# Vérification de la version du noyau
kernel_version=$(uname -r)
echo "Version du noyau : $kernel_version"

# Vérification de la date du noyau
kernel_date=$(cat /proc/version | awk '{print $11, $7, $8}')
echo "Date du noyau : $kernel_date"

# Vérification de la vulnérabilité Dirty COW
if [[ "$kernel_date" < "2016 Oct 20" ]]; then
  echo "Votre système est potentiellement vulnérable à Dirty COW."
else
  echo "Votre système n'est pas vulnérable à Dirty COW."
fi
