<template>
    <div style="background:white">
        <van-row>
            <van-col span="24" style="text-align:center;padding:30% 0 5%;size:3rem">云进销存登录</van-col>
        </van-row>
        <van-form @submit="onSubmit">
            <van-field
                clearable
                v-model="username"
                name="username"
                label="用户名"
                placeholder="用户名"
                :rules="[{ required: true, message: '请填写用户名' }]"
            />
            <van-field
                clearable
                v-model="password"
                type="password"
                name="password"
                label="密码"
                placeholder="密码"
                :rules="[{ required: true, message: '请填写密码' }]"
            />
            <div style="margin: 16px;">
                <van-button round block type="info" native-type="submit" loading-text="请求中..." :loading="loginLoading">
                    登录
                </van-button>
            </div>
        </van-form>
        <van-toast id="van-toast" />
    </div>
</template>

<script>
    import tool from "../untils/tool";
    import { Base64 } from 'js-base64';
    import api from "../api/api";
    export default {
        data() {
            return {
                username: '',
                password: '',
                api:'/api/userLogin',
                loginLoading:false,
            };
        },
        methods: {
            onSubmit(values) {
                var me = this;
                let para = Object.assign({}, values);
                me.loginLoading = true;
                axios.post(me.api, para).then(response => {
                    if(response.data.status == 'success'){
                        me.cookie.setCookie({token:response.data.token},1);
                        // me.cookie.setCookie({role:response.data.role ? response.data.role : 0},1);
                        me.cookie.setCookie({role:0},1);
                        me.$router.push({path:'/apps'});
                        return false
                    }else{
                        me.$toast.fail(response.data.msg);
                    }
                    me.loginLoading = false;
                });
            },
            async loginCheck(){
                const me = this;
                let loginData = tool.getParams('loginData');
                if(loginData){
                    let data = Base64.decode(loginData);
                    if(data){
                        data = JSON.parse(data);
                        api.login(data).then((rep)=>{
                            me.cookie.setCookie({host:data.host},1);
                            me.cookie.setCookie({token:rep},1);
                            me.$router.push({path:'/apps'});
                        });
                    }
                }
            },
        },
        mounted() {

        },
        created() {
            this.loginCheck();
        },
    };
</script>

<style scoped>

</style>
