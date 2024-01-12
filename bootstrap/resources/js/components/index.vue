<template>
    <div>
        <van-nav-bar
            :title="name"
            left-arrow
            fixed
            @click-left="onClickLeft"
        />
        <div style="margin:15% 0% 15%;">
            <router-view></router-view>
        </div>
        <van-tabbar v-for="(item,index) in $router.options.routes" v-if="!item.hidden" v-model="active" v-bind:key="index">
            <van-tabbar-item v-for="(child,key) in item.children" :name="child.name" :icon="child.icon" @click="tabbarClick(child)" v-bind:key="key" v-if="!child.hidden">
                {{ child.meta.title }}
            </van-tabbar-item>
        </van-tabbar>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                name:"首页",
                active:'home',
            };
        },
        methods: {
            //点击返回逻辑
            onClickLeft(){
                var me = this;
                var check = window.localStorage.getItem('history') ? JSON.parse(window.localStorage.getItem('history')) : '';
                if (window.history.length <= 1) {
                    me.$router.push({path:'/home'});
                    return false
                } else {
                    me.$router.go(-1);
                }
            },
            onSubmit(values) {
                var me = this;
                let para = Object.assign({}, values);
                axios.post(me.api, para).then(response => {
                    if(response.data.status == 'success'){

                    }else{

                    }
                });
            },
            //点击底部tabbar逻辑
            tabbarClick(child){
                var me = this;
                if(me.$router.currentRoute.path == child.path){
                    return false;
                }
                me.$router.push({name:child.name,params:{name:child.name,title:child.meta.title}});
            },
            //检测当前路由，修改标题和着色
            flushStatus(){
                var me = this;
                if(me.$route.meta.parent){
                    me.active = me.$route.meta.parent;
                }else{
                    if(me.$route.params.name){
                        me.active = me.$route.params.name;
                    }else{
                        me.active = me.$route.name;
                    }
                }
                me.$forceUpdate();
                if(me.$route.params.title){
                    me.name = me.$route.params.title;
                }else{
                    me.name = me.$route.meta.title;
                }
                if(me.$route.meta.title){
                    me.name = me.$route.meta.title;
                    document.title = me.$route.meta.title;
                }
            }
        },
        mounted(){
            this.flushStatus();
        },
        //监视路由变动
        watch: {
            '$route':'flushStatus'
        },
    }
</script>

<style scoped>

</style>
