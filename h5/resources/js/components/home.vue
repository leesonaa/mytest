<template>
        <div v-if="isAdmin" style="background:white;">
            <div v-for="item in infoList">
                <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">{{ item.title }}</h5>
                <van-cell-group v-for="(info,index) in item.info" v-bind:key="index">
                    <van-cell :title="info.title" :value="info.value" />
                </van-cell-group>
            </div>
        </div>
        <van-empty v-else image="error" description="没有权限" />
</template>

<script>
    export default {
        data() {
            return {
                isAdmin:false,
                getSummaryApi:'/api/summary',
                infoList:[
                    {
                        title:"库存信息",
                        mod:"inventory",
                        info:[
                            {title:"库存总量",value:0},
                            {title:"库存成本",value:0}
                        ]
                    },
                    {
                        title:"账户信息",
                        mod:"fund",
                        info:[
                            {title:"现金",value:0},
                            {title:"银行存款",value:0}
                        ]
                    },
                    {
                        title:"应付应收",
                        mod:"contact",
                        info:[
                            {title:"客户欠款",value:0},
                            {title:"供货商欠款",value:0}
                        ]
                    },
                    {
                        title:"收入(本月)信息",
                        mod:"sales",
                        info:[
                            {title:"销售收入",value:0},
                            {title:"商品毛利",value:0}
                        ]
                    },
                    {
                        title:"采购(本月)信息",
                        mod:"purchase",
                        info:[
                            {title:"采购金额",value:0},
                            {title:"商品种类",value:0}
                        ]
                    }
                ],
            };
        },
        created() {
            const me = this;
            let role = me.cookie.getCookie('role');
            if(role == 0){
                me.isAdmin = true;
            }
        },
        methods: {
            getData(){
                //赋值
                const me = this;
                axios.get(me.getSummaryApi, {}).then(response => {
                    let {status,data} = response.data;
                    if(status == 200){
                        data.items.map(map=>{
                            me.infoList.map(m=>{
                                if(map.mod == m.mod ){
                                    m.info.map((mp,index)=>{
                                        let i
                                        i = index + 1;
                                        mp.value = map['total'+i]
                                    })
                                }
                            });
                        });
                    }
                });
            },
        },
        mounted() {
            this.getData();
        },
    }
</script>

<style scoped>

</style>
