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

---

# Potwierdzenie wykonania pozostałych zadań

## 1. Konfiguracja SSH

Poprawna autoryzacja SSH:

```text
Hi OleksandrPyrlyk! You've successfully authenticated, but GitHub does not provide shell access.
```

### Screenshot

<img width="683" height="34" alt="image" src="https://github.com/user-attachments/assets/b9861fad-abf5-43e7-918e-fd4f8101244d" />

---

## 2. Uruchomienie kontenera

Polecenie:

```powershell
docker run -d -p 8080:80 --name pawcho6-test pawcho6:test
```

Sprawdzenie:

```powershell
docker ps
```

### Screenshot

<img width="1002" height="67" alt="image" src="https://github.com/user-attachments/assets/1d9d6f31-f525-48e2-bd4a-6dcc0b20429b" />

---

## 3. Działanie aplikacji

Adres:

```text
http://localhost:8080
```

### Screenshot

<img width="973" height="370" alt="image" src="https://github.com/user-attachments/assets/d84d4d9a-3fec-4228-bb4f-f89260ee5202" />

---

## 4. Logowanie do GitHub Container Registry

```powershell
echo $CR_PAT | docker login ghcr.io -u OleksandrPyrlyk --password-stdin
```

Wynik:

```text
Login Succeeded
```

### Screenshot

<img width="669" height="31" alt="image" src="https://github.com/user-attachments/assets/be2628d8-eb67-4ddc-9ce0-8bc56033edc9" />

---

## 5. Publikacja obrazu do ghcr.io

Tagowanie:

```powershell
docker tag pawcho6:test ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

Publikacja:

```powershell
docker push ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

---

## 6. Repozytorium ghcr.io

Obraz został opublikowany jako:

```text
ghcr.io/oleksandrpyrlyk/pawcho6:lab6
```

Status:

```text
Public
```

### Screenshot

<img width="742" height="423" alt="image" src="https://github.com/user-attachments/assets/37ef47aa-749e-4a0d-83b6-7a39fa43ccca" />
