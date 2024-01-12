<template>
    <div>
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">常用功能</h5>
        <van-grid gutter="10" clickable >
            <van-grid-item v-if="!item.hidden" :icon="item.icon" v-for="(item,index) in appGroup" :key="index" :text="item.text" @click="clickEvent(item)" />
        </van-grid>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                appGroup:[
                    {
                        icon:'logistics',
                        url:'/buy',
                        //jump:'/mobile/vpa',
                        text:'购货单',
                        name:'buy',
                    },
                    {
                        //jump:'/mobile/vsa',
                        icon:'shop-o',
                        url:'/sale',
                        text:'销货单',
                        name:'sale',
                    },
                    {
                        jump:'/mobile/vpr',
                        icon:'wap-home-o',
                        url:'/inittf',
                        text:'退货单',
                        name:'inittf',
                        hidden:true,
                    },
                    {
                        //jump:'/mobile/vsr',
                        icon:'wap-home',
                        url:'/inittf',
                        text:'仓库调拨',
                        name:'inittf',
                        hidden:true,
                    },
                    {
                        //jump:'/mobile/vso',
                        icon:'cart',
                        url:'/inbound',
                        text:'其他入库',
                        name:'inbound',
                    },
                    {
                        //jump:'/mobile/vsor',
                        icon:'cart-o',
                        url:'/outbound',
                        text:'其他出库',
                        name:'outbound',
                    },
                    // {
                    //     //jump:'/mobile/vstock',
                    //     icon:'goods-collect-o',
                    //     url:'/goods',
                    //     text:'库存',
                    //     name:'goods',
                    //     hidden:false,
                    // },
                    {
                        //jump:'/mobile/vreport',
                        icon:'chart-trending-o',
                        url:'/goods',
                        text:'报表',
                        name:'goods',
                        hidden:true,
                    },
                    {
                        icon:'bag-o',
                        url:'/goods',
                        text:'商品管理',
                        name:'goods',
                        hidden:false,
                    },
                    {
                        icon:'friends-o',
                        url:'/customer',
                        text:'客户管理',
                        name:'customer',
                        hidden:false,
                    },
                    {
                        icon:'friends',
                        url:'/supplier',
                        text:'供应商管理',
                        name:'supplier',
                        hidden:false,
                    },
                    {
                        icon:'shop',
                        url:'/warehouse',
                        text:'库存查询',
                        name:'warehouse',
                        hidden:false,
                    },
                    {
                        jump:'/mobile/main',
                        icon:'replay',
                        url:'/mobile',
                        text:'返回旧版',
                        name:'replay',
                        hidden:true,
                    },
                ],
            };
        },
        methods: {
            clickEvent(item){
                const me = this;
                if(item.jump){
                    let host = me.cookie.getCookie('host');
                    location.href = host + item.jump;
                }else{
                    me.$router.push({path:item.url});
                }
            },
        },
        created() {
            const me = this;
            let role = me.cookie.getCookie('role');
            if(role != 0){
                let needShow = [1,9,11];
                me.appGroup.map((map,index)=>{
                    if(needShow.indexOf(index) === -1){
                        me.appGroup[index].hidden = true;
                    }
                })
            }
        },
        mounted(){
            var me = this;
        },
    }
</script>

<style scoped>

</style>
