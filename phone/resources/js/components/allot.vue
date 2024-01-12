<template>
    <div>
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">
            调拨单
            <span style="float:right;">
                <van-button type="primary" size="small" @click="addBox">新增</van-button>
            </span>
        </h5>
        <van-field label="时间" placeholder="请点击选择查询时间" :value="searchForm.start ? searchForm.start + ' 至 ' + searchForm.end : ''" clickable readonly @click="dateShow = true" />
        <van-search
            v-model="searchForm.matchCon"
            show-action
            placeholder="输入单据号/备注查询"
        >
            <template #action>
                <van-button type="info" size="small" @click="onSearch">搜索</van-button>
            </template>
        </van-search>
        <van-calendar v-model="dateShow" type="range" :min-date="minDate" :max-date="maxDate" @confirm="dateQuery" />
        <div style="padding:3%">
            <van-pull-refresh v-model="listLoading" @refresh="onRefresh">
                <van-list
                    v-model="buyLoading"
                    :finished="buyFinished"
                    finished-text="没有更多了"
                    @load="buyOnLoad"
                >
                    <van-swipe-cell v-for="(item,index) in buyList" :key="index" style="margin-bottom: 5%;">
                        <van-card
                            :title="'调拨单编号：'+item.billNo"
                            class="goods-card"
                            @click="updateBuy(item)"
                        >
                            <template #tags>
                                <table width="100%;" v-if="item.goods.length" style="text-align:center;">
                                    <tr>
                                        <th width="44%">商品</th>
                                        <th width="9%">数量</th>
                                        <th width="9%">单位</th>
                                        <th width="19%">调出仓库</th>
                                        <th width="19%">调入仓库</th>
                                    </tr>
                                    <tr v-for="(goods,key) in item.goods">
                                        <td>{{goods}}</td>
                                        <td>{{item.qty[key]}}</td>
                                        <td>{{item.mainUnit[key]}}</td>
                                        <td>{{item.outLocationName[key]}}</td>
                                        <td>{{item.inLocationName[key]}}</td>
                                    </tr>
                                </table>
                            </template>
                            <template #footer>
                                调拨日期：{{item.billDate}}<br/>制单人：{{item.userName}}<br/>备注：{{item.description}}
                            </template>
                        </van-card>
                        <template #right>
                            <van-button square text="删除" type="danger" class="delete-button" @click="delBuy(index)" />
                        </template>
                    </van-swipe-cell>
                </van-list>
            </van-pull-refresh>
        </div>
        <van-popup v-model="buyBoxShow" position="bottom" closeable :style="{ height: '90%' }" @closed="buyChanel">
            <div style="margin-top:15%;">
                <van-divider
                    :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"
                >
                    调拨单
                </van-divider>
                <van-form validate-first>
                    <van-field
                        v-model="submitForm.billNo"
                        type="text"
                        label="单据编号"
                        readonly
                    />
                    <van-calendar v-model="calenderShow" @confirm="calendarClick" />
                    <van-field
                        readonly
                        clickable
                        label="商品列表"
                        placeholder="请点击选择商品"
                        @click="goodsShow = true"
                    />
                    <van-popup v-model="goodsShow" position="bottom" :style="{ height: '90%' }">
                        <div style="overflow: hidden;position: relative;">
                            <van-sticky>
                                <van-button type="default" size="normal" style="float:left;" @click="goodsCancel">取消</van-button>
                                <van-button type="default" size="normal" style="float:right" @click="goodsCancel">确认</van-button>
                            </van-sticky>
                        </div>
                        <div style="padding:5% 5% 0%;">
                            <van-search
                                v-model="goodsForm.keyword"
                                show-action
                                placeholder="输入商品编号/名称/型号查询"
                                @search="goodsSearch"
                            >
                                <template #action>
                                    <div @click="goodsSearch">搜索</div>
                                </template>
                            </van-search>
                            <van-list
                                v-model="goodsLoading"
                                :finished="goodsFinished"
                                finished-text="没有更多了"
                                @load="goodsOnLoad"
                            >
                                <van-checkbox-group v-model="selectList">
                                    <!--                                <van-cell title="全选" @click="selectAll" clickable v-if="goodsList.length">-->
                                    <!--                                    <template #right-icon>-->
                                    <!--                                        <van-checkbox shape="square" ref="selectAll" />-->
                                    <!--                                    </template>-->
                                    <!--                                </van-cell>-->
                                    <van-cell v-for="(item,index) in goodsList" :key="item.id" :title="item.name+'(规格:'+item.spec+')'" :data-index="item.id" clickable @click.stop="goodsClick(index,item)" >
                                        <template #right-icon>
                                            <van-checkbox :class="'checkboxes-'+ item.id"  ref="goodsCheckBoxes" :name="item.id" shape="square" />
                                        </template>
                                    </van-cell>
                                </van-checkbox-group>
                            </van-list>
                        </div>
                    </van-popup>
                    <van-collapse v-model="activeNames" v-if="submitForm.entries.length">
                        <van-collapse-item name="1">
                            <template #title>
                                <div style="text-align:center;color:rgb(25, 137, 250);">商品列表（点击展开/关闭）</div>
                            </template>
                            <van-swipe-cell v-for="(item,index) in submitForm.entries" :key="index" style="margin-bottom: 5%;">
                                <van-card
                                    :num="item.qty"
                                    :title="item.goods ? item.goods : item.invNumber+' '+item.invName + ' '+item.invSpec"
                                    class="goods-card"
                                    @click="updateGoods(item)"
                                >
                                    <template #tags>
                                        调出仓库：{{item.outLocationName}}<br>
                                        调入仓库：{{item.inLocationName}}
                                    </template>
                                    <template #footer>

                                    </template>
                                </van-card>
                                <template #right>
                                    <van-button square text="删除" type="danger" class="delete-button" @click="delGoods(index)" />
                                </template>
                            </van-swipe-cell>
                            <van-popup v-model="goodsUpdateShow" position="bottom" :style="{ height: '50%' }">
                                <div style="overflow: hidden;position: relative;">
                                    <van-button type="default" size="normal" style="float:left;" @click="goodsUpdateCancel">取消</van-button>
                                    <van-button type="default" size="normal" style="float:right" @click="goodsUpdateCancel">确认</van-button>
                                </div>
                                <div style="background:#eee;padding:5% 5% 0%;">
                                    <van-cell-group>
                                        <van-form validate-first>
                                            <van-field label="商品" v-model="goodsInfo.invName" readonly />
                                            <van-field label="单位" v-model="goodsInfo.mainUnit" readonly />
                                            <van-field label="调入仓库" v-model="goodsInfo.inLocationName" placeholder="请点击选择仓库" readonly clickable @click="locationShow = true;nowType='in'" />
                                            <van-field label="调出仓库" v-model="goodsInfo.outLocationName" placeholder="请点击选择仓库" readonly clickable @click="locationShow = true;nowType='out'" />
                                            <van-field label="数量" name="input">
                                                <template #input>
                                                    <van-stepper v-model="goodsInfo.qty" @change="goodsInfoUpdate"/>
                                                </template>
                                            </van-field>
                                        </van-form>
                                    </van-cell-group>
                                </div>
                            </van-popup>
                            <van-action-sheet v-model="locationShow" :actions="locationList" description="选择仓库" @select="localUpdate" />
                        </van-collapse-item>
                    </van-collapse>
                    <div v-if="submitForm.entries.length">
                        <van-cell title="合计(数量)" :value="submitForm.totalQty" />
                    </div>
                    <van-field
                        v-model="submitForm.description"
                        rows="2"
                        autosize
                        label="备注"
                        type="textarea"
                        maxlength="50"
                        placeholder="请输入备注"
                        show-word-limit
                    />
                    <van-button type="info" block @click="onSubmit">保存</van-button>
                </van-form>
            </div>
        </van-popup>
    </div>
