# CommaFeed for Railway: the official native PostgreSQL image, pinned by version and digest.
# Upstream: https://github.com/Athou/commafeed (image athou/commafeed on Docker Hub)
FROM athou/commafeed:7.5.0-postgresql@sha256:aac217c3d9b38b5a6185d723b31e8d6dc1acfd9873178c18521ff03a95f92100

COPY start.sh /commafeed/railway-start.sh

EXPOSE 8082
CMD ["/bin/sh", "/commafeed/railway-start.sh"]
