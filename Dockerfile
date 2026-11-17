# CommaFeed for Railway: the official native PostgreSQL image, pinned by version and digest.
# Upstream: https://github.com/Athou/commafeed (image athou/commafeed on Docker Hub)
FROM athou/commafeed:7.5.1-postgresql@sha256:2d28874b20d55622ed2ccc10c90606ee68f0493b5d1e1a18753b9cb02a07e250

COPY start.sh /commafeed/railway-start.sh

EXPOSE 8082
CMD ["/bin/sh", "/commafeed/railway-start.sh"]
