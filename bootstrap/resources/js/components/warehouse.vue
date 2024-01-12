<template>
    <div>
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">
            库存查询
        </h5>
        <div>
            <!--   查询start     -->
            <van-field label="商品类别" placeholder="请点击选择分类" v-model="form.categoryName" clickable readonly @click="categoryShow = true;" />
            <van-popup v-model="categoryShow" position="bottom" :style="{ height: '80%' }" >
                <div style="overflow: hidden;position: relative;">
                    <van-sticky>
                        <van-button type="default" size="normal" style="float:left;" @click="categoryShow = false;">取消</van-button>
                        <van-button type="default" size="normal" style="float:right" @click="queryCategory">确认</van-button>
                    </van-sticky>
                </div>
                <cTree :data="categoryList" v-model="check"></cTree>
            </van-popup>
            <van-field label="选择仓库" v-model="form.locationName" placeholder="请点击选择仓库" readonly clickable @click="getLocation();locationShow = true;" />
            <van-action-sheet v-model="locationShow" :actions="locationList" description="选择仓库" @select="localUpdate" />
            <van-search
                v-model="form.goods"
                show-action
                placeholder="输入商品名称/条码查询"
            >
                <template #left-icon>
                    <scan
                        :dataObj="{}"
                        @scan="scanData"
                    ></scan>
                </template>
                <template #action>
                    <div style="display:flex;flex-direction: row;">
                        <van-checkbox v-model="form.showZero" shape="round" >
                            零库存
                        </van-checkbox>
                        <van-button type="info" size="small" @click="onRefresh">搜索</van-button>
                        <van-button type="primary" size="small" @click="clear">重置</van-button>
                    </div>
                </template>
            </van-search>
            <!--   查询end       -->
            <div style="padding:3%">
                <van-pull-refresh v-model="isLoading" @refresh="onRefresh">
                    <van-list
                        v-model="loading"
                        :finished="finished"
                        finished-text="没有更多了"
                        @load="getData"
                    >
                        <van-swipe-cell v-for="(item,index) in list" :key="index" style="margin-bottom: 5%;">
                            <van-card
                                :num="item.qty"
                                :desc="'仓库：'+item.locationName"
                                :title="'商品类别：'+item.assistName"
                                class="goods-card"
                            >
                                <!--                            <template #price>-->
                                <!--                            </template>-->
                                <template #tags>
                                    <div style="display:flex;flex-direction: column;text-align: left;">
                                        <div>
                                            商品编号：{{item.invNumber}}
                                        </div>
                                        <div>
                                            商品名称：{{item.invName}}
                                        </div>
                                        <div>
                                            商品条码：{{item.barCode}}
                                        </div>
                                        <div>规格型号：{{item.invSpec}}</div>
                                        <div>库存数量 ：{{item.qty}}</div>
                                    </div>

                                </template>
                            </van-card>
                            <template #right>
                                <van-button square text="删除" type="danger" class="delete-button" @click="del(index)" />
                            </template>
                        </van-swipe-cell>
                    </van-list>
                </van-pull-refresh>
            </div>
        </div>
    </div>
</template>

<script>
import cTree from './tree/tree';
import Scan from './common/scan'
export default {
    name: "warehouse",
    components: {
        cTree,
        Scan
    },
    data() {
        return {
            searchApi:'/api/invOi/getData',
            cateApi:'/api/category',
            storageApi:'/api/storage',
            isLoading:false,
            locationShow:false,
            loading:false,
            finished:false,
            categoryShow:false,
            categoryList:[],
            check:{},
            form:{
                pageSize:10,
                page:1,
                locationId:0,
                categoryId:0,
                goods:'',
                showZero:''
            },
            resetForm:{
                pageSize:10,
                page:1,
                locationId:0,
                categoryId:0,
                goods:'',
                showZero:''
            },
            list:[],
            locationList:[],
        }
    },
    methods:{
        scanData(val){
            const me = this;
            me.form.goods = val;
            me.getData();
        },
        clear(){
            const me = this;
            me.form = JSON.parse(JSON.stringify(me.resetForm));
            me.onRefresh();
        },
        //选择仓库
        localUpdate(item){
            var me = this;
            me.form.locationId = item.id;
            me.form.locationName = item.name;
            me.locationShow = false;
        },
        //获取仓库列表
        getLocation(){
            var me = this;
            axios.get(me.storageApi, {}).then(response => {
                if(response.data.status == 'success'){
                    me.locationList = response.data.data;
                }else{
                    if(response.data.status == 'noLogin'){
                        me.cookie.clearCookie('token');
                        me.$router.push({path:'/login'});
                    }
                    me.$toast.fail(response.data.msg);
                }
            }).catch(reject =>{
                me.$toast.fail('网络错误！');
            });
        },
        //获取分类列表
        getCateList(){
            const me = this;
            let para = {typeNumber:'trade',isDelete:2};
            axios.get(me.cateApi, {params:para}).then(response => {
                if(response.data.status == 'success'){
                    let list = {};
                    response.data.data.data.filter(function(self,index,arr){
                        if(self.level == 1){
                            self.children = {};
                            list[self.id] = self;
                        }else{
                            var path = self.path.split(',');
                            path.splice(path.length - 1,1);
                            var root = null;
                            var flag = true;
                            for(let i in path){
                                if(flag){
                                    root = list[path[i]];
                                    flag = false;
                                }else{
                                    root = root['children'][path[i]];
                                }
                            }
                            if(!self.detail){
                                self.children = {};
                            }
                            root.children[self.id] = self;
                        }
                    });
                    me.categoryList = list;
                }else{
                    if(response.data.status == 'noLogin'){
                        me.cookie.clearCookie('token');
                        me.$router.push({path:'/login'});
                    }
                    me.$toast.fail(response.data.msg);
                }
            }).catch(reject =>{
                me.$toast.fail('网络错误！');
            });
        },
        //分类确定
        queryCategory(){
            const me = this;
            me.form.categoryName = me.check.name;
            me.form.categoryId = me.check.id;
            me.categoryShow = false;
        },
        getData(){
            const me = this;
            // if(me.loading){
            //     return;
            // }
            me.loading = true;
            me.isLoading = true;
            axios.get(me.searchApi, {params:me.form}).then(res => {
                let {success,data,msg} = res.data;
                if(success){
                    if(me.form.page == 1){
                        me.list =  data.data;
                    }else{
                        if(me.list.length){
                            me.list = me.list.concat(data.data);
                        }else{
                            me.list =  data.data;
                        }
                    }
                    me.form.page += 1;
                    if(data.page == data.total){
                        //数据已经读取完毕
                        me.finished = true;
                    }
                }else{
                    me.$toast.fail(msg);
                }
                me.loading = false;
                me.isLoading = false;
            }).catch(reject =>{
                me.isLoading = false;
                me.loading = false;
                me.$toast.fail(reject);
            });
        },
        //下拉刷新
        onRefresh(){
            var me = this;
            me.form.page = 1;
            me.finished = false;
            me.getData();
        },
    },
    created() {
        this.getCateList();
    },
    computed: {
        //检测选择分类
        watchCategory() {
            return this.check;
        },
    }
}
</script>

<style scoped>
.goods-card {
    margin: 0;
    background-color: white;
    border:1px solid #111;
}

.delete-button {
    height: 100%;
}
.center-info{
    display:inline-block;
    margin:0 5px;
}
</style>
