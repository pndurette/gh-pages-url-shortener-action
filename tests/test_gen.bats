setup() {
    # Create expected Jekyll pre-generated files:
    # temp-a.md, temp-b.md, temp-c.md
    for f in {a..c}; do
        cat <<- EOF > temp-${f}.md
---
redirect_to: http://www.${f}.com
---
EOF
    done
}

## Check if the Action
##  * Generated the proper Markdown files
##  * Generated the proper Markdown content

@test "test-a.md should be generated" {
    test -f _redirects/test-a.md
    diff    _redirects/test-a.md temp-a.md
}

@test "test-b.md should be generated" {
    test -f _redirects/test-b.md
    diff    _redirects/test-b.md temp-b.md
}

@test "test-c.md should be generated" {
    test -f _redirects/test-c.md
    diff    _redirects/test-c.md temp-c.md
}

## Check if Jekyll:
##  * Generated the proper html files
##  * Generated the proper html content
##      * Contains "<!DOCTYPE html>"
##      * Contains the URL redirect

@test "test-a.html should be generated" {
    test -f _site/test-a.html
    cat _site/test-a.html | grep "<\!DOCTYPE html>"
    cat _site/test-a.html | grep "http://www.a.com"
}

@test "test-b.html should be generated" {
    test -f _site/test-b.html
    cat _site/test-b.html | grep "<\!DOCTYPE html>"
    cat _site/test-b.html | grep "http://www.b.com"
}

@test "test-c.html should be generated" {
    test -f _site/test-c.html
    cat _site/test-c.html | grep "<\!DOCTYPE html>"
    cat _site/test-c.html | grep "http://www.c.com"
}