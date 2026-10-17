# Elasticsearch stage on Render

This Blueprint deploys Elasticsearch 9.5.5 as the private service
`elasticsearch-frankfurt` in `Klassik-Teilemarkt` / `Staging`, region Frankfurt.

The lowest paid compute plan provides 0.5 CPU and 512 MB RAM. `ES_JAVA_OPTS`
sets equal initial and maximum heap sizes of 256 MB, exactly 50% of that RAM.
Keep the plan and both heap limits in sync when resizing. This is a constrained
stage configuration: check memory and indexing/search load before production.
Local machine learning, including local ELSER inference, is disabled.

The 10 GB persistent disk stores Elasticsearch data. A single instance has no
replica failover and is unavailable during redeploys. Use Elasticsearch-native
snapshots for backups rather than relying on filesystem snapshots.

Authentication is enabled. Render generates `ELASTIC_PASSWORD`; it is not
committed to this repository. Connect from a Render service in the same region
and workspace using the new service's internal hostname, HTTP port 9200, and
the `elastic` username. HTTP is confined to the private network; there is no
public service endpoint. Configure a least-privilege application API key before
connecting an application. This Blueprint does not change application settings
or copy the index from Elastic Cloud.

## Replacing the original Oregon service

Render cannot change a service's region in place. This Blueprint uses a new
resource name so a sync can provision Frankfurt without deleting the old disk.
Once the new service is verified, delete the old `elasticsearch` Oregon service
and its disk. Removing a resource from a Blueprint does not itself delete it.

Blueprint changes sync automatically unless Blueprint Auto Sync is disabled.
Service auto-deploy is disabled to avoid restarting Elasticsearch on every code
push; use a manual service deploy for later image/config-only changes.
