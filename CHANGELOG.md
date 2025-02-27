Unreleased

* Added `execute_dato_query!` controller method, that does not silently fail but raises an exception.
* Improved error messages for unknown blocks
* Add support for item links
* Add support for inline items

0.9.1

* Added support for X-Base-Editing-Url header

0.9.0

* Added support for Rails credentials
* Added a default Dato::Fragments::MetaTags fragment
* Added a default Dato::ImageBlockRecord defalt component
* Introduced a `execute_dato_query` controller method.
* Support live updates for bigger amount of data (switch from GET to POST requests)
* An abstract `Dato::BaseComponent` is introduced and your components can extend it. It will initialize the data
  variable.
* `Dato::Live` is renamed into `Dato::LiveStream` but is not supposed to be used directly anymore. Instead
  `Dato::Wrapper` is now used to wrap your components and give the abilities to preview, live and cache
*  The time necessary by Dato to execute queries is now instrumented and can be seen in the logs.
*  A convenient `bin/rails dato:cache:clear` rake task is available.
*  Engine is mounted automatically under `/dato`

0.7.5

* Hotfix: Resolved a bug in the upload method by returning the job_id
  instead of the upload_id, fixing the issue of file uploads returning a 404 error.
* Changed the API to return job_id instead of upload_id

0.7.4

* Added file upload features
* Updated README to reflect feature additions

0.7.3

* Ability to fetch `target` and `rel` attribute from dato link
* Update README and dummy app
* Fix whitespaces issues

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
