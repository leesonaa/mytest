<template>
    <div>
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">
            购货单
            <span style="float:right;">
                <van-button type="primary" size="small" @click="addBox">新增</van-button>
            </span>
        </h5>
        <van-field label="时间" placeholder="请点击选择查询时间" :value="searchForm.start ? searchForm.start + ' 至 ' + searchForm.end : ''" clickable readonly @click="dateShow = true" />
        <van-search
            v-model="searchForm.matchCon"
            show-action
            placeholder="输入单据号/供应商/序列号/备注查询"
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
                            :price="'采购总额：'+(item.totalAmount.toFixed(2))"
                            :desc="'采购单位：'+item.contactName"
                            :title="'采购单编号：'+item.billNo"
                            class="goods-card"
                            @click="updateBuy(item)"
                        >
                            <template #tags>
                                <div v-if="item.checked == 1" style="position: absolute;top:0;right:0;transform:rotate(-4deg);">
                                    <span style="font-size:1.2rem;font-weight: 700;border:.15rem solid red;color:#c20808;padding:.2rem .4rem;border-radius: .2rem;">已审核</span>
                                </div>
                                <div style="position: absolute;top:40%;right:0;">
                                    <van-button @click.stop="audit(1,item.id)" v-if="item.checked == 0" plain type="primary" size="mini">审核</van-button>
                                    <van-button @click.stop="audit(2,item.id)" v-if="item.checked == 1" plain type="danger" size="mini">反审核</van-button>
                                </div>
                                <!--                                <van-tag plain type="danger">规格：</van-tag>-->
