/**
 * Created by shange on 2017/4/13.
 */

function SMSDK()
{
//    不能添加 alert() 等外部的方法
//    alert(--qq--);
    var name = "金山";
    this.initSDK = function (hello)
    {
        var initData ={};
        var appkey =
            {
            "appkey":"f3fc6baa9ac4"
            }
        var appSecrect=
            {
            "appSecrect":"7f3dedcb36d92deebcb373af921d635a"
            }
        initData["appkey"] = appkey;
        initData["appSecrect"] = appSecrect;
        return initData;
    };
    
    this.getCode = function ()
    {
        var phoneNum = document.getElementById('phoneInput').value;
        return phoneNum;
    };
    this.commitCode = function ()
    {
        var code = document.getElementById('codeInput').value;
        return code;
    };
    this.getCodeCallBack = function(message)
    {
        var p3 = document.createElement('p');
        p3.innerText = message;
        document.body.appendChild(p3);
    }
    this.commitCodeCallBack = function(message)
    {
        var p3 = document.createElement('p');
        p3.innerText = message;
        document.body.appendChild(p3);
    }
    
//    必须使用this 关键字
//    function text()
//    {
//        alert(-----测试-----);
//    }
}
var $smsdk = new SMSDK();











