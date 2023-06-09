# <p align="center"> Procédure de Dirty.sh </p>
 
 ## Verification de la version du noyau
 
1. Récuperation de la version du noyau en utilisant la commande uname -r et la stocke dans la variable kernel_version.
2. Affichage  la version du noyau à l'aide de la commande echo.
3. Récupération de la date du noyau à partir du fichier /proc/version en utilisant la commande cat /proc/version | awk '{print $3}' et la stocke dans la variable kernel_date.
4. Affichage de la date du noyau à l'aide de la commande echo.
5. Vérification de la vulnérabilité Dirty COW en comparant la date du noyau avec la date de référence "2016-10-20".
6. Si la date du noyau est antérieure à "2016-10-20", il affiche le message "Votre système est potentiellement vulnérable à Dirty COW."
Sinon, s'il est égal ou postérieur à "2016-10-20", il affiche le message "Votre système n'est pas vulnérable à Dirty COW."

## Si on est vulnérable voir dirty.sh

1. Définition des variables : Le script commence par définir certaines variables,
telles que le chemin vers le shell (`SHELL`), le fichier de socket X11 (`TFILE`), et le nom du fichier temporaire (`FNAME`).

2. Gestion du signal SIGSEGV : Le script définit une fonction (`sigsegv_handler()`) qui sera appelée en cas de réception du signal SIGSEGV (segmentation fault).

3. Lancement d'un shell : Une fonction (`spawn_shell()`) est définie pour exécuter le shell spécifié dans la variable `SHELL`.

4. Course conditionnelle (race condition) : Une fonction (`race()`) est définie pour créer une boucle tant que la variable `g_done` est fausse.
À chaque itération de la boucle, le script vérifie si le fichier spécifié par `TFILE` existe. Si c'est le cas, il crée un fichier temporaire, y écrit "xyzzy", puis le supprime.
Ensuite, il utilise la commande `madvise` pour modifier les attributs de la mémoire.

5. Exploitation de la race condition : Une autre fonction (`do_race()`) est définie pour exécuter plusieurs instances de la fonction `race()` en parallèle.
Ces instances sont lancées dans une boucle et les identifiants de processus (PID) sont stockés dans un tableau (`pids`). 
Après un délai de 2 secondes, le script exécute `spawn_shell()` pour ouvrir un nouveau shell, met à jour la variable `g_done` pour arrêter les boucles 
et attend la fin de tous les processus en utilisant la commande `wait`.

6. Protection contre Dirty COW : Le script utilise la commande `mktemp` pour créer un fichier temporaire et la commande `sudo mmap`
pour effectuer une allocation de mémoire et mapper le fichier temporaire en mémoire.
S'il n'y a pas d'échec, le script utilise à nouveau `sudo mmap` pour modifier les attributs de la mémoire.

7. Exécution de la course conditionnelle : Le script appelle la fonction `do_race()` avec l'adresse mappée en argument.

En résumé, le script tente de créer une race condition en utilisant les commandes `mmap` et `madvise` pour potentiellement se protéger du Dirty COW.
Cependant, il est important de noter que cette méthode n'est pas une solution de protection complète et fiable.
Pour une protection adéquate, il est recommandé de maintenir votre système à jour en appliquant les correctifs de sécurité fournis par votre distribution Linux.

## Version de nos VMs

La version du noyau est le 3.10.0-327.el7.x86_64. Il fait partie de la branche du noyau pour CentOS/RHEL 7.x. Cette version spécifique a été corrigée pour inclure les correctifs de sécurité de Dirty COW.

Le correctif pour Dirty COW a été inclus dans les mises à jour du noyau pour CentOS/RHEL, et il est fort probable que cette version a inclut le correctif
