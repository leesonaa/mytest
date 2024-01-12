<template>
    <div>
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;">
            其他出库单
            <span style="float:right;">
                <van-button type="primary" size="small" @click="addBox">新增</van-button>
            </span>
        </h5>
        <van-field label="时间" placeholder="请点击选择查询时间" :value="searchForm.start ? searchForm.start + ' 至 ' + searchForm.end : ''" clickable readonly @click="dateShow = true" />
        <van-search
            v-model="searchForm.matchCon"
            show-action
            placeholder="输入单据号/客户名/序列号/备注查询"
        >
            <template #action>
                <van-button type="info" size="small" @click="onSearch">搜索</van-button>
            </template>
        </van-search>
        <van-calendar v-model="dateShow" type="range" :min-date="minDate" :max-date="maxDate" @confirm="dateQuery" />
        <div style="padding:3%">
            <van-pull-refresh v-model="listLoading" @refresh="onRefresh">
                <van-list
                    v-model="loading"
                    :finished="finished"
                    finished-text="没有更多了"
                    @load="onLoad"
                >
                    <van-swipe-cell v-for="(item,index) in list" :key="index" style="margin-bottom: 5%;">
                        <van-card
                            :price="'金额：'+(item.totalAmount.toFixed(2))"
                            :desc="'客户：'+item.contactName"
                            :title="'其他出库单编号：'+item.billNo"
                            class="goods-card"
                            @click="edit(item)"
                        >
                            <template #tags>
                                <div v-if="item.checked == 1" style="position: absolute;top:0;right:0;transform:rotate(-4deg);">
                                    <span style="font-size:1.2rem;font-weight: 700;border:.15rem solid red;color:#c20808;padding:.2rem .4rem;border-radius: .2rem;">已审核</span>
                                </div>

                            </template>
                            <template #footer>

                            </template>
                        </van-card>
                        <template #right>
                            <van-button square text="删除" type="danger" class="delete-button" @click="del(index)" />
                        </template>
                    </van-swipe-cell>
                </van-list>
            </van-pull-refresh>
        </div>
        <van-popup v-model="boxShow" position="bottom" closeable :style="{ height: '90%' }" @closed="cancel">
            <div style="margin-top:15%;">
                <van-divider
                    :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"
                >
                    其他出库单
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
                        label="客户"
                        placeholder="请点击选择客户"
                        @click="$refs.customerSelect.open()"
                    />
                    <customer-select ref="customerSelect" @select="contactSelect"></customer-select>
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
                        @click="$refs.goodsSelect.show(submitForm.entries)"
                    />
                    <goods-select :isOut="true" ref="goodsSelect" @query="queryGoods"></goods-select>
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
                                                disabled
                                            />
                                            <van-field
                                                label="出库金额"
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
                    <van-button type="info" block @click="onSubmit">保存</van-button>
                </van-form>
            </div>
        </van-popup>
    </div>
</template>