</template>
<script>
    export default {
        data() {
            return {
                listLoading:false,
                buyLoading:false,
                buyFinished:false,
                dateShow:false,
                buyBoxShow:false,
                api:'/api/invTf/addNew',
                contactApi:'/api/getContactList',
                goodsApi:'/api/getGoodsList',
                listApi:'/api/invTf/getAllotList',
                activeNames:['1'],
                submitForm:{
                    billNo:'',
                    token:'',
                    contactName:'',
                    buId:5,
                    date:'',
                    entries:[],
                    totalQty:0,
                    description:'',
                },
                minDate: '',
                maxDate: '',
                submitResetForm:{
                    billNo:'',
                    token:'',
                    contactName:'',
                    buId:'',
                    date:'',
                    entries:[],
                    totalQty:0,
                    description:'',
                },
                buShow:false,
                customer:'',
                loading:false,
                finished:false,
                customerList:[],
                calenderShow:false,
                goodsShow:false,
                value:0,
                goodsUpdateShow:false,
                goodsInfo:{},
                locationList:[],
                locationShow : false,
                disRate:0,
                disAmount:0,
                rpAmount:0,
                contactForm:{},
                goodsLoading:false,
                goodsFinished:false,
                goodsList:[],
                selectList:[],
                goodsForm:{
                    page:1,
                },
                storageApi:'/api/storage',
                searchForm:{},
                buyList:[],
                InfoApi:'/api/invTf/getInfo',
                updateApi:'/api/invTf/update',
                nowType:'',
            };
        },
        methods: {
            //刷新数据
            onRefresh(){
                var me = this;
                me.searchForm.page = 1;
                me.buyFinished = false;
                setTimeout(()=>{
                    me.buyOnLoad();
                },500);
            },

            //获取数据
            buyOnLoad(){
                var me = this;
                var para = me.searchForm;
                axios.get(me.listApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        if(me.searchForm.page == 1){
                            me.buyList =  response.data.data.data;
                        }else{
                            if(me.buyList.length){
                                me.buyList = me.buyList.concat(response.data.data.data);
                            }else{
                                me.buyList =  response.data.data.data;
                            }
                        }
                        var form = {
                            current_page:response.data.data.current_page,
                            total:response.data.data.total,
                            last_page:response.data.data.last_page,
                            page:response.data.data.current_page + 1,
                            matchCon:me.searchForm.matchCon
                        };
                        me.searchForm = form;
                        if(!response.data.data.next_page_url){
                            //数据已经读取完毕
                            me.buyFinished = true;
                        }
                    }else{
                        if(response.data.status == 'noLogin'){
                            me.cookie.clearCookie('token');
                            me.$router.push({path:'/login'});
                        }
                        //关闭加载
                        me.buyFinished = true;
                        me.$toast.fail(response.data.msg);
                    }
                    me.buyLoading = false;
                    me.listLoading = false;
                }).catch(reject =>{
                    console.log(reject);
                    //关闭加载
                    me.buyFinished = true;
                    me.listLoading = false;
                    me.$toast.fail('网络错误！');
                });
            },

            //修改数据
            updateBuy(obj){
                var me = this;
                var para = {id:obj.id};
                axios.get(me.InfoApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        me.submitForm = response.data.data;
                        me.submitForm.disAmount = '';
                        me.submitForm.rpAmount = '';
                        me.buyBoxShow = true;
                    }else{
                        if(response.data.status == 'noLogin'){
                            me.cookie.clearCookie('token');
                            me.$router.push({path:'/login'});
                        }
                        me.$toast.fail(response.data.msg);
                    }
                }).catch(reject =>{
                    console.log(reject);
                    me.$toast.fail('网络错误！');
                });
            },

            //删除数据
            delBuy(index){

            },
            //点击时间确定
            dateQuery(val){
                var me = this;
                me.searchForm.start = me.formatDate(val[0]);
                me.searchForm.end = me.formatDate(val[1]);
                me.dateShow = false;
            },

            //查找开始
            onSearch(){
                var me = this;
                me.searchForm.page = 1;
                me.buyFinished = false;
                setTimeout(()=>{
                    me.buyOnLoad();
                },500);
            },

            //打开新增框体
            addBox(){
                var me = this;
                me.getBillNo();
                me.buyBoxShow = true;
            },

            //关闭购货单窗口
            buyChanel(){
                var me = this;
                me.submitForm = JSON.parse(JSON.stringify(me.submitResetForm));
            },
            //删除商品操作
            delGoods(index){
                var me = this;
                me.submitForm.entries.splice(index,1);
                me.$refs.goodsCheckBoxes[index].toggle();
            },
            //商品全选操作
            selectAll(){
                var me = this;
                me.$refs.selectAll.checked = me.$refs.selectAll.toggle();
                if(me.selectList.length == me.goodsList.length){
                    me.selectList = [];
                    for(let i in me.$refs.goodsCheckBoxes){
                        me.$refs.goodsCheckBoxes[i].checked = false;
                    }
                }else{
                    me.selectList = me.goodsList;
                    for(let i in me.$refs.goodsCheckBoxes){
                        me.$refs.goodsCheckBoxes[i].checked = true;
                    }
                }
                me.$forceUpdate();
            },
            //商品点击时
            goodsClick(index,item){
                var me = this;
                me.goodsFinished = true;
                if(me.$refs.goodsCheckBoxes){
                    if(!me.$refs.goodsCheckBoxes[index].checked){
                        var itemNew = {
                            "invId":item.id,
                            "invNumber":item.number,
                            "invName":item.name,
                            "invSpec":item.spec,
                            "skuId":-1,
                            "skuName":"",
                            "unitId":-1,
                            "mainUnit":item.unitName,
                            "qty":"1.00",
                            "description":"",
                            "inLocationId":item.inLocationId,
                            "inLocationName":item.inLocationName,
                            "outLocationName":item.inoutcationName,
                            "outLocationId":item.inoutcationId,
                        };
                        if(me.submitForm.entries.length){
                            var flag = true;
                            me.submitForm.entries.filter(function(self,index,arr){
                                if(self.invId == itemNew.invId){
                                    flag = false;
                                    me.submitForm.entries[index].qty = (Number(me.submitForm.entries[index].qty) + 1).toFixed(2);
                                }
                            });
                            if(flag){
                                me.submitForm.entries.push(itemNew);
                            }
                        }else{
                            me.submitForm.entries.push(itemNew);
                        }
                    }else{
                        me.submitForm.entries.splice(index,1);
                    }
                    me.$refs.goodsCheckBoxes[index].toggle();
                }
            },
            //商品拉取数据时
            goodsOnLoad(){
                //获取供货商列表
                var me = this;
                var para = me.goodsForm;
                axios.get(me.goodsApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        var form = {
                            current_page:response.data.data.current_page,
                            total:response.data.data.total,
                            last_page:response.data.data.last_page,
                            page:response.data.data.current_page + 1,
                            keyword:me.contactForm.keyword
                        };
                        me.goodsForm = form;
                        if(!response.data.data.next_page_url){
                            //数据已经读取完毕
                            me.goodsFinished = true;
                        }
                        if(me.goodsList.length){
                            me.goodsList = me.goodsList.concat(response.data.data.data);
                        }else{
                            me.goodsList =  response.data.data.data;
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
                }).catch(reject =>{
                    //关闭加载
                    me.goodsFinished = true;
                    me.$toast.fail('网络错误！');
                });
            },
            //商品查询
            goodsSearch(){
                var me = this;
                me.goodsLoading = true;
                me.goodsFinished = false;
                me.goodsForm.page = 1;
                me.goodsList = [];
                me.goodsOnLoad();

            },
            //开关商品选择列表
            goodsCancel(){
                var me = this;
                me.goodsShow = false;
            },
            //计算列表中的所有折扣额
            totalDeduction(){
                var me = this;
                var total = 0;
                me.submitForm.entries.filter(function(self,index,arr){
                    total += Number(self.deduction);
                });
                return total.toFixed(2);
            },
            //修改仓库
            localUpdate(item){
                var me = this;
                me.goodsInfo[me.nowType + 'LocationId'] = item.id;
                me.goodsInfo[me.nowType+ 'LocationName'] = item.name;
                me.locationShow = false;
            },
            //商品修改关闭
            goodsUpdateCancel(){
                var me = this;
                me.goodsUpdateShow = false;
                if(typeof me.goodsInfo.qty != 'string'){
                    me.goodsInfo.qty = me.goodsInfo.qty+'.00';
                }
            },
            //商品数量/单价修改
            goodsInfoUpdate(){
                var me = this;
                //同步更新数据
                var totalQty = 0;
                me.submitForm.entries.filter(function(self,index,arr){
                    totalQty += Number(self.qty);
                });
                me.submitForm.totalQty = totalQty.toFixed(2);
            },
            //检测修改价格内容
            validator(val){
                return /(^[1-9][0-9]{0,8}([.][0-9]{0,2})?$)|(^0?(\.[0-9]{0,2})?$)/.test(val);
            },
            //日期格式化
            formatDate(date) {
                return `${date.getFullYear()}-${'0' + (date.getMonth() + 1)}-${date.getDate() < 10 ? '0' + date.getDate() : date.getDate()}`;
            },
            onSubmit() {
                var me = this;
                var para = JSON.parse(JSON.stringify(me.submitForm));
                if(para.id > 0){
                    var api = me.updateApi;
                }else{
                    var api = me.api;
                    para.id = -1;
                    para.transType = 150501;
                    para.description = '';
                }
                var params = {postData:JSON.stringify(para)};
                axios.post(api, params).then(response => {
                    if(response.data.status == 'success'){
                        me.submitForm = JSON.parse(JSON.stringify(me.submitResetForm));
                        me.getBillNo();
                        me.$toast.success(response.data.msg);
                    }else{
                        if(response.data.status == 'noLogin'){
                            me.cookie.clearCookie('token');
                            me.$router.push({path:'/login'});
                        }
                        me.$toast.fail(response.data.msg);
                    }
                });
            },
            //点击修改商品列表的信息
            updateGoods(obj){
                var me = this;
                me.goodsUpdateShow = true;
                me.goodsInfo = obj;
            },
            //日历选择操作
            calendarClick(date) {
                var me = this;
                me.calenderShow = false;
                me.submitForm.date = me.formatDate(date);
            },
            //用户查询时
            customerSearch(){
                var me = this;
                me.finished = false;
                me.contactForm.page = 1;
                me.customerList = [];
            },
            //供应商点击操作
            customerClick(obj){
                var me = this;
                me.submitForm.buId = obj.id;
                me.submitForm.contactName = obj.name;
                me.buShow = false;
            },
            //供应商拉取数据时
            onLoad() {
                //获取供货商列表
                var me = this;
                var para = me.contactForm;
                para.type = 10;
                axios.get(me.contactApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        var form = {
                            current_page:response.data.data.current_page,
                            total:response.data.data.total,
                            last_page:response.data.data.last_page,
                            page:response.data.data.current_page + 1,
                            keyword:me.contactForm.keyword
                        };
                        me.contactForm = form;
                        if(!response.data.data.next_page_url){
                            //数据已经读取完毕
                            me.finished = true;
                        }
                        if(me.customerList.length){
                            me.customerList = me.customerList.concat(response.data.data.data);
                        }else{
                            me.customerList =  response.data.data.data;
                        }
                    }else{
                        if(response.data.status == 'noLogin'){
                            me.cookie.clearCookie('token');
                            me.$router.push({path:'/login'});
                        }
                        //关闭加载
                        me.finished = true;
                        me.$toast.fail(response.data.msg);
                    }
                    me.loading = false;
                }).catch(reject =>{
                    //关闭加载
                    me.finished = true;
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
            //获取订单编号
            getBillNo(){
                var me = this;
                axios.get('/api/getListCode/DB', {}).then(response => {
                    if(response.data.status == 'success'){
                        me.submitForm.billNo = response.data.data.code;
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
            }
        },
        mounted() {
            var me = this;
            me.token = window.localStorage.getItem('token');
            me.submitForm.date = me.formatDate(new Date());
            me.getLocation();
            me.$forceUpdate();
        },
        created() {
            var me = this;
            var year = (new Date()).getFullYear();
            var month = (new Date()).getMonth();
            var day = (new Date()).getDate();
            me.minDate = new Date(year,0,1);
            me.maxDate = new Date(year,month,day);
            me.getBillNo();
        },
        watch: {
            newValue(newVal,oldVal){
                var me = this;
                me.goodsInfoUpdate();
            },
            watchRpAmount(newVal,oldVal){
                var me = this;
                me.goodsInfoUpdate();
            },
            watchDisAmount(newVal,oldVal){
                var me = this;
                me.goodsInfoUpdate();
            }
        },
        computed: {
            //检测商品列表
            newValue() {
                return this.submitForm.entries;
            },
            //检测本次付款
            watchRpAmount(){
                return this.submitForm.rpAmount;
            },
            //检测优惠金额
            watchDisAmount(){
                return this.submitForm.disAmount;
            }
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
    .content {
        padding: 16px 16px 160px;
    }
</style>
