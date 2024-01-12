<template>
        <div>
            <van-button type="danger" block @click="logout">退出</van-button>
        </div>
</template>

<script>
    export default {
        data() {
            return {
                logoutApi:'/api/userLogout',
            };
        },
        methods: {
            logout(){
                var me = this;
                axios.get(me.logoutApi,{}).then(response => {
                    me.cookie.clearCookie('token');
                    location.reload();
                });

            },
        },

    }
</script>

<style scoped>

</style>
