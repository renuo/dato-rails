0.7.3

* Ability to fetch `target` and `rel` attribute from dato link
* Update README and dummy app

0.7.2

* Wrap `dato-cms-attribution` and `dato-cms-blockquote` into a figure tag

0.7.1

* Fix a bug that prevented the usage of `client.execute`
* The GraphQL client is now exposed as `client.gql`

0.7.0

* Add CRUD operations for Dato Items (all, find, create, update, destroy)

0.6.0

* Extracted a Dato::Cache class to use the Dato::Rails cache independently.

0.5.0

* Allow to configure the api token via `Dato::Config.api_token`

0.4.0

* Introduced a caching mechanism so that the rendered components can be cached.
* Introduced a `/dato/publish` endpoint to expire the cache.

0.3.0

* Removed dependency on slim

0.2.0

* Added live and preview features

0.1.0

* First version
