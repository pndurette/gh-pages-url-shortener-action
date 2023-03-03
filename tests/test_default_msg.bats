## Check if the Action
##  * Generated the proper Index html file ('abc')
##  * Generated the proper 404 html file ('abc')

@test "index.html should be generated" {
    test -f _site/index.html
    test "$(cat _site/index.html)" = "abc"
}

@test "404.html should be generated" {
    test -f _site/404.html
    test "$(cat _site/404.html)" = "abc"
}