<script>
import GoodsSelect from '../components/common/goods-select.vue';
import CustomerSelect from "../components/common/customer-select";
export default {
    name: "outbound",
    components:{
        GoodsSelect,
        CustomerSelect
    },
    data(){
        return {
            searchForm:{
                page:1,
                size:10,
            },
            locationShow:false,
            dateShow:false,
            listLoading:false,
            minDate: '',
            maxDate: '',
            submitForm:{
                id:0,
                billNo:'',
                buId:0,
                date:'',
                contactName:'',
                totalAmount:0,
                totalQty:0,
                entries:[],
            },
            submitReset:{
                id:0,
                billNo:'',
                buId:0,
                date:'',
                contactName:'',
                totalAmount:0,
                totalQty:0,
                entries:[],
            },
            //检测修改价格内容
            validator(val){
                return /(^[1-9][0-9]{0,8}([.][0-9]{0,2})?$)|(^0?(\.[0-9]{0,2})?$)/.test(val);
            },
            loading:false,
            finished:false,
            list:[],
            boxShow:false,
            calenderShow:false,
            activeNames:['1'],
            selectList:[],
            goodsList:[],
            locationList:[],
            goodsInfo:{},
            goodsUpdateShow:false,
            storageApi:'/api/storage',
            addApi:'/api/invOi/outAdd',
            editApi:'/api/invOi/outEdit',
            listApi:'/api/invOi/outList',
            infoApi:'/api/invOi/outInfo',
        }
    },
    methods: {
        contactSelect(select){//客户选中
            this.submitForm.buId = select.id;
            this.submitForm.contactName = select.name;
        },
        //打开新增框体
        addBox(){
            var me = this;
            me.getBillNo();
            me.boxShow = true;
        },
        queryGoods(list){
            const me = this;
            me.submitForm.entries = list;
        },
        //获取订单编号
        async getBillNo(){
            const me = this;
            let rep = await axios.get('/api/getListCode/QTCK', {});
            let {status,data,msg} = rep.data;
            if(status === 'success'){
                me.submitForm.billNo = data.code;
            }else if(status === 'noLogin'){
                me.cookie.clearCookie('token');
                me.$router.push({path:'/login'});
                me.$toast.fail(msg);
            }else{
                me.$toast.fail('网络错误！');
            }
        },
        onSearch(){
            this.searchForm.page = 1;
            this.onLoad();
        },
        goodsInfoUpdate(){
            this.goodsInfo.amount = this.goodsInfo.price * this.goodsInfo.qty;
            this.goodsInfo.amount = this.goodsInfo.amount.toFixed(2);
        },
        //商品修改关闭
        goodsUpdateCancel(){
            const me = this;
            me.goodsUpdateShow = false;
            if(typeof me.goodsInfo.qty != 'string'){
                me.goodsInfo.qty = me.goodsInfo.qty+'.00';
            }
        },
        //删除商品操作
        delGoods(index){
            const me = this;
            me.submitForm.entries.splice(index,1);
        },
        //供应商点击操作
        customerClick(obj){
            const me = this;
            me.submitForm.buId = obj.id;
            me.submitForm.contactName = obj.name;
            me.buShow = false;
        },
        //修改仓库
        localUpdate(item){
            const me = this;
            me.goodsInfo.locationId = item.id;
            me.goodsInfo.locationName = item.name;
            me.locationShow = false;
        },
        //获取仓库列表
        getLocation(){
            const me = this;
            axios.get(me.storageApi, {}).then(res => {
                let {status,data,msg} = res.data;
                if(status === 'success'){
                    me.locationList = data;
                }else{
                    if(status === 'noLogin'){
                        me.cookie.clearCookie('token');
                        me.$router.push({path:'/login'});
                    }
                    me.$toast.fail(msg);
                }
            }).catch(reject =>{
                me.$toast.fail('网络错误！');
            });
        },
        dateQuery(val){
            let me = this;
            me.searchForm.start = me.formatDate(val[0]);
            me.searchForm.end = me.formatDate(val[1]);
            me.dateShow = false;
        },
        onRefresh(){
            this.searchForm.page = 1;
            this.finished = false;
            this.onLoad();
        },
        async onLoad(){
            const me = this;
            let rep = await axios.get(me.listApi, {params:me.searchForm});
            let {status,data,msg} = rep.data;
            if(status === 200){
                me.list = data.rows;
                if(!data.next_page_url){
                    me.finished = true;
                }
                me.listLoading = false;
            }else{
                if(msg === 'noLogin'){
                    me.cookie.clearCookie('token');
                    me.$router.push({path:'/login'});
                }
                me.$toast.fail(msg);
            }
        },
        async edit(obj){
            const me = this;
            let para = {id:obj.id};
            let rep = await axios.get(me.infoApi, {params:para});
            let {status,data,msg} = rep.data;
            if(msg === 'success') {
                me.submitForm = data;
                me.boxShow = true;
            }else{
                if(msg === 'noLogin'){
                    me.cookie.clearCookie('token');
                    me.$router.push({path:'/login'});
                }
                me.$toast.fail(msg);
            }
        },
        del(){

        },
        //点击修改商品列表的信息
        updateGoods(obj){
            var me = this;
            me.goodsUpdateShow = true;
            me.goodsInfo = obj;
        },
        cancel(){
            this.submitForm = JSON.parse(JSON.stringify(this.submitReset));
        },
        //日期格式化
        formatDate(date) {
            return `${date.getFullYear()}-${'0' + (date.getMonth() + 1)}-${date.getDate() < 10 ? '0' + date.getDate() : date.getDate()}`;
        },
        //日历选择操作
        calendarClick(date) {
            var me = this;
            me.calenderShow = false;
            me.submitForm.date = me.formatDate(date);
        },
        async onSubmit() {
            const me = this;
            let para = JSON.parse(JSON.stringify(me.submitForm));
            let api = me.editApi;
            if(para.id === 0){
                api = me.addApi;
                para.id = -1;
                para.description = '';
            }
            para.transTypeName = '其他出库';
            para.transTypeId = 150806;
            if(para.entries.length === 0){
                me.$toast.fail('请添加商品！');
                return;
            }
            para.totalAmount = 0;
            para.totalQty = 0;
            para.entries.map(map=>{
                para.totalQty += parseInt(map.qty);
                para.totalAmount += parseInt(map.amount);
            });
            para.totalAmount = para.totalAmount + '.00';
            para.totalQty = para.totalQty+'.00';
            let rep = await axios.post(api, para);
            let {status,data,msg} = rep.data;
            if(status === 'success') {
                me.submitForm = JSON.parse(JSON.stringify(me.submitReset));
                await me.getBillNo();
                me.$toast.success(msg);
            }else{
                if(status === 'noLogin'){
                    me.cookie.clearCookie('token');
                    me.$router.push({path:'/login'});
                }
                me.$toast.fail(msg);
            }
        },
    },
    mounted(){
        this.getLocation();
    },
    created() {
        let year = (new Date()).getFullYear();
        let month = (new Date()).getMonth();
        let day = (new Date()).getDate();
        this.minDate = new Date(year,0,1);
        this.maxDate = new Date(year,month,day);
        this.getBillNo();
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
