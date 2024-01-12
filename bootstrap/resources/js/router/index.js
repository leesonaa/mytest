import Vue from 'vue';
import VueRouter from 'vue-router';
import index from '../components/index.vue';
import home from '../components/home.vue';
import app from '../components/app.vue';
import setting from '../components/setting.vue';
import buy from '../components/buy.vue';
import sale from '../components/sale.vue';
import goods from '../components/goods.vue';
import allot from '../components/allot.vue';
import customer from '../components/customer.vue';
import supplier from '../components/supplier.vue';
import warehouse from '../components/warehouse.vue';
Vue.use(VueRouter);

export default new VueRouter({
    saveScrollPosition: true,
    routes: [
        {
            path: '/',
            component: index,
            name: 'index',
            children: [
                { path: '/home', component:home , name: 'home', icon:'home-o',hidden: false,meta:{meta:[],title:'首页'}},
                {path: '/apps', component: app, name: 'app' , icon:'apps-o', meta:{meta:[], title:'功能'}, children:[],},
                {
                    icon:'logistics',
                    name:'buy',
                    path:'/buy',
                    component:buy,
                    meta:{meta:[],title:'采购入库',parent:'app'},
                    hidden: true,
                },
                {
                    icon:'shop-o',
                    name:'sale',
                    path:'/sale',
                    component:sale,
                    meta:{meta:[],title:'销货出库',parent:'app'},
                    hidden: true,
                },
                {
                    icon:'wap-home-o',
                    name:'inittf',
                    path:'/inittf',
                    component:allot,
                    meta:{meta:[],title:'仓库调拨',parent:'app'},
                    hidden: true,
                },
                {
                    icon:'wap-home',
                    name:'inventory',
                    path:'/inventory',
                    meta:{meta:[],title:'库存盘点',parent:'app'},
                    hidden: true,
                },
                {
                    icon:'cart',
                    name:'inbound',
                    path:'/inbound',
                    meta:{meta:[],title:'其他入库',parent:'app'},
                    component: resolve => void(require(['../views/in-bound.vue'], resolve)),
                    hidden: true,
                },
                {
                    icon:'cart-o',
                    name:'outbound',
                    path:'/outbound',
                    meta:{meta:[],title:'其他出库',parent:'app'},
                    component: resolve => void(require(['../views/out-bound.vue'], resolve)),
                    hidden: true,
                },
                {
                    icon:'bag-o',
                    name:'goods',
                    path:'/goods',
                    meta:{meta:[],title:'商品管理',parent:'app'},
                    hidden: true,
                    component: goods,
                },
                {
                    icon:'friends-o',
                    name:'customer',
                    path:'/customer',
                    meta:{meta:[],title:'客户管理',parent:'app'},
                    hidden: true,
                    component:customer
                },
                {
                    icon:'friends',
                    name:'supplier',
                    path:'/supplier',
                    meta:{meta:[],title:'供应商管理',parent:'app'},
                    hidden: true,
                    component:supplier
                },
                {
                    icon:'shop',
                    name:'warehouse',
                    path:'/warehouse',
                    meta:{meta:[],title:'库存查询',parent:'app'},
                    hidden: true,
                    component:warehouse
                },
                {
                    icon:'revoke',
                    name:'revoke',
                    path:'/',
                    meta:{meta:[],title:'返回旧版',parent:'app'},
                    hidden: true,
                    component:supplier
                },
                { path: '/setting', component: setting, name: 'setting',icon:'setting-o',meta:{meta:[],title:'设置'}},
                //{ path: '/user', component: user, name: '列表' },
            ],
            meta:{
                title:'首页',
            },
            hidden: false
        },
        {
            path: '/404',
            component: resolve => void(require(['../components/404.vue'], resolve)),
            name: '404',
            meta:{
                meta:[],
                title:'页面未找到',
            },
            hidden: true
        },
        {
            path: '/login',
            component: resolve => void(require(['../components/login.vue'], resolve)),
            name: 'login',
            meta:{
                meta:[],
                title:'用户登录',
            },
            hidden: true
        },
    ]
});
