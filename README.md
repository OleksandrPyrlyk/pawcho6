# PAwChO – Laboratorium 6

## Treść pliku Dockerfile

```dockerfile
# syntax=docker/dockerfile:1.7

FROM alpine/git:latest AS source

ARG GITHUB_USER

RUN mkdir -p -m 0700 /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:${GITHUB_USER}/pawcho6.git /app

FROM nginx:alpine

ARG GITHUB_USER

LABEL org.opencontainers.image.source="https://github.com/${GITHUB_USER}/pawcho6"
LABEL org.opencontainers.image.description="PAwChO Lab 6 - Nginx web app built with BuildKit and SSH"
LABEL org.opencontainers.image.authors="${GITHUB_USER}"

COPY --from=source /app/index.html /usr/share/nginx/html/index.html
COPY --from=source /app/style.css /usr/share/nginx/html/style.css

EXPOSE 80
```

---

## Polecenie użyte do budowy obrazu

```powershell
docker buildx build `
--ssh default=$env:USERPROFILE\.ssh\gh_pawcho6 `
--build-arg GITHUB_USER=OleksandrPyrlyk `
-t pawcho6:test `
--load .
```

### Wynik działania

[ WSTAW SCREENSHOT Z POPRAWNIE WYKONANEGO `docker buildx build` ]

---

# Potwierdzenie wykonania pozostałych zadań

## 1. Utworzenie repozytorium GitHub

Repozytorium:

```text
https://github.com/OleksandrPyrlyk/pawcho6
```

### Screenshot

[ WSTAW SCREENSHOT REPOZYTORIUM ]

---

## 2. Konfiguracja SSH

Poprawna autoryzacja SSH:

```text
Hi OleksandrPyrlyk! You've successfully authenticated, but GitHub does not provide shell access.
```

### Screenshot

[ WSTAW SCREENSHOT SSH ]

---

## 3. Uruchomienie kontenera

Polecenie:

```powershell
docker run -d -p 8080:80 --name pawcho6-test pawcho6:test
```

Sprawdzenie:

```powershell
docker ps
```

### Screenshot

[ WSTAW SCREENSHOT `docker ps` ]

---

## 4. Działanie aplikacji

Adres:

```text
http://localhost:8080
```

### Screenshot

[ WSTAW SCREENSHOT STRONY ]

---

## 5. Logowanie do GitHub Container Registry

```powershell
echo $CR_PAT | docker login ghcr.io -u OleksandrPyrlyk --password-stdin
```

Wynik:

```text
Login Succeeded
```

### Screenshot

[ WSTAW SCREENSHOT LOGOWANIA ]

---

## 6. Publikacja obrazu do ghcr.io

Tagowanie:

```powershell
docker tag pawcho6:test ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

Publikacja:

```powershell
docker push ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

### Screenshot

[ WSTAW SCREENSHOT `docker push` ]

---

## 7. Repozytorium ghcr.io

Obraz został opublikowany jako:

```text
ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

Status:

```text
Public
```

### Screenshot

[ WSTAW SCREENSHOT PACKAGE `pawcho6` ]

---

## 8. Powiązanie package z repozytorium

Repozytorium:

```text
OleksandrPyrlyk/pawcho6
```

### Screenshot

[ WSTAW SCREENSHOT CONNECT REPOSITORY ]
