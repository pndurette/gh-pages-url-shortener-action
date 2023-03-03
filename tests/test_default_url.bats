setup() {
    # Create expected Jekyll pre-generated files:
    # index.md, 404.md

    cat <<- EOF > temp-index.md
---
redirect_to: http://www.d.com
---
EOF
    
    cat <<- EOF > temp-404.md
---
permalink: /404.html
redirect_to: http://www.d.com
---
EOF
}

## Check if the Action
##  * Generated the proper Index Markdown file
##  * Generated the proper 404 Markdown file

@test "index.md should be generated" {
    test -f index.md
    diff    index.md temp-index.md
}

@test "404.md should be generated" {
    test -f 404.md
    diff    404.md temp-404.md
}

## Check if Jekyll:
##  * Generated the proper html files
##  * Generated the proper html content
##      * Contains "<!DOCTYPE html>"
##      * Contains the URL redirect

@test "index.html should be generated" {
    test -f _site/index.html
    cat _site/index.html | grep "<\!DOCTYPE html>"
    cat _site/index.html | grep "http://www.d.com"
}

@test "404.html should be generated" {
    test -f _site/404.html
    cat _site/404.html | grep "<\!DOCTYPE html>"
    cat _site/404.html | grep "http://www.d.com"
}