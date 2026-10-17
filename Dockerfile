# Keep the server on the same major version as the application's 9.x client.
FROM docker.elastic.co/elasticsearch/elasticsearch:9.5.5@sha256:13b4a40bb095774f5fda635e45fd5677cc6a26565e42b24997b0c72b88e75984

COPY --chown=1000:0 config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

USER 1000:0
