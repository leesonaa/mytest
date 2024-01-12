<template>
    <van-popup v-model="visible" position="bottom" :style="{ height: '90%' }">
        <div style="overflow: hidden;position: relative;">
            <van-sticky>
                <van-button type="default" size="normal" style="float:left;" @click="cancel">取消</van-button>
                <van-button type="default" size="normal" style="float:right" @click="query">确认</van-button>
            </van-sticky>
        </div>
        <div style="padding:5% 5% 0%;">
            <van-search
                v-model="form.keyword"
                show-action
                placeholder="输入商品编号/名称/型号查询"
                @search="search"
            >
                <template #left>
                    <scan
                        :dataObj="{}"
                        @scan="scanData"
                    ></scan>
                </template>
                <template #left-icon>
                </template>
                <template #action>
                    <div @click="search">搜索</div>
                </template>
            </van-search>
            <van-list
                v-model="loading"
                :finished="finished"
                finished-text="没有更多了"
                @load="onload"
            >
                <van-checkbox-group v-model="selectData">
                    <!--                                <van-cell title="全选" @click="selectAll" clickable v-if="goodsList.length">-->
                    <!--                                    <template #right-icon>-->
                    <!--                                        <van-checkbox shape="square" ref="selectAll" />-->
                    <!--                                    </template>-->
                    <!--                                </van-cell>-->
                    <van-cell v-for="(item,index) in list"
                              :key="item.id"
                              :title="item.name+(item.barCode ? '(条码:'+item.barCode+')' : '')+(item.spec ? '(规格:'+item.spec+')' : '')"
                              clickable
                              @click.stop="selected(index,item)" >
                        <template #right-icon>
                            <van-checkbox :class="'checkboxes-'+ item.id" v-model="item.checked" :ref="'goodsSelect-'+item.id" :name="item.id" shape="square" />
                        </template>
                    </van-cell>
                </van-checkbox-group>
            </van-list>
        </div>
    </van-popup>

</template>

<script>
import Scan from './scan'
export default {
    name: "goods-select",
    props:{
      isOut: {
        type: Boolean,
        default: false
      },
    },
    components: {
        Scan
    },
    data(){
        return {
            visible:false,
            loading:false,
            finished:false,
            list:[],
            selectData:[],
            form:{
                page:1,
                size:10,
                keyword:''
            },
            goodsApi:'/api/getGoodsList',
            entries:[],
        }
    },
    methods: {
        show(list){
            const me = this;
            me.entries = list;
            me.formatSelectShow();
            me.visible = true;
        },
        scanData(val){
            const me = this;
            me.form.keyword = val;
            me.search();
        },
        query(){
            const me = this;
            if(me.isOut){//需要清理选中商品的price
                me.entries = me.entries.map(map=>{
                   return {...map,price:"0.00",amount:"0.00"}
                });
            }
            me.$emit('query',me.entries);
            me.entries = [];
            me.formatSelectShow();
            me.visible = false;
        },
        formatSelectShow(){
            const me = this;
            if(me.list.length > 0){
                let selectData = me.entries.map(map=> map.invId);
                me.list = me.list.map((map)=>{
                    let checked = selectData.includes(map.id);
                    me.$refs['goodsSelect-'+map.id][0].toggle(checked);
                    return {
                        ...map,
                        checked
                    }
                });
                me.$forceUpdate();
            }
        },
        selected(index,item){
            let me = this;
            item.checked = !item.checked;
            if(!item.checked){
                me.entries.splice(index,1);
            }else {
                let itemNew = {
                    "invId": item.id,
                    "invNumber": item.number,
                    "invName": item.name,
                    "invSpec": item.spec,
                    "barCode": item.barCode,
                    "skuId": -1,
                    "skuName": "",
                    "unitId": -1,
                    "mainUnit": item.unitName,
                    "qty": "1.00",
                    "price": item.purPrice.toFixed(2),
                    "discountRate": "0",
                    "deduction": "0.00",
                    "amount": item.purPrice.toFixed(2),
                    "locationId": item.locationId,
                    "locationName": item.locationName,
                    "serialno": "",
                    "description": "",
                    "srcOrderEntryId": "0",
                    "srcOrderId": "0",
                    "srcOrderNo": ""
                };
                if (me.entries.length) {
                    let flag = true;
                    me.entries.filter(function (self, index, arr) {
                        if (self.invId == itemNew.invId) {
                            flag = false;
                            me.entries[index].qty = (Number(me.entries[index].qty) + 1).toFixed(2);
                        }
                    });
                    if (flag) {
                        me.entries.push(itemNew);
                    }
                } else {
                    me.entries.push(itemNew);
                }
            }
        },
        search(){
            let me = this;
            me.loading = true;
            me.finished = false;
            me.form.page = 1;
            me.goodsList = [];
            me.onload();
        },
        cancel(){

        },
        //默认加载商品信息
        async onload(){
            let me = this;
            let para = me.form;
            let rep = await axios.get(me.goodsApi, {params:para});
            let {status,data,msg} = rep.data;
            if(status === 'success'){
                let form = {
                    current_page:data.data.current_page,
                    total:data.total,
                    last_page:data.last_page,
                    page:data.current_page + 1,
                };
                me.form = form;
                if(!data.next_page_url){
                    //数据已经读取完毕
                    me.finished = true;
                }
                if(me.list.length){
                    me.list = me.list.concat(data.data);
                }else{
                    me.list = data.data;
                }
                me.list = me.list.map(map=>{
                    return {...map,checked:false}
                });
            }else if(status === 'noLogin'){
                me.cookie.clearCookie('token');
                me.$router.push({path:'/login'});
                //关闭加载
                me.finished = true;
                me.$toast.fail(msg);
            }
            me.loading = false;
        },
    },
    mounted(){

    }
}
</script>

<style scoped>

</style>
