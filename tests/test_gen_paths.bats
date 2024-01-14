setup() {
    # Create expected Jekyll files:
    # temp-d.md
    cat <<- EOF > temp-d.md
---
redirect_to: http://www.abcd.com
---
EOF
}

## Check if the Action
##  * Generated the proper Markdown file
##  * Generated the proper Markdown content

@test "a/b/c/temp-d.md should be generated" {
    test -f _redirects/a/b/c/temp-d.md
    diff    _redirects/a/b/c/temp-d.md temp-d.md
}

## Check if Jekyll:
##  * Generated the proper html file
##  * Generated the proper html content
##      * Contains "<!DOCTYPE html>"
##      * Contains the URL redirect

@test "test-a.html should be generated" {
    test -f _site/a/b/c/test-d.html
    cat _site/a/b/c/test-d.html | grep "<\!DOCTYPE html>"
    cat _site/a/b/c/test-d.html | grep "http://www.abcd.com"
}