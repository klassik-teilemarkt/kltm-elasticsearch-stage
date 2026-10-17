# README

This is a template repository for running Elasticsearch on Render.

* It uses [Render Disks](https://render.com/docs/disks) for persistent index storage.

* Elasticsearch runs in your [Render private network](https://render.com/docs/private-services) so it isn't exposed to the public Internet.

* You can [configure Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html) using `config/elasticsearch.yml` in your fork of this repository. Service auto-deploy is disabled; deploy manually after pushing image or configuration changes.

## Deployment

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

For details and customization see https://render.com/docs/deploy-elasticsearch.

## Small staging instance

The Blueprint keeps Frankfurt, the 512 MB compute plan, and the 1 GB disk.
`ES_JAVA_OPTS` reserves a 256 MB initial/maximum heap, exactly 50% of plan RAM.
The JVM options in `config/jvm.options.d/low-memory.options` disable eager heap
page touching and cap the code cache and direct buffers at 32 MB each. Parallel
GC and C1-only compilation reduce native/compiler overhead at the cost of
pause latency and peak sustained throughput. These settings do not reduce the
heap and are intended only for the constrained staging instance.

The node provides master, data, and ingest roles with authentication enabled.
Local ML, Watcher, profiling, APM data support, and default observability
template registries are disabled. Ordinary application indices still work;
this configuration is not suitable for local ML or observability workloads.

512 MB remains a constrained staging configuration. Validate indexing/search
load and monitor Render memory/OOM events before relying on it. Lazy heap page
touching trades initial page-fault latency for lower initial resident memory.
Use a larger compute plan if actual load exceeds this budget; update both heap
limits to 50% of the new RAM at the same time.
