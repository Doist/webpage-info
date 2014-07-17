request = require("request")

RE_TITLE = /<title>(.+?)<\/title>/i

exports.parse = (url, callback, timeout) ->
    timeout = timeout or 5000
    args = {"url": url, "timeout": timeout}

    request(args, (error, response, body) ->
        if error or response.statusCode != 200
            callback({'error': error})
        else
            title = body.match(RE_TITLE)

            if title
                title = title[1]
            else
                title = ''

            callback({
                'title': title,
                'favicon': 'https://www.google.com/s2/favicons?domain=' + url
            })
    )
