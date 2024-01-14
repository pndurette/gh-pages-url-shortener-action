# gh-pages-url-shortener-action
> Lightweight [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) URL shortener powered by [GitHub Actions](https://docs.github.com/en/actions).

[![Tests](https://github.com/pndurette/gh-pages-url-shortener-action/actions/workflows/test.yml/badge.svg)](https://github.com/pndurette/gh-pages-url-shortener-action/actions/workflows/test.yml)

## About

* Minimal inside and out: no templates, no layouts, no code
* Uses only built-in GitHub Pages features (powered by [Jekyll](https://jekyllrb.com)) and first-party actions
* Easy setup: add  `pndurette/gh-pages-url-shortener-action` to a worflow, create `urls.yml`

See [How it works](#how-it-works).

## Setup

1. Create [new GitHub repository](https://github.com/new)
   1. *For example:* `<your account>/url-shortener`
2. Enable GitHub Pages (`<new repo>` > Settings > Pages)
   1. *Source:* GitHub Actions
3. [Optional] [Configure custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
4. Create a new GitHub Actions workflow:

   <details><summary><code>.github/workflows/deploy.yml</code></summary>
   <p>

   (This is GitHub's own [GitHub Pages Jekyll](https://github.com/actions/starter-workflows/blob/da484b4eb58a75ee389d1483a295b33c9774ea0f/pages/jekyll-gh-pages.yml) starter workflow with `actions/jekyll-build-page` swapped for this action).

   See [Configuration](#configuration) below for action inputs.

   ```yaml
   name: Deploy URL Shortener

   on:
   # Runs on pushes targeting the default branch
   push:
      branches: [main]

   # Allows you to run this workflow manually from the Actions tab
   workflow_dispatch:

   # Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
   permissions:
   contents: read
   pages: write
   id-token: write

   # Allow one concurrent deployment
   concurrency:
   group: "pages"
   cancel-in-progress: true

   jobs:
   # Build job
   build:
      runs-on: ubuntu-latest
      steps:
         - name: Checkout
         uses: actions/checkout@v3
         - name: Setup Pages
         uses: actions/configure-pages@v3
         - name: Generate URL Shortener
         uses: pndurette/gh-pages-url-shortener-action@v1
         - name: Upload artifact
         uses: actions/upload-pages-artifact@v1

   # Deployment job
   deploy:
      environment:
         name: github-pages
         url: ${{ steps.deployment.outputs.page_url }}
      runs-on: ubuntu-latest
      needs: build
      steps:
         - name: Deploy to GitHub Pages
         id: deployment
         uses: actions/deploy-pages@v1
   ```

   </p>
   </details>


5. Create a URL redirect configuration file:

   <details><summary><code>.github/urls.yml</code></summary>
   <p>

   Each `<key>` will be the path redirecting to a url `<value>`. For example:

   ```yaml
   ---
   abc: "https://google.com"
   def: "https://yahoo.com"
   uvw/xyz: "https://some-other-site.com"  # The <key> can be a path
   ```

   Will generate the following links:

   * `http://<your site>/abc` will redirect to `https://google.com`
   * `http://<your site>/def` will redirect to `https://yahoo.com`
   * `http://<your site>/uvw/xyz` will redirect to `https://some-other-site.com`

   </p>
   </details>

6. Push to `main` (watch the action run summary for more info!)

## Configuration

<!--doc_begin-->
### Inputs
|Input|Description|Default|Required|
|-----|-----------|-------|:------:|
|`urls_config`|<p>The path to a YAML file associating redirect keys to URLs, e.g.:</p><pre>---<br />test1: https://www.bookcity.ca/<br />test2: https://www.gladdaybookshop.com<br /></pre>|`.github/urls.yml`|no|
|`default_redirect`|<p>Default behaviour for <code>/</code> or any 404, can be either:<br />  * a URL (absolute) to redirect to (e.g. <code>https://www.aol.com/</code>)<br />  * a URL (relative) to redirect to from the domain (e.g. <code>/blog</code>)<br />  * a message to display (e.g. <code>Nothing here!</code>)</p>|`Nothing here!`|no|

<!--doc_end-->

## How it works

All the logic is shared between a Jekyll [`_config.yml`](.github/_config.yml) and the action itself in [`action.yml`](action.yml).

### Jekyll

**Jekyll Collections**

Each URL to redirect is created by the action as an individual document defined in a [Collection](https://jekyllrb.com/docs/collections/):

```yaml
# _config.yml
collections:
  redirects:
    output: true
    permalink: /:path

```

*The above reads: "In `_redirects` (Jekyll's convention), generate one file per document (`output: true`) for which the final URL path will be `/:path` (i.e. path to the file, including the file, minus the extension)"*

For example, for an entry `link1: "https://google.com"` in `urls.yml`, the action would create `_redirect/link1.yml` as:

```yaml
---
redirect_to: https://google.com
---
```

**The `jekyll-redirect-from` plugin**

The `redirect_to`  [front matter](https://jekyllrb.com/docs/front-matter/) variable is provided by the [jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from) plugin, which is whitelisted by GitHub Pages:

```yaml
# _config.yml
plugins:
  - "jekyll-redirect-from"
```

The plugin will generate an HTML file per Collection document, with every possible client-side way to redirect a url. The `_redirect/link1.yml` file above would be generated by Jekyll to `link1.html` as:

```html
<!DOCTYPE html>
<html lang="en-US">
  <meta charset="utf-8">
  <title>Redirecting&hellip;</title>
  <link rel="canonical" href="https://google.com">
  <script>location="https://google.com"</script>
  <meta http-equiv="refresh" content="0; url=https://google.com">
  <meta name="robots" content="noindex">
  <h1>Redirecting&hellip;</h1>
  <a href="https://google.com">Click here if you are not redirected.</a>
</html>
```

Allowing it to be reached at `https://<site>/link1`. It does the same for the `index.html` and `404.hml` (for `/` or non-existing path, respetively), which can also be redirects (absolute or relative to the domain) or plain strings (default is `Nothing here!`).

### Action

The [composite](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action) action in  [`action.yml`](action.yml)  reads `urls.yml` and translates it to individual per-URL `.md` file. It will then call the official [`actions/jekyll-build-pages`](https://github.com/actions/jekyll-build-pages) action to generate the content. It also shows a table summary of what was generated.

### Generated files

The generated file hierarchy is minimal. For instance, for a `urls.yml` that might contain:

```yaml
---
abc: "https://google.com"
def: "https://yahoo.com"
uvw/xyz: "https://some-other-site.com"
```

The action will generate (if the action input `default_redirect` is set to a URL):

```
.
├── 404.md
├── _config.yml
├── _redirects
│   ├── abc.md
│   ├── def.md
│   └── uvw
|       └── xyz.md
└── index.md
```

And the GitHub Pages-hosted directory will look like:

```
.
├── 404.html
├── abc.html
├── def.html
├── index.html
├── redirects.json
└── uvw
    └── xyx.html
```

## License

[The MIT License (MIT)](LICENSE) Copyright © 2023-2024 Pierre Nicolas Durette

