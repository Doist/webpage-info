request = require("request")
Iconv = require('iconv').Iconv

RE_TITLE = /<title>(.+?)<\/title>/i
RE_CHARSET = /charset=(.+)/i

convertToUtf8 = (response, str) ->
    # Handle Japanese encoding
    cnt_type = response.headers['content-type']
    if cnt_type
        charset = cnt_type.match(RE_CHARSET)
        if charset
            charset = charset[1].toUpperCase()
            iconv = new Iconv(charset, 'UTF-8//TRANSLIT//IGNORE')
            str = iconv.convert(str)
    str = str.toString("UTF-8")
    return str

exports.parse = (url, callback, timeout) ->
    timeout = timeout or 5000

    args = {"url": url, "timeout": timeout}
    args.encoding = null

    request(args, (error, response, body) ->
        if error or response.statusCode != 200
            callback({'error': error})
        else
            title = convertToUtf8(response, body).match(RE_TITLE)

            if title
                title = title[1]
            else
                title = url

            callback({
                'title': title,
                'favicon': 'https://www.google.com/s2/favicons?domain=' + url
            })
    )
