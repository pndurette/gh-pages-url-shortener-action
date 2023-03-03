# gh-pages-url-shortener-action
An ultra-lightweight GitHub Pages URL shortener entirely powered by built-in GitHub Pages (Jekyll) features

<!--doc_begin-->
### Inputs
|Input|Description|Default|Required|
|-----|-----------|-------|:------:|
|`urls_config`|<p>The path to a YAML file associating redirect keys to URLs, e.g.:</p><pre>---<br />test1: https://www.bookcity.ca/<br />test2: https://www.gladdaybookshop.com<br /></pre>|`.github/urls.yml`|no|
|`default_redirect`|<p>Default behaviour for '/' or any 404, can be either:<br />* a URL to redirect to<br />* a message to display</p>|`Nothing here!`|no|
### Outputs
None
<!--doc_end-->