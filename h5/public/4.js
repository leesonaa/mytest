(window.webpackJsonp=window.webpackJsonp||[]).push([[4],{249:function(e,t,a){"use strict";a.r(t);var r=a(21),n=a.n(r),o=a(146);const i="function"==typeof atob,s="function"==typeof Buffer,c="function"==typeof TextDecoder?new TextDecoder:void 0,u=("function"==typeof TextEncoder&&new TextEncoder,Array.prototype.slice.call("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")),l=(e=>{let t={};return e.forEach((e,a)=>t[e]=a),t})(u),d=/^(?:[A-Za-z\d+\/]{4})*?(?:[A-Za-z\d+\/]{2}(?:==)?|[A-Za-z\d+\/]{3}=?)?$/,f=String.fromCharCode.bind(String),p="function"==typeof Uint8Array.from?Uint8Array.from.bind(Uint8Array):(e,t=(e=>e))=>new Uint8Array(Array.prototype.slice.call(e,0).map(t)),h=e=>e.replace(/[^A-Za-z0-9\+\/]/g,""),v=/[\xC0-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF]{2}|[\xF0-\xF7][\x80-\xBF]{3}/g,g=e=>{switch(e.length){case 4:var t=((7&e.charCodeAt(0))<<18|(63&e.charCodeAt(1))<<12|(63&e.charCodeAt(2))<<6|63&e.charCodeAt(3))-65536;return f(55296+(t>>>10))+f(56320+(1023&t));case 3:return f((15&e.charCodeAt(0))<<12|(63&e.charCodeAt(1))<<6|63&e.charCodeAt(2));default:return f((31&e.charCodeAt(0))<<6|63&e.charCodeAt(1))}},m=e=>e.replace(v,g),b=e=>{if(e=e.replace(/\s+/g,""),!d.test(e))throw new TypeError("malformed base64.");e+="==".slice(2-(3&e.length));let t,a,r,n="";for(let o=0;o<e.length;)t=l[e.charAt(o++)]<<18|l[e.charAt(o++)]<<12|(a=l[e.charAt(o++)])<<6|(r=l[e.charAt(o++)]),n+=64===a?f(t>>16&255):64===r?f(t>>16&255,t>>8&255):f(t>>16&255,t>>8&255,255&t);return n},x=i?e=>atob(h(e)):s?e=>Buffer.from(e,"base64").toString("binary"):b,w=s?e=>p(Buffer.from(e,"base64")):e=>p(x(e),e=>e.charCodeAt(0)),A=s?e=>Buffer.from(e,"base64").toString("utf8"):c?e=>c.decode(w(e)):e=>m(x(e)),y=e=>h(e.replace(/[-_]/g,e=>"-"==e?"+":"/")),k=e=>A(y(e)),C=k;var S=a(147);function _(e,t,a,r,n,o,i){try{var s=e[o](i),c=s.value}catch(e){return void a(e)}s.done?t(c):Promise.resolve(c).then(r,n)}var B={data:function(){return{username:"",password:"",api:"/api/userLogin",loginLoading:!1}},methods:{onSubmit:function(e){var t=this,a=Object.assign({},e);t.loginLoading=!0,axios.post(t.api,a).then((function(e){if("success"==e.data.status)return t.cookie.setCookie({token:e.data.token},1),t.cookie.setCookie({role:0},1),t.$router.push({path:"/apps"}),!1;t.$toast.fail(e.data.msg),t.loginLoading=!1}))},loginCheck:function(){var e,t=this;return(e=n.a.mark((function e(){var a,r,i;return n.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:a=t,(r=o.a.getParams("loginData"))&&(i=C(r))&&(i=JSON.parse(i),S.a.login(i).then((function(e){a.cookie.setCookie({host:i.host},1),a.cookie.setCookie({token:e},1),a.$router.push({path:"/apps"})})));case 3:case"end":return e.stop()}}),e)})),function(){var t=this,a=arguments;return new Promise((function(r,n){var o=e.apply(t,a);function i(e){_(o,r,n,i,s,"next",e)}function s(e){_(o,r,n,i,s,"throw",e)}i(void 0)}))})()}},mounted:function(){},created:function(){this.loginCheck()}},E=a(12),F=Object(E.a)(B,(function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticStyle:{background:"white"}},[a("van-row",[a("van-col",{staticStyle:{"text-align":"center",padding:"30% 0 5%",size:"3rem"},attrs:{span:"24"}},[e._v("云进销存登录")])],1),e._v(" "),a("van-form",{on:{submit:e.onSubmit}},[a("van-field",{attrs:{clearable:"",name:"username",label:"用户名",placeholder:"用户名",rules:[{required:!0,message:"请填写用户名"}]},model:{value:e.username,callback:function(t){e.username=t},expression:"username"}}),e._v(" "),a("van-field",{attrs:{clearable:"",type:"password",name:"password",label:"密码",placeholder:"密码",rules:[{required:!0,message:"请填写密码"}]},model:{value:e.password,callback:function(t){e.password=t},expression:"password"}}),e._v(" "),a("div",{staticStyle:{margin:"16px"}},[a("van-button",{attrs:{round:"",block:"",type:"info","native-type":"submit","loading-text":"请求中...",loading:e.loginLoading}},[e._v("\n                登录\n            ")])],1)],1),e._v(" "),a("van-toast",{attrs:{id:"van-toast"}})],1)}),[],!1,null,"3083c4b1",null);t.default=F.exports}}]);