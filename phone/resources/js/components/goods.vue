<template>
    <div>
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">
            商品管理
            <span style="float:right;">
                <van-button type="primary" size="small" @click="addBox">新增</van-button>
            </span>
        </h5>
        <van-search
            v-model="searchForm.keyword"
            show-action
            placeholder="输入商品编号/名称/规格/型号查询"
        >
            <template #action>
                <van-button type="info" size="small" @click="onSearch">搜索</van-button>
            </template>
        </van-search>
        <div style="padding:3%">
            <van-pull-refresh v-model="isLoading" @refresh="onRefresh">
                <van-list
                v-model="goodsLoading"
                :finished="goodsFinished"
                finished-text="没有更多了"
                @load="goodsOnLoad"
            >
                <van-swipe-cell v-for="(item,index) in goodsList" :key="index" style="margin-bottom: 5%;">
                    <van-card
                        :num="item.qty"
                        :price="'零售价：'+(item.salePrice.toFixed(2))"
                        class="goods-card"
                        @click="updateGoods(item)"
                    >
                        <template #desc>
                            <div style="display:flex;flex-direction:column;">
                                <span>
                                    商品名称：{{item.name}}
                                </span>
                                <span>
                                    商品编号：{{item.number}}
                                </span>
                                <span>
                                    商品条码：{{item.barCode}}
                                </span>
                            </div>
                        </template>
                        <template #tags>
                            <van-tag plain type="danger">规格：{{item.spec}}</van-tag>
                            <van-tag plain type="danger">所属分类：{{item.categoryName}}</van-tag>
                        </template>
                        <template #footer>
                            当前库存：{{item.totalqty}}&nbsp;&nbsp;&nbsp;&nbsp;单位成本：{{item.iniunitCost}}&nbsp;&nbsp;&nbsp;&nbsp;预计采购价：{{item.purPrice}}
                        </template>
                    </van-card>
                    <template #right>
                        <van-button square text="删除" type="danger" class="delete-button" @click="delGoods(index)" />
                    </template>
                </van-swipe-cell>
            </van-list>
            </van-pull-refresh>
            <van-popup v-model="goodsBoxShow" position="bottom" closeable :style="{ height: '90%' }" @closed="goodsChanel">
                <van-cell-group>
                    <van-form validate-first>
                        <van-divider
                            :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' ,margin:'15% 0% 0%'}"
                        >
                            商品信息
                        </van-divider>
                        <van-field label="商品编号" v-model="submitForm.number"  required :rules="[{ required: true, message: '请填写商品编号' }]" />
                        <van-field label="商品名称" v-model="submitForm.name" required :rules="[{ required: true, message: '请填写商品名称' }]" />
                        <div style="display:flex;flex-direction: row;align-items: center;">
                            <div style="margin:0px 15px;">商品图片</div>
                            <div style="display:flex;flex-direction:column;">
                                <van-image
                                    v-for="(item,index) in submitForm.img"
                                    :key="index"
                                    style="margin:0px 10px;"
                                    width="200"
                                    height="100"
                                    :src="item.url"
                                />
                            </div>
                        </div>
                        <van-field label="商品类别" placeholder="请点击选择分类" v-model="submitForm.categoryName" clickable readonly @click="categoryShow = true;" />
                        <van-field label="首选仓库" v-model="submitForm.locationName" placeholder="请点击选择仓库" readonly clickable @click="getLocation();locationShow = true;" />
                        <van-field label="规格型号" v-model="submitForm.spec"  />
                        <van-field label="计量单位" v-model="unitName" placeholder="点击选择计量单位" @click="unitBoxShow = true;" clickable readonly />
                        <van-popup v-model="unitBoxShow" position="bottom">
                            <van-picker
                                show-toolbar
                                :columns="unitList"
                                value-key="name"
                                @confirm="onConfirm"
                                @cancel="unitBoxShow = false"
                            />
                        </van-popup>
                        <van-field label="商品条码" v-model="submitForm.barCode" />
                        <van-field label="有效期天数" v-model="submitForm.udf04" />
                        <van-field label="生产日期" v-model="submitForm.udf03" />
                        <van-field label="货位" v-model="submitForm.udf05" />
                        <van-divider
                            :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"
                        >
                            价格策略
                        </van-divider>
                        <van-field
                            clearable
                            label="零售价"
                            v-model="submitForm.salePrice"
                            name="validator"
                            placeholder="请输入零售价"
                            :rules="[{ validator, message: '请输入正确内容' }]"
                        />
                        <van-field
                            clearable
                            label="批发价"
                            v-model="submitForm.wholesalePrice"
                            placeholder="请输入批发价"
                            :rules="[{ validator, message: '请输入正确内容' }]"
                        />
                        <van-field
                            clearable
                            label="VIP会员价"
                            v-model="submitForm.vipPrice"
                            placeholder="请输入VIP会员价"
                            :rules="[{ validator, message: '请输入正确内容' }]"
                        />
                        <van-field
                            clearable
                            label="折扣率一(%)"
                            v-model="submitForm.discountRate1"
                            placeholder="请输入折扣率一"
                        />
                        <van-field
                            clearable
                            label="折扣率二(%)"
                            v-model="submitForm.discountRate2"
                            placeholder="请输入折扣率二"
                        />
                        <van-field
                            clearable
                            label="预计采购价"
                            v-model="submitForm.purPrice"
                            placeholder="请输入预计采购价"
                            :rules="[{ validator, message: '请输入正确内容' }]"
                        />
                        <van-button type="info" block @click="onSubmit">保存</van-button>
                    </van-form>
                    <van-action-sheet v-model="locationShow" :actions="locationList" description="选择仓库" @select="localUpdate" />
                    <van-popup v-model="categoryShow" position="bottom" :style="{ height: '80%' }" >
                        <div style="overflow: hidden;position: relative;">
                            <van-sticky>
                                <van-button type="default" size="normal" style="float:left;" @click="categoryShow = false;">取消</van-button>
                                <van-button type="default" size="normal" style="float:right" @click="queryCategory">确认</van-button>
                            </van-sticky>
                        </div>
                        <cTree :data="categoryList" v-model="check"></cTree>
                    </van-popup>
                </van-cell-group>
            </van-popup>
        </div>
    </div>
