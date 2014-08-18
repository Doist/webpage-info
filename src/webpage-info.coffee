request = require("request")
jconv = require("jconv")

RE_TITLE = /<title>(.+?)<\/title>/i

exports.parse = (url, callback, timeout) ->
    timeout = timeout or 5000

    args = {"url": url, "timeout": timeout}
    args.encoding = null

    request(args, (error, response, body) ->
        if error or response.statusCode != 200
            callback({'error': error})
        else
            title = body.toString("UTF-8").match(RE_TITLE)

            if title
                title = title[1]

                # Handle Japanese encoding
                cnt_type = response.headers['content-type']
                if cnt_type
                    if cnt_type.toLowerCase().indexOf('euc-jp') != -1
                        try
                            title = jconv.convert(title.toString("binary"), 'EUCJP', 'UTF-8').toString()
                        catch e
                            title = url
            else
                title = url

            callback({
                'title': title,
                'favicon': 'https://www.google.com/s2/favicons?domain=' + url
            })
    )
