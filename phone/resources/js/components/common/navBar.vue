<template>
    <van-nav-bar
        :title="name"
        left-arrow
        @click-left="onClickLeft"
    />
</template>

<script>
    export default {
        data() {
            return {
                name:'首页',
            };
        },
        methods: {
            onClickLeft(){
                if (window.history.length <= 1) {
                    this.$router.push({path:'/'});
                    return false
                } else {
                    this.$router.go(-1);
                }
            },
        },
    }
</script>

<style scoped>

</style>