<!--                                联系人：{{item.udf01}}<br/>-->
<!--                                联系电话：{{item.udf02}}<br/>-->
<!--                                联系地址：{{item.udf03}}-->
                            </template>
                            <template #footer>
                                采购日期：{{item.billDate}}&nbsp;&nbsp;&nbsp;&nbsp;付款状态：{{item.hxStateCode == 0 ? '未付款' : item.hxStateCode == 1 ? '部分付款' : '已付款'}}&nbsp;&nbsp;&nbsp;&nbsp;<br/>制单人：{{item.userName}}<br/>
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
                    采购单
                </van-divider>
                <van-form validate-first>
                    <van-field
                        v-model="submitForm.billNo"
                        type="text"
                        label="单据编号"
                        readonly
                    />
                    <van-field
                        readonly
                        clickable
                        v-model="submitForm.contactName"
                        label="供应商"
                        placeholder="请点击选择供应商"
                        @click="buShow = true"
                    />
                    <van-action-sheet v-model="buShow" title="供应商">
                        <div class="content">
                            <van-search
                                v-model="contactForm.keyword"
                                show-action
                                placeholder="输入客户编号/名称/联系人/电话查询"
                                @search="customerSearch"
                            >
                                <template #action>
                                    <div @click="customerSearch">搜索</div>
                                </template>
                            </van-search>
                            <van-list
                                v-model="loading"
                                :finished="finished"
                                finished-text="没有更多了"
                                @load="onLoad"
                            >
                                <van-radio-group v-model="submitForm.buId">
                                    <van-cell v-for="item in customerList" :key="item.id" :title="item.name" clickable @click="customerClick(item)">
                                        <template #right-icon >
                                            <van-radio :name="item" />
                                        </template>
                                    </van-cell>
                                </van-radio-group>
                            </van-list>
                        </div>
                    </van-action-sheet>
                    <van-field
                        readonly
                        clickable
                        v-model="submitForm.date"
                        label="日期"
                        placeholder="请点击日期"
                        @click="calenderShow=true"
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
                                <template #left>
                                    <scan
                                        :dataObj="{}"
                                        @scan="scanData"
                                    ></scan>
                                </template>
                                <template #left-icon>
                                </template>
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
                                    <van-cell v-for="(item,index) in goodsList"
                                              :key="item.id"
                                              :title="item.name+(item.barCode ? '(条码:'+item.barCode+')' : '')+(item.spec ? '(规格:'+item.spec+')' : '')"
                                              :data-index="item.id"
                                              clickable
                                              @click.stop="goodsClick(index,item)" >
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
                                    :price="item.price"
                                    :desc="item.invSpec"
                                    class="goods-card"
                                    @click="updateGoods(item)"
                                >
                                    <template #desc>
                                        <div style="display:flex;flex-direction:column;">
                                            <span>
                                                商品名称：{{submitForm.id ? item.goods : item.invName}}
                                            </span>
                                                        <span>
                                                商品编号：{{item.invNumber}}
                                            </span>
                                                        <span>
                                                商品条码：{{item.barCode}}
                                            </span>
                                        </div>
                                    </template>
                                    <template #footer>
                                        总金额：{{item.amount}}
                                    </template>
                                </van-card>
                                <template #right>
                                    <van-button square text="删除" type="danger" class="delete-button" @click="delGoods(index)" />
                                </template>
                            </van-swipe-cell>
                            <van-popup v-model="goodsUpdateShow" position="bottom" :style="{ height: '70%' }">
                                <div style="overflow: hidden;position: relative;">
                                    <van-button type="default" size="normal" style="float:left;" @click="goodsUpdateCancel">取消</van-button>
                                    <van-button type="default" size="normal" style="float:right" @click="goodsUpdateCancel">确认</van-button>
                                </div>
                                <div style="background:#eee;padding:5% 5% 0%;">
                                    <van-cell-group>
                                        <van-form validate-first>
                                            <van-field label="商品" v-model="goodsInfo.invName" readonly />
                                            <van-field label="单位" v-model="goodsInfo.mainUnit" readonly />
                                            <van-field label="仓库" v-model="goodsInfo.locationName" placeholder="请点击选择仓库" readonly clickable @click="locationShow = true" />
                                            <van-field label="数量" name="input">
                                                <template #input>
                                                    <van-stepper v-model="goodsInfo.qty" @change="goodsInfoUpdate"/>
                                                </template>
                                            </van-field>
                                            <van-field
                                                clearable
                                                label="单价"
                                                v-model="goodsInfo.price"
                                                name="validator"
                                                placeholder="请输入购货单价"
                                                @change="goodsInfoUpdate"
                                                :rules="[{ validator, message: '请输入正确内容' }]"
                                            />
                                            <van-field
                                                label="折扣率(%)"
                                                v-model="goodsInfo.discountRate"
                                                readonly
                                                disabled
                                            />
                                            <van-field
                                                label="折扣额"
                                                v-model="goodsInfo.deduction"
                                                placeholder="请输入折扣额"
                                                @change="goodsInfoUpdate"
                                                :rules="[{ validator, message: '请输入正确内容' }]"
                                                clearable
                                            />
                                            <van-field
                                                label="购货金额"
                                                v-model="goodsInfo.amount"
                                                readonly
                                                disabled
                                            />
                                        </van-form>
                                    </van-cell-group>
                                </div>
                            </van-popup>
                            <van-action-sheet v-model="locationShow" :actions="locationList" description="选择仓库" @select="localUpdate" />
                        </van-collapse-item>
                    </van-collapse>
                    <div v-if="submitForm.entries.length">
                        <van-cell title="合计(数量)" :value="submitForm.totalQty" />
                        <van-cell title="合计(折扣额)" :value="totalDeduction()" />
                        <van-cell title="合计(购货金额)" :value="submitForm.totalAmount" />
                    </div>
                    <van-field
                        disabled
                        readonly
                        v-model="submitForm.disRate"
                        label="优惠率"
                        input-align="right"
                    >
                        <template #right-icon>
                            %
                        </template>
                    </van-field>
                    <van-field
                        clearable
                        v-model="submitForm.disAmount"
                        label="优惠金额"
                        placeholder="请输入优惠金额"
                        input-align="right"
                        :rules="[{ validator, message: '请输入正确内容' }]"
                    >
                    </van-field>
                    <van-field
                        disabled
                        readonly
                        v-model="submitForm.amount"
                        label="优惠后金额"
                        input-align="right"
                    >
                    </van-field>
                    <van-field
                        clearable
                        v-model="submitForm.rpAmount"
                        label="本次付款"
                        placeholder="请输入付款金额"
                        input-align="right"
                        :rules="[{ validator, message: '请输入正确内容' }]"
                    >
                    </van-field>
                    <van-field
                        disabled
                        readonly
                        v-model="submitForm.arrears"
                        label="本次欠款"
                        input-align="right"
                    >
                    </van-field>
                    <van-button :disabled="submitForm.checked == 1" type="info" block @click="onSubmit">保存</van-button>
                </van-form>
            </div>
        </van-popup>
    </div>
