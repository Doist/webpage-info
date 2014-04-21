# Return webpage info
Return a webpage's title and favicon.

## Installing the library
    npm install webpage-info -g

## API signature

```js
// Signature (timeout is in milliseconds):
webpage_info = require('webpage-info')
webpage_info.parse(url, callback, timeout)
```

## Example
```js
webpage_info = require('webpage-info')
callback = function(obj) { 
    console.log(obj.title); 
    console.log(obj.favicon); 
    console.log(obj.error); // Will be set if an error happend
}
webpage_info.parse('http://www.youtube.com/watch?v=9bZkp7q19f0', callback)
```
