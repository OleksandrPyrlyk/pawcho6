# syntax=docker/dockerfile:1.7

FROM alpine/git:latest AS source

ARG GITHUB_USER

RUN --mount=type=ssh git clone git@github.com:${GITHUB_USER}/pawcho6.git /app

FROM nginx:alpine

LABEL org.opencontainers.image.source="https://github.com/${GITHUB_USER}/pawcho6"
LABEL org.opencontainers.image.description="PAwChO Lab 6 - Nginx web app built with BuildKit and SSH"
LABEL org.opencontainers.image.authors="${GITHUB_USER}"

COPY --from=source /app/index.html /usr/share/nginx/html/index.html
COPY --from=source /app/style.css /usr/share/nginx/html/style.css

EXPOSE 80