</template>
<script>
    import Scan from './common/scan'
    export default {
        components:{
            Scan
        },
        data() {
            return {
                listLoading:false,
                buyLoading:false,
                buyFinished:false,
                dateShow:false,
                buyBoxShow:false,
                api:'/api/invPu/addNew',
                contactApi:'/api/getContactList',
                goodsApi:'/api/getGoodsList',
                buyApi:'/api/invPu/getBuyList',
                activeNames:['1'],
                submitForm:{
                    billNo:'',
                    token:'',
                    contactName:'',
                    buId:5,
                    date:'',
                    entries:[],
                    totalAmount:0,
                    totalQty:0,
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
                    totalAmount:0,
                    totalQty:0,
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
                searchForm:{pageSize:10},
                buyList:[],
                buyInfoApi:'/api/invPu/getInfo',
                updateApi:'/api/invPu/update',
            };
        },
        methods: {
            audit(type,id){
                const me = this;
                let api = '/api/invPu/' + (type === 1 ? 'checkInvPu' : 'revsCheckInvPu');
                me.$dialog.confirm({
                    title: '确认',
                    message:
                        (type !== 1 ? '反' : '')+'审核订单',
                }).then(() => {
                    // on confirm
                    axios.post(api, {id:id}).then(response => {
                        if(response.data.status == 'success'){
                            me.$toast.success(response.data.msg);
                            setTimeout(function(){
                                me.onRefresh();
                            },1000)
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
                }).catch(() => {
                    // on cancel
                });
            },
            scanData(val){
                const me = this;
                me.goodsForm.keyword = val;
                me.goodsSearch();
            },
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
                axios.get(me.buyApi, {params:para}).then(response => {
                    let {status,data} = response.data;
                    if(status == 'success'){
                        if(me.searchForm.page == 1){
                            me.buyList =  data.data;
                        }else{
                            if(me.buyList.length){
                                me.buyList = me.buyList.concat(data.data);
                            }else{
                                me.buyList =  data.data;
                            }
                        }
                        var form = {
                            current_page:data.current_page,
                            total:data.total,
                            page:parseInt(data.current_page) + 1,
                            matchCon:me.searchForm.matchCon,
                            pageSize:10,
                        };
                        me.searchForm = form;
                        if(parseInt(data.current_page) === data.last_page || data.last_page === 0){
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
                axios.get(me.buyInfoApi, {params:para}).then(response => {
                    if(response.data.status == 'success'){
                        me.submitForm = response.data.data;
                        //me.submitForm.disAmount = '';
                        //me.submitForm.rpAmount = '';
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
                            "barCode":item.barCode,
                            "skuId":-1,
                            "skuName":"",
                            "unitId":-1,
                            "mainUnit":item.unitName,
                            "qty":"1.00",
                            "price":item.purPrice.toFixed(2),
                            "discountRate":"0",
                            "deduction":"0.00",
                            "amount":item.purPrice.toFixed(2),
                            "locationId":item.locationId,
                            "locationName":item.locationName,
                            "serialno":"",
                            "description":"",
                            "srcOrderEntryId":"0",
                            "srcOrderId":"0",
                            "srcOrderNo":""
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
                me.goodsInfo.locationId = item.id;
                me.goodsInfo.locationName = item.name;
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
                me.goodsInfo.amount = me.goodsInfo.price * me.goodsInfo.qty;
                if(me.goodsInfo.deduction != '0.00'){
                    me.goodsInfo.discountRate = (me.goodsInfo.deduction / me.goodsInfo.amount) * 100;
                    me.goodsInfo.discountRate = me.goodsInfo.discountRate.toFixed(2);
                    me.goodsInfo.amount -=  me.goodsInfo.deduction;
                }
                me.goodsInfo.price = Number(me.goodsInfo.price).toFixed(2);
                me.goodsInfo.deduction = Number(me.goodsInfo.deduction).toFixed(2);
                me.goodsInfo.amount = me.goodsInfo.amount.toFixed(2);
                //同步更新数据
                var totalAmount = 0;
                var totalQty = 0;
                me.submitForm.entries.filter(function(self,index,arr){
                    totalQty += Number(self.qty);
                    totalAmount += Number(self.amount);
                });
                me.submitForm.totalAmount = totalAmount.toFixed(2);
                me.submitForm.totalQty = totalQty.toFixed(2);
                if(me.submitForm.disAmount){
                    me.submitForm.disRate = (me.submitForm.disAmount/totalAmount).toFixed(2);
                    me.submitForm.amount = (me.submitForm.totalAmount - me.submitForm.disAmount).toFixed(2);
                }
                if(me.submitForm.rpAmount){
                    me.submitForm.arrears = (me.submitForm.amount - me.submitForm.rpAmount).toFixed(2);
                }else{
                    me.submitForm.arrears = me.submitForm.amount;
                }
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
                if(me.submitForm.disAmount == ''){
                    return me.$toast.fail('请补全优惠金额再提交！');
                }
                if(me.submitForm.rpAmount == ''){
                    return me.$toast.fail('请补全付款金额再提交！');
                }
                var para = JSON.parse(JSON.stringify(me.submitForm));
                if(para.id > 0){
                    var api = me.updateApi;
                }else{
                    var api = me.api;
                    para.id = -1;
                    para.transType = 150501;
                    para.description = '';
                    para.serialno = '';
                    para.accId = 0;
                }
                para.totalArrears = '';
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
                axios.get('/api/getListCode/CG', {}).then(response => {
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
