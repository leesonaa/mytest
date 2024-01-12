/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap');
import VueRouter from 'vue-router';
import App from './App.vue';
window.Vue = require('vue');
import Vant from 'vant';
import 'vant/lib/index.css';
Vue.use(Vant);
import router from './router/index.js';
import cookie from './untils/cookie';
import api from './api/api';
import tool from './untils/tool';
Vue.prototype.cookie = cookie;

/**
 * The following block of code may be used to automatically register your
 * Vue components. It will recursively scan this directory for the Vue
 * components and automatically register them with their "basename".
 *
 * Eg. ./components/ExampleComponent.vue -> <example-component></example-component>
 */

// const files = require.context('./', true, /\.vue$/i)
// files.keys().map(key => Vue.component(key.split('/').pop().split('.')[0], files(key).default))

// Vue.component('example-component', require('./components/ExampleComponent.vue').default);
Vue.component('navBar', require('./components/common/navBar.vue').default);
Vue.component('tabBar', require('./components/common/tabBar.vue').default);
router.beforeEach((to, from, next) => {
    let token = cookie.getCookie('token');
    if(!token && to.path != '/login'){
        next({path:'/login'});
        return
    }
    if(token && to.path == '/login'){
        next({path:'/home'});
        return
    }
    if(to.path == '/'){
        next({path:'/home'});
        return
    }
    // var flag = true;
    // var localHistory = window.localStorage.getItem('history');
    // var historyArr = localHistory ? JSON.parse(localHistory) : [];
    // if(historyArr.length > 0){
    //     var pop = historyArr[historyArr.length - 1];
    //     // console.log(pop.name,to.name);
    //     if(pop.name == to.name){
    //         historyArr.pop();
    //         flag = false;
    //     }
    // }
    // if(from.path == '/'){
    //     flag = false;
    // }
    // if(flag){
    //     var history = {name:from.name ? from.name : 'home',title: from.meta.title ? from.meta.title : '首页'};
    //     historyArr.push(history);
    // }
    // window.localStorage.setItem('history',JSON.stringify(historyArr));
    if(to.matched.length > 0){
        /* 路由发生变化修改页面meta */
        if(to.meta.meta && to.meta.meta.length > 0){
            for(let i in to.meta.meta){
                let head = document.getElementsByTagName('head');
                let meta = document.createElement('meta');
                meta.content = to.meta.meta[i].content;
                meta.name = to.meta.meta[i].name;
                head[0].appendChild(meta);
            }
        }
        /* 路由发生变化修改页面title */
        if (to.meta.title) {
            document.title = to.meta.title;
        }
        next();
    }else{
        //next({ path: '/404' });
    }
});
/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

const app = new Vue({
    el: '#app',
    router,
    render: h =>h(App),
});
