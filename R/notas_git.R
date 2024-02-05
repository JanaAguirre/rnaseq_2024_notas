# Git
# Revisar que la instalación de git haya sido correcta

## Para poder conectar tu compu con GitHub
usethis::create_github_token() ## Abrirá una página web, escoje un nombre único
## y luego da click en el botón verde al final. Después copia el token
## (son 40 caracteres)

## MI GIT TOKEN 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

gitcreds::gitcreds_set() ## Al correr este comando te pedirá el token

#Github

## Configura tu usuario de GitHub
usethis::edit_git_config()

