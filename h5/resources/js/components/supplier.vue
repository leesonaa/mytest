<template>
    <div>
        <!--   头部start     -->
        <h5 style="color:#999;padding:3% 5% 3%;background:#eee;font-size:1.1rem;display: flex;align-items: center;justify-content: space-between;">
            <span>供应商管理</span>
            <van-button type="primary" size="small" @click="addBox">新增</van-button>
        </h5>
        <!--   头部end     -->
        <!--   查询start     -->
        <van-search
            v-model="form.keyword"
            show-action
            placeholder="输入供应商编号/ 名称/ 联系人/ 电话查询"
        >
            <template #action>
                <van-button type="info" size="small" @click="onSearch">搜索</van-button>
            </template>
        </van-search>
        <!--   查询end     -->
        <!--   列表start     -->
        <div style="padding:3%">
            <van-pull-refresh v-model="isLoading" @refresh="onRefresh">
                <van-list
                    v-model="goodsLoading"
                    :finished="finished"
                    finished-text="没有更多了"
                    @load="getCustomerList"
                >
                    <van-swipe-cell v-for="(item,index) in customerList" :key="index" style="margin-bottom: 5%;">
                        <van-card
                            :num="item.qty"
                            :desc="'供应商名称：'+item.name"
                            :title="'供应商编号：'+item.number"
                            class="goods-card"
                            @click="update(item)"
                        >
                            <!--                            <template #price>-->
                            <!--                            </template>-->
                            <template #tags>
                                <div style="display:flex;flex-direction: column;text-align: left;">
                                    <div>
                                        供应商类别：{{item.customerType}}
                                    </div>
                                    <div>
                                        供应商税率：{{item.taxRate}}%
                                    </div>
                                    <div>联系人：{{item.contacter ? item.contacter : ''}}</div>
                                    <div>手机 ：{{item.mobile ? item.mobile : ''}}</div>
                                    <div>职位 ：{{item.place ? item.place : ''}}</div>
                                </div>

                            </template>
                            <template #footer>
                                <div style="display:flex;flex-direction: column;text-align: left;">
                                    <div>
                                        qq:{{item.linkIm}}
                                    </div>
                                    <div>
                                        期初往来余额:{{item.difMoney}}元
                                    </div>
                                    <div>
                                        地址:{{item.province}}{{item.city}}{{item.county}}{{item.deliveryAddress}}
                                    </div>
                                </div>
                            </template>
                        </van-card>
                        <template #right>
                            <van-button square text="删除" type="danger" class="delete-button" @click="del(index)" />
                        </template>
                    </van-swipe-cell>
                </van-list>
            </van-pull-refresh>
            <van-popup v-model="boxShow" position="bottom" closeable :style="{ height: '90%' }" @closed="chanel">
                <van-cell-group>
                    <van-form validate-first>
                        <van-divider
                            :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' ,margin:'15% 0% 0%'}"
                        >
                            供应商信息
                        </van-divider>
                        <van-field label="供应商编号" placeholder="请填写供应商编号" v-model="submitForm.number"  required :rules="[{ required: true, message: '请填写供应商编号' }]" />
                        <van-field label="供应商名称" placeholder="请填写供应商名称" v-model="submitForm.name" required :rules="[{ required: true, message: '请填写供应商名称' }]" />
                        <van-field label="供应商类别" placeholder="请点击选择分类" v-model="submitForm.cCategoryName" clickable readonly @click="typeBoxShow = true;" />
                        <van-popup v-model="typeBoxShow" position="bottom">
                            <van-picker
                                show-toolbar
                                :columns="typeList"
                                value-key="name"
                                @confirm="(v)=>onConfirm(v,1)"
                                @cancel="typeBoxShow = false"
                            />
                        </van-popup>
                        <van-field label="余额日期" v-model="submitForm.beginDate" clickable readonly @click="cShow = true;" />
                        <van-calendar :min-date="minDate" :max-date="maxDate" v-model="cShow" @confirm="(v)=>onConfirm(v,3)" />
                        <van-field label="期初应收款" v-model="submitForm.amount" />
                        <van-field label="期初预收款" v-model="submitForm.periodMoney" />
                        <van-field label="增值税税率" v-model="submitForm.taxRate" input-align="right" >
                            <template #right-icon>
                                %
                            </template>
                        </van-field>
                        <!--                        <van-divider-->
                        <!--                            :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"-->
                        <!--                        >-->
                        <!--                            联系人-->
                        <!--                        </van-divider>-->
                        <van-contact-card type="add" @click="onAdd"  style="margin-bottom:3px;" />
                        <van-collapse v-model="activeNames" v-if="submitForm.linkMans && submitForm.linkMans.length > 0">
                            <van-collapse-item name="1">
                                <template #title>
                                    <div style="text-align:center;color:rgb(25, 137, 250);">联系人（点击展开/关闭）</div>
                                </template>
                                <van-swipe-cell v-for="(item,index) in submitForm.linkMans" :key="index" style="margin-bottom: 5%;">
                                    <van-card
                                        class="goods-card"
                                        @click="updateLink(item,index)"
                                    >
                                        <template #title>
                                            <div>
                                                <div>
                                                    联系人：{{item.linkName}}
                                                </div>
                                                <div>
                                                    手机：{{item.linkMobile}}
                                                </div>
                                                <div>
                                                    职位：{{item.linkPlace}}
                                                </div>
                                                <div>
                                                    联系地址：{{item.province}}{{item.city}}{{item.county}}{{item.deliveryAddress}}
                                                </div>
                                            </div>
                                        </template>
                                        <template #price>
                                            是否首选联系人：{{item.linkFirst == 1 ? '是' : '否'}}
                                        </template>
                                    </van-card>
                                    <template #right>
                                        <van-button square text="删除" type="danger" class="delete-button" @click="delLink(index)" />
                                    </template>
                                </van-swipe-cell>
                                <van-popup v-model="linkUpdateShow" position="bottom" :style="{ height: '70%' }">
                                    <div style="overflow: hidden;position: relative;">
                                        <van-button type="default" size="normal" style="float:left;" @click="linkCancel">取消</van-button>
                                        <van-button type="default" size="normal" style="float:right" @click="linkCancel">确认</van-button>
                                    </div>
                                    <div style="background:#eee;padding:5% 5% 0%;">
                                        <van-cell-group>
                                            <van-form validate-first>
                                                <van-field label="联系人" v-model="linkInfo.linkName"  />
                                                <van-field label="手机" v-model="linkInfo.linkMobile"  />
                                                <van-field label="座机" v-model="linkInfo.linkPhone"   />
                                                <van-field label="职位" v-model="linkInfo.linkPlace"  />
                                                <van-field label="qq/im" v-model="linkInfo.linkIm"  />
                                                <van-field label="地区" :value="linkInfo.province+linkInfo.city+linkInfo.county" clickable readonly @click="areaShow = true;"  />
                                                <van-popup v-model="areaShow" position="bottom">
                                                    <van-area title="请选择地区"  :area-list="areaList" :columns-num="3" :columns-placeholder="['请选择', '请选择', '请选择']" @confirm="areaSelect" />
                                                </van-popup>
                                                <van-field label="联系地址" v-model="linkInfo.address"  />
                                                <van-cell center title="是否首选联系人">
                                                    <template #right-icon>
                                                        <van-switch :value="linkInfo.linkFirst == 1 ? true : false" @input="(check)=>onInput(check)" />
                                                    </template>
                                                </van-cell>
                                            </van-form>
                                        </van-cell-group>
                                    </div>
                                </van-popup>
                            </van-collapse-item>
                        </van-collapse>
                        <van-button type="info" block @click="onSubmit">保存</van-button>
                    </van-form>
                </van-cell-group>
            </van-popup>
        </div>
        <!--   列表end     -->
    </div>
