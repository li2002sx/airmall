//app js 桥接
appJsBridge = {
    ua: ua = navigator.userAgent.toLowerCase(),
    ios: /iphone|ipad|ipod/.test(ua),
    setupWebViewJavascriptBridge: function (callback) {
        if (window.WebViewJavascriptBridge) {
            return callback(WebViewJavascriptBridge);
        }
        if (window.WVJBCallbacks) {
            return window.WVJBCallbacks.push(callback);
        }
        window.WVJBCallbacks = [callback];
        var WVJBIframe = document.createElement('iframe');
        WVJBIframe.style.display = 'none';
        WVJBIframe.src = 'https://__bridge_loaded__';
        document.documentElement.appendChild(WVJBIframe);
        setTimeout(function () {
            document.documentElement.removeChild(WVJBIframe)
        }, 0)
    },
    registerHandler: function (method, callback) { //js 注册事件
        if (this.ios) {
            this.setupWebViewJavascriptBridge(function (bridge) {
                bridge.registerHandler(method, function (data, responseCallback) {
                    callback(data, function (result) {
                        responseCallback(result)
                    })
                })
            })
        }
    },
    callHandler: function (method, param, callback) { // js调用app事件
        if (this.ios) {
            this.setupWebViewJavascriptBridge(function (bridge) {
                bridge.callHandler(method, param, function (response) {
                    //处理调用oc response 回来的结果
                    callback(response)
                })
            })
        }
    }
}
