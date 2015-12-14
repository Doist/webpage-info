request = require("request")
jconv = require('jconv')
iconv = require('iconv-lite')
ogs = require('open-graph-scraper')

RE_TITLE = /<title>(.+?)<\/title>/i
RE_CHARSET = /charset=([^<>"']+)/i


convertToUtf8 = (response, str) ->
    # Handle Japanese encoding
    charset = null

    charset = null

    # Content type
    cnt_type = response.headers['content-type']
    if cnt_type
        charset = cnt_type.match(RE_CHARSET)

    if str and charset == null
        charset = str.toString("UTF8").match(RE_CHARSET)

    if str and charset
        charset = charset[1].toUpperCase()

        # win1251
        if charset.indexOf('1251') != -1
            try
                str = iconv.decode(str, 'win1251')
            catch
        else
            try
                str = jconv.convert(str, charset, "UTF8")
            catch

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
            body = convertToUtf8(response, body)

            title = body.match(RE_TITLE)
            if title
                title = title[1]
            else
                title = url

            ogs({"url": url, "timeout": timeout}, (err, results) =>
                return_data = {
                    'title': title
                }

                if results.success
                    data = results.data
                    if data
                        if data.ogTitle
                            return_data.title = data.ogTitle

                        if data.ogImage and data.ogImage.url
                            return_data.thumbnail = data.ogImage.url

                        if data.ogDescription
                            return_data.description = data.ogDescription

                callback(return_data)
            )
    )
