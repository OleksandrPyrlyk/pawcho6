# PAwChO – Laboratorium 6

## Konfiguracja i wykorzystanie klienta CLI dla usług GitHub. Rejestr obrazów ghcr.io. BuildKit i SSH

**Autor:** Oleksandr Pyrlyk
**Przedmiot:** Programowanie Aplikacji w Chmurze Obliczeniowej
**Laboratorium:** 6

---

# 1. Cel ćwiczenia

Celem laboratorium było:

* utworzenie repozytorium GitHub przy użyciu narzędzi CLI,
* konfiguracja uwierzytelniania SSH,
* wykorzystanie Docker BuildKit,
* budowanie obrazu Docker z użyciem protokołu SSH,
* publikacja obrazu w GitHub Container Registry (ghcr.io),
* powiązanie obrazu kontenerowego z repozytorium GitHub.

---

# 2. Utworzenie repozytorium GitHub

Utworzono publiczne repozytorium:

```text
pawcho6
```

Link do repozytorium:

```text
https://github.com/OleksandrPyrlyk/pawcho6
```

### Screenshot 1 – Repozytorium GitHub

[ WSTAW SCREENSHOT ]

---

# 3. Konfiguracja SSH

Wygenerowano klucz SSH oraz dodano go do konta GitHub.

Weryfikacja połączenia:

```bash
ssh -T git@github.com
```

Wynik:

```text
Hi OleksandrPyrlyk! You've successfully authenticated,
but GitHub does not provide shell access.
```

### Screenshot 2 – Poprawna autoryzacja SSH

[ WSTAW SCREENSHOT ]

---

# 4. Struktura projektu

Projekt zawiera następujące pliki:

```text
Dockerfile
index.html
style.css
```

### Screenshot 3 – Zawartość repozytorium

[ WSTAW SCREENSHOT ]

---

# 5. Treść pliku Dockerfile

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

# 6. Budowanie obrazu Docker

Do budowy obrazu wykorzystano BuildKit oraz SSH.

Polecenie:

```bash
docker buildx build ^
--ssh default=%USERPROFILE%\.ssh\gh_pawcho6 ^
--build-arg GITHUB_USER=OleksandrPyrlyk ^
-t pawcho6:test ^
--load .
```

### Screenshot 4 – Proces budowania obrazu

[ WSTAW SCREENSHOT ]

---

# 7. Uruchomienie kontenera

Uruchomienie kontenera:

```bash
docker run -d -p 8080:80 --name pawcho6-test pawcho6:test
```

Sprawdzenie działania:

```bash
docker ps
```

### Screenshot 5 – Działający kontener

[ WSTAW SCREENSHOT ]

---

# 8. Test aplikacji

Aplikacja została uruchomiona lokalnie pod adresem:

```text
http://localhost:8080
```

### Screenshot 6 – Strona aplikacji

[ WSTAW SCREENSHOT ]

---

# 9. Logowanie do GitHub Container Registry

Logowanie do rejestru:

```bash
echo %CR_PAT% | docker login ghcr.io -u OleksandrPyrlyk --password-stdin
```

Wynik:

```text
Login Succeeded
```

### Screenshot 7 – Logowanie do ghcr.io

[ WSTAW SCREENSHOT ]

---

# 10. Publikacja obrazu do ghcr.io

Tagowanie obrazu:

```bash
docker tag pawcho6:test ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

Publikacja:

```bash
docker push ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

### Screenshot 8 – Docker Push

[ WSTAW SCREENSHOT ]

---

# 11. GitHub Container Registry

Obraz został opublikowany jako:

```text
ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

Widoczność pakietu:

```text
Public
```

### Screenshot 9 – Package w ghcr.io

[ WSTAW SCREENSHOT ]

---

# 12. Powiązanie package z repozytorium

Package został połączony z repozytorium:

```text
OleksandrPyrlyk/pawcho6
```

### Screenshot 10 – Connect Repository

[ WSTAW SCREENSHOT ]

---

# 13. Wnioski

Podczas laboratorium skonfigurowano uwierzytelnianie SSH dla GitHub, utworzono repozytorium GitHub, przygotowano wieloetapowy plik Dockerfile wykorzystujący BuildKit oraz SSH, zbudowano obraz Docker na podstawie kodu pobieranego z repozytorium GitHub, a następnie opublikowano obraz w GitHub Container Registry (ghcr.io). Dodatkowo obraz został udostępniony publicznie oraz powiązany z repozytorium projektu.
