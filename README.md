# gh-pages-url-shortener-action
> Lightweight GitHub Pages URL shortener powered by GitHub Actions

## About

* Minimal in and out: no template, no layout, no code
* Powered by built-in GitHub Pages (Jekyll) features:
* Shorter URLs than the name of this repository

See [How it works](#how-it-works).

## Features

* Easy setup: add  `pndurette/gh-pages-url-shortener-action` to a worflow, create `urls.yml`
* Special characters are handled by Jekyll, the action displays a [job summary](https://github.blog/2022-05-09-supercharging-github-actions-with-job-summaries/) to show what was generated 

## Setup

1. Create [new GitHub repository](https://github.com/new)
   1. *For example:* `<your account>/url-shortener`
2. Enable GitHub Pages (`<new repo>` > Settings > Pages)
   1. *Source:* GitHub Actions
3. [Optional] [Configure custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
4. Create a new GitHub Actions workflow:

   <details><summary><code>.github/workflows/deploy.yml</code></summary>
   <p>

   (This is GitHub's own [GitHub Pages Jekyll](https://github.com/actions/starter-workflows/blob/da484b4eb58a75ee389d1483a295b33c9774ea0f/pages/jekyll-gh-pages.yml) starter workflow with `actions/jekyll-build-page` swapped for this action). See [Configuration](#configuration) below.

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
abc: "https://google.com"
def: "https://yahoo.com"
ayz: "https://some-other-site.com"
```

Will generate the following links:

* `http://<your site>/abc` will redirect to `https://google.com`
* `http://<your site>/def` will redirect to `https://yahoo.com`
* `http://<your site>/zyz` will redirect to `https://some-other-site.com`

</p>
</details>

6. Push to `main`

<!--doc_begin-->
### Inputs
|Input|Description|Default|Required|
|-----|-----------|-------|:------:|
|`urls_config`|<p>The path to a YAML file associating redirect keys to URLs, e.g.:</p><pre>---<br />test1: https://www.bookcity.ca/<br />test2: https://www.gladdaybookshop.com<br /></pre>|`.github/urls.yml`|no|
|`default_redirect`|<p>Default behaviour for '/' or any 404, can be either:<br />* a URL to redirect to<br />* a message to display</p>|`Nothing here!`|no|

<!--doc_end-->



## How it works



## License

[The MIT License (MIT)](LICENSE) Copyright © 2023 Pierre Nicolas Durette