</template>

<script>
import { areaList } from '@vant/area-data';
export default {
    name: "customer",
    data(){
        return {
            areaList,
            customerApi:'/api/getContactList',
            delApi:'/api/contact/del',
            addApi:'/api/contact/add',
            updateApi:'/api/contact/update',
            typeApi:'/api/assist/list',
            form:{
                keyword:'',
                isDelete:2,
                _search:false,
                rows:20,
                page:1,
                sidx:'',
                sord:'asc',
                categoryId:'-1',
                type:10,
            },
            areaShow:false,
            linkUpdateShow:false,
            minDate: new Date(2015, 0, 1),
            maxDate: new Date(2038, 0, 31),
            cShow:false,
            levelShow:false,
            typeBoxShow:false,
            categoryShow:false,
            boxShow:false,
            finished:false,
            isLoading:false,
            customerLoading:false,
            goodsLoading:false,
            customerList:[],
            typeList:[],
            activeNames:['1'],
            levelList:[{
                id: 0,
                name: "零售客户"
            }, {
                id: 1,
                name: "批发客户"
            }, {
                id: 2,
                name: "VIP客户"
            }, {
                id: 3,
                name: "折扣等级一"
            }, {
                id: 4,
                name: "折扣等级二"
            }],
            submitForm:{

            },
            linkInfo:{},
            linkIndex:0,
            nowLinkIndex:0,
        }
    },
    methods:{
        onSearch(){
            const me = this;
            me.form.page = 1;
            me.getCustomerList();
        },
        addBox(){
            const me = this;
            me.submitForm = {};
            me.boxShow = true;
        },
        onSubmit(){
            const me = this;
            let api = me.updateApi;
            if(!me.submitForm.id){
                api = me.addApi;
            }
            let para = JSON.parse(JSON.stringify(me.submitForm));
            if(para.linkMans){
                para.linkMans = JSON.stringify(para.linkMans);
            }
            axios.post(api + '?type=10', para).then(res => {
                let {success,msg} = res.data;
                if(success){
                    me.boxShow = false;
                    me.$toast.success(msg);
                    me.getCustomerList();
                }else{
                    me.$toast.fail(msg);
                }
            });
        },
        //添加联系人
        onAdd(){
            const me = this;
            if(!me.submitForm.linkMans){
                me.submitForm.linkMans = [];
            }
            me.submitForm.linkMans.push({linkFirst:0});
            me.$forceUpdate();
        },
        areaSelect(area){
            const me = this;
            let msg = ['请选择省','请选择市','请选择区'];
            let data = ['province','city','county'];
            area.map((m,i) =>{
                if(!m.name){
                    me.$toast.fail(msg[i]+'再提交！');
                    return
                }
                me.linkInfo[data[i]] = m.name;
            });
            me.areaShow = false;
        },
        onInput(checked){
            const me = this;
            if(checked === true){
                me.linkInfo.linkFirst = 1;
                if(me.submitForm.linkMans.length > 1){
                    me.submitForm.linkMans[me.linkIndex].linkFirst = 0;
                }
                me.linkIndex = me.nowLinkIndex;
            }else{
                me.linkInfo.linkFirst = 0;
                me.linkIndex = -1;
            }
        },
        //联系人修改关闭
        linkCancel(){
            var me = this;
            me.linkUpdateShow = false;
        },
        //点击修改联系人的信息
        updateLink(obj,index){
            var me = this;
            me.linkUpdateShow = true;
            me.linkInfo = obj;
            me.nowLinkIndex = index;
        },
        delLink(index){
            this.submitForm.linkMans.splice(index,1);
            this.$forceUpdate();
        },
        formatDate(date) {
            return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
        },
        //选择类别
        onConfirm(value,type){
            const me = this;
            if(type === 1){
                me.submitForm.cCategory = value.id;
                me.submitForm.cCategoryName = value.name;
                me.typeBoxShow = false;
            }else if(type === 2){
                me.submitForm.cLevel = value.id;
                me.submitForm.cLevelName = value.name;
                me.levelShow = false;
            }else{
                me.submitForm.beginDate = me.formatDate(value);
                me.cShow = false;
            }
        },

        update(obj){
            var me = this;
            me.submitForm = JSON.parse(JSON.stringify(obj));
            if(me.submitForm.linkMans.length > 0){
                me.submitForm.linkMans = JSON.parse(me.submitForm.linkMans);
            }
            me.boxShow = true;
        },
        chanel(){
            var me = this;
            me.submitForm = {};
        },
        del(index){
            const me = this;
            if(me.customerList[index]){
                let para = {id:me.customerList[index].id};
                axios.post(me.delApi, para).then(res => {
                    let {success,msg} = res.data;
                    if(success){
                        me.$toast.success(msg);
                        me.customerList.splice(index,1);
                    }else{
                        me.$toast.fail(msg);
                    }
                });
            }else{
                me.$toast.fail('信息不存在，请刷新重试');
            }
        },
        getTypeList(){//获取客户类别列表
            const me = this;
            axios.get(me.typeApi, {params:{typeNumber:'supplytype',name:'供应商',isDelete:2,pageSize:5000,type:10}}).then(res => {
                let {success,data,msg} = res.data;
                if(success){
                    me.typeList =  data.data;
                }else{
                    me.$toast.fail(msg);
                }
                me.goodsLoading = false;
            }).catch(reject =>{
                me.goodsLoading = false;
                me.$toast.fail(reject);
            });
        },
        getCustomerList(){
            const me = this;
            if(me.goodsLoading){
                return;
            }
            me.goodsLoading = true;
            axios.get(me.customerApi, {params:me.form}).then(res => {
                let {success,data,msg} = res.data;
                if(success){
                    if(me.form.page == 1){
                        me.customerList =  data.data;
                    }else{
                        if(me.customerList.length){
                            me.customerList = me.customerList.concat(data.data);
                        }else{
                            me.customerList =  data.data;
                        }
                    }
                    me.form.page += 1;
                    if(!data.next_page_url){
                        //数据已经读取完毕
                        me.finished = true;
                    }
                }else{
                    me.$toast.fail(msg);
                }
                me.goodsLoading = false;
                me.isLoading = false;
            }).catch(reject =>{
                me.goodsLoading = false;
                me.isLoading = false;
                me.$toast.fail(reject);
            });
        },
        //下拉刷新
        onRefresh(){
            var me = this;
            me.form.page = 1;
            me.finished = false;
            me.getCustomerList();
        },
    },
    mounted() {

    },
    created() {
        var me = this;
        me.getTypeList();
        me.getCustomerList();
    },
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