</template>

<script>
    import cTree from './tree/tree';
    export default {
        components: {
            cTree
        },
        data(){
            return {
                isLoading:false,
                unitName:'',
                unitBoxShow:false,
                check:{},
                categoryList:[],
                searchForm:{
                    keyword:'',
                    page:1,
                    isDelete: 2
                },
                submitForm:{
                    categoryName:'',
                    categoryId:'',
                    // lowQty:0,
                    // highQty:0,
                    propertys:'[]',
                    // remark:'',
                    warehouseWarning:0,
                    warehouseWarningSku:0,
                    sonGoods:'[]',
                    // unitName:'',
                    // warehousePropertys:'',
                    // dopey:0
                },
                goodsList:[],
                goodsLoading:false,
                goodsFinished:false,
                goodsApi:'/api/getGoodsList',
                goodsBoxShow:false,
                storageApi:'/api/storage',
                locationList:[],
                unitList:[],
                locationShow:false,
                categoryShow:false,
                cateApi:'/api/category',
                unitApi:'/api/getUnitList',
                addApi:'/api/addGoods',
                updateApi:'/api/updateGoods',
            }
        },
        methods: {

            //关闭商品信息弹窗
            goodsChanel(){
                var me = this;
                me.unitName = '';
                me.submitForm = {};
            },

            //分类确定
            queryCategory(){
                var me = this;
                me.submitForm.categoryName = me.check.name;
                me.submitForm.categoryId = me.check.id;
                me.categoryShow = false;
            },
            //提交修改
            updateGoods(obj){
                var me = this;
                me.submitForm = JSON.parse(JSON.stringify(obj));
                me.unitName = obj.unitName;
                me.goodsBoxShow = true;
            },
            //下拉刷新
            onRefresh(){
                var me = this;
                me.searchForm.page = 1;
                me.goodsFinished = false;
                me.goodsOnLoad();
            },
            //提交保存
            onSubmit(){
                var me = this;
                var para = JSON.parse(JSON.stringify(me.submitForm));
                var need = ['baseUnitId','name','number','categoryId','locationId'];
                for(let i in need){
                    if(!para[need[i]]){
                        return me.$toast.fail('请补全信息再提交！');
                    }
                }
                if(me.submitForm.id){
                    var api = me.updateApi;
                }else{
                    var api = me.addApi;
                }
                axios.post(api, para).then(response => {
                    if(response.data.status == 'success'){
                        var del = ['purPrice','spec','vipPrice','wholesalePrice','salePrice','name','barCode'];
                        if(!me.submitForm.id){
                            for(let i in del){
                                me.submitForm[del[i]] = '';
                            }
                            var oldNumber = parseInt(me.submitForm.number.replace(/[^0-9]/ig,""));
                            var newNumber = oldNumber + 1;
                            me.submitForm.number = me.submitForm.number.replace(oldNumber,newNumber);
                        }else{
                            me.onRefresh();
                        }
                        me.$toast.success(response.data.msg);
                    }else{
                        if(response.data.status == 'noLogin'){
                            me.cookie.clearCookie('token');
                            me.$router.push({path:'/login'});
                        }
                        me.$toast.fail(response.data.msg);
                    }
                }).catch(error =>{
                    console.log(error);
                    me.$toast.fail('服务器异常！');
                });
            },

            //选择单位
            onConfirm(value){
                var me = this;
                me.submitForm.baseUnitId = value.id;
                me.unitName = value.name;
                me.unitBoxShow = false;
            },
            //获取单位列表
            getUnits(){
                var me = this;
                axios.get(me.unitApi, {params:{isDelete:2}}).then(response => {
                    if(response.data.status == 'success'){
                        me.unitList = response.data.data.data;
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

            //选择仓库
            localUpdate(item){
                var me = this;
                me.submitForm.locationId = item.id;
                me.submitForm.locationName = item.name;
                me.locationShow = false;
            },

            //检测价格内容
            validator(val){
                if(val){
                    return /(^[1-9][0-9]{0,8}([.][0-9]{0,2})?$)|(^0?(\.[0-9]{0,2})?$)/.test(val);
                }
                return true;
            },

            //商品新增窗口
            addBox(){
                var me = this;
                me.goodsBoxShow = true;
            },

            onSearch(){
                var me = this;
                me.searchForm.page = 1;
                me.goodsFinished = false;
                me.goodsOnLoad();
            },
            //获取商品列表
            goodsOnLoad(){
                var me = this;
                var para = me.searchForm;
                if(me.isLoading){
                    return false;
                }
                me.isLoading = true;
                axios.get(me.goodsApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        if(me.searchForm.page == 1){
                            me.goodsList =  response.data.data.data;
                        }else{
                            if(me.goodsList.length){
                                me.goodsList = me.goodsList.concat(response.data.data.data);
                            }else{
                                me.goodsList =  response.data.data.data;
                            }
                        }
                        var form = {
                            current_page:response.data.data.current_page,
                            total:response.data.data.total,
                            last_page:response.data.data.last_page,
                            page:response.data.data.current_page + 1,
                            keyword:me.searchForm.keyword
                        };
                        me.searchForm = form;
                        if(!response.data.data.next_page_url){
                            //数据已经读取完毕
                            me.goodsFinished = true;
                        }
                    }else{
                        if(response.data.status == 'noLogin'){
                            me.cookie.clearCookie('token');
                            me.$router.push({path:'/login'});
                        }
                        //关闭加载
                        me.goodsFinished = true;
                        me.$toast.fail(response.data.msg);
                    }
                    me.goodsLoading = false;
                    me.isLoading = false;
                }).catch(reject =>{
                    console.log(reject);
                    //关闭加载
                    me.goodsFinished = true;
                    me.isLoading = false;
                    me.$toast.fail('网络错误！');
                });
            },
            //获取分类列表
            getCateList(){
                var me = this;
                var para = {typeNumber:'trade',isDelete:2};
                axios.get(me.cateApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        var list = {};
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
                        //关闭加载
                        me.goodsFinished = true;
                        me.$toast.fail(response.data.msg);
                    }
                    me.goodsLoading = false;
                }).catch(reject =>{
                    console.log(reject);
                    //关闭加载
                    me.goodsFinished = true;
                    me.$toast.fail('网络错误！');
                });
            },
        },
        mounted() {

        },
        created() {
            var me = this;
            me.getCateList();
            me.getUnits();
        },
        watch:{
            watchCategory(newValue,oldValue){
                var me = this;
                if(!me.submitForm.categoryName){
                    me.submitForm.categoryId = newValue.id;
                    me.submitForm.categoryName = newValue.name;
                }
            },
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
</